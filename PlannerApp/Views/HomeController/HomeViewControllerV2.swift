//
//  HomeViewControllerV2.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 23/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar
import CoreImage
import SwiftyUserDefaults
import UserNotifications
import CoreLocation

class HomeViewControllerV2: ViewControllerProtocol,NoNavbar,FSCalendarDelegateAppearance {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let viewModel = TodoListViewModel()
    
    fileprivate var clonedData: [AddNote] = []
    fileprivate let tableView = SelfSizedTableView()
    
//    fileprivate let imageView = UIImageView()
    fileprivate var context = CIContext(options: nil)
    fileprivate let scrollView = UIScrollView()
    fileprivate let contentView = UIView()
    
    fileprivate let headerView = UIStackView()
    fileprivate let greetingsLabel = UILabel()
    fileprivate let appointmentLabel = UILabel()
    
    fileprivate let headerCountsView = UIStackView()
    fileprivate let followUpsView = DashHeaderView()
    fileprivate let appointmentsView = DashHeaderView()
    fileprivate let birthdayView = DashHeaderView()
    
    fileprivate let calendarLabelLeftButton = LeftIconButton()
    fileprivate let calendarLabelRightButton = RightIconButton()
    fileprivate let buttonMapSubView = UIView()
    
    fileprivate let calendarStackView = UIStackView()
    fileprivate let calendarView = FSCalendar()
    fileprivate let mapView = MapView()
    fileprivate let buttonMapView = UIView()
    fileprivate let buttonExpand = RightIconButton()
    fileprivate let moreLessButton = RightIconButton()
    fileprivate let headerBGView = GradientView()
    private var locationManager = CLLocationManager()
    
    let previousCalendarButton = ActionButton()
    let nextCalendarButton = ActionButton()
    var badgeLabel = UILabel();
    
    // for apple map navigate used
    var coordinateLong:Double = 0.00
    var coordinateLat:Double = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.updateApplicationBadge(count: 0);
//        imageView.isUserInteractionEnabled = true
//        imageView.image = UIImage(named: "contact-details-gradiant-bg")
        mapView.delegate = self
        getCurrentLocation()
        viewModel.getGreetingByTime()
        view.backgroundColor = .clear
        
        headerBGView.colors = [CommonColor.grayColor.cgColor,UIColor.white.cgColor]
        view.addSubview(headerBGView)
        
        headerView.axis = .vertical
        headerView.alignment = .leading
        headerView.spacing = 10
        view.addSubview(headerView)
        
        greetingsLabel.textColor = .white
        greetingsLabel.backgroundColor = .clear
        headerView.addArrangedSubview(greetingsLabel)
        
        appointmentLabel.textColor = .white
        appointmentLabel.backgroundColor = .clear
        appointmentLabel.font = UIFont.ofSize(fontSize: 17, withType: .regular)
        headerView.addArrangedSubview(appointmentLabel)
        
        headerCountsView.axis = .horizontal
        headerCountsView.distribution = .fillEqually
        headerCountsView.spacing = 5
        view.addSubview(headerCountsView)
        
        followUpsView.backgroundColor = CommonColor.purpleColor
//        followUpsView.sideIcon.image = UIImage(named: "follow-up-icon")
        followUpsView.labelBelow.text = "Customers"
        followUpsView.translatesAutoresizingMaskIntoConstraints = true
        headerCountsView.addArrangedSubview(followUpsView)
        
        appointmentsView.backgroundColor = CommonColor.turquoiseColor
//        appointmentsView.sideIcon.image = UIImage(named: "sideIcon")
        appointmentsView.labelBelow.text = "Appointment"
        appointmentsView.translatesAutoresizingMaskIntoConstraints = true
        headerCountsView.addArrangedSubview(appointmentsView)
        
        birthdayView.backgroundColor = CommonColor.redColor
//        birthdayView.sideIcon.image = UIImage(named: "sideIcon")
        birthdayView.labelBelow.text = "Birthday"
        birthdayView.translatesAutoresizingMaskIntoConstraints = true
        headerCountsView.addArrangedSubview(birthdayView)
        
        scrollView.backgroundColor = .clear
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        contentView.backgroundColor = CommonColor.grayColor
        scrollView.addSubview(contentView)
        
        buttonMapSubView.backgroundColor = .white
        contentView.addSubview(buttonMapSubView)
        
        calendarLabelLeftButton.setTitle("\(convertDateTimeToString(date: Date(),dateFormat: "dd MMM yyyy"))", for: .normal)
        calendarLabelLeftButton.setTitleColor(.black, for: .normal)
        calendarLabelLeftButton.isHidden = true
        calendarLabelLeftButton.setImage(UIImage(named: "calendar-dash-icon"), for: .normal)
        calendarLabelLeftButton.titleLabel?.font = UIFont.ofSize(fontSize: 15, withType: .regular)
        buttonMapSubView.addSubview(calendarLabelLeftButton)
        
        calendarLabelRightButton.setTitle("Calendar", for: .normal)
        calendarLabelRightButton.setTitleColor(.black, for: .normal)
        calendarLabelRightButton.isSelected = false
        calendarLabelRightButton.setImage(UIImage(named: "switch-on-icon"), for: .normal)
        calendarLabelRightButton.setImage(UIImage(named: "switch-off-icon"), for: .selected)
        calendarLabelRightButton.addTarget(self, action: #selector(hideShowCalendar), for: .touchUpInside)
        calendarLabelRightButton.titleLabel?.font = UIFont.ofSize(fontSize: 15, withType: .regular)
        buttonMapSubView.addSubview(calendarLabelRightButton)
        
        calendarStackView.distribution = .fillProportionally
        calendarStackView.spacing = 0
        calendarStackView.axis = .vertical
        contentView.addSubview(calendarStackView)
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.allowsMultipleSelection = false
        calendarView.backgroundColor = .white
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        calendarView.appearance.todayColor = .darkGray
        calendarView.appearance.separators = .interRows
        calendarView.appearance.selectionColor = UIColor(rgb:0x9ACD32)
        calendarView.appearance.todaySelectionColor = UIColor(rgb:0x6B8E23)
        calendarView.calendarWeekdayView.backgroundColor = UIColor.clear
        calendarView.appearance.headerTitleFont = UIFont.ofSize(fontSize: 20, withType: .regular)
        calendarView.appearance.weekdayFont = UIFont.ofSize(fontSize: 15, withType: .regular)
        calendarView.appearance.weekdayTextColor = viewModel.fontColorByTime()
        calendarView.appearance.headerTitleColor = viewModel.fontColorByTime()
        calendarView.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendarView.register(HomeCalendarCell.self, forCellReuseIdentifier: "cell")
        calendarStackView.addArrangedSubview(calendarView)
        
        previousCalendarButton.addTarget(self, action: #selector(previousCalendarButtonPressed), for: .touchUpInside)
        previousCalendarButton.setBackgroundImage(UIImage(named: "chevron-left"), for: .normal)
        calendarView.addSubview(previousCalendarButton)
        
        nextCalendarButton.addTarget(self, action: #selector(nextCalendarButtonPressed), for: .touchUpInside)
        nextCalendarButton.setBackgroundImage(UIImage(named: "chevron-right"), for: .normal)
        calendarView.addSubview(nextCalendarButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.maxHeight = 110
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        calendarStackView.addArrangedSubview(tableView)
        
        moreLessButton.setImage(UIImage(named: "down-arrow-icon"), for: .normal)
        moreLessButton.setTitle("More", for: .normal)
        moreLessButton.isHidden = true
        moreLessButton.setTitleColor(.black, for: .normal)
        moreLessButton.backgroundColor = UIColor(rgb:0xfbf6f6)
        moreLessButton.layer.cornerRadius = 10
        moreLessButton.layer.masksToBounds = true
        moreLessButton.titleLabel?.font = UIFont.ofSize(fontSize: 15, withType: .regular)
        moreLessButton.setImage(UIImage(named: "up-arrow-icon"), for: .selected)
        moreLessButton.setTitle("Less", for: .selected)
        moreLessButton.addTarget(self, action: #selector(addMoreButtonPressed), for: .touchUpInside)
        contentView.addSubview(moreLessButton)
        
        contentView.addSubview(mapView)
        
        buttonMapView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        mapView.addSubview(buttonMapView)
        
        buttonExpand.setTitle("Full view", for: .normal)
        buttonExpand.setTitleColor(.white, for: .normal)
        buttonExpand.setImage(UIImage(named: "expand-icon"), for: .normal)
        buttonExpand.addTarget(self, action: #selector(showMap), for: .touchUpInside)
        buttonMapView.addSubview(buttonExpand)
        
        badgeLabel = UILabel(frame: CGRect(x: 15, y: -5, width: 20, height: 20))
        badgeLabel.layer.borderColor = UIColor.clear.cgColor
        badgeLabel.layer.borderWidth = 2
        badgeLabel.layer.cornerRadius = badgeLabel.bounds.size.height / 2
        badgeLabel.textAlignment = .center
        badgeLabel.layer.masksToBounds = true
        badgeLabel.font = UIFont.systemFont(ofSize: 12.0)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .clear
        //badgeLabel.text = "8"
        
        let notificationImage = UIImageView()
        notificationImage.image = UIImage(named:"bell-icon-inactive")
        notificationImage.addSubview(badgeLabel)
        notificationImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openNotificationPage)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationImage)
        var initBadgeCount = 0;
        
        viewModel.notificationToken = viewModel.todoListData?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.viewModel.todoListData?.forEach{ (data ) in
                    self?.calendarView.select(Date(), scrollToDate: false)
                    self?.mapView.pin(data: data)
                    
                    self?.clonedData.append(data)
                    
                    if data.status == "unread" {
                        initBadgeCount += 1;
                        self!.updateApplicationBadge(count: initBadgeCount);
                        self!.badgeLabel.backgroundColor = .red
                        self?.badgeLabel.text = String(initBadgeCount)
                        notificationImage.image = UIImage(named:"bell-icon-active")
                    }
                }
                
                let bday = self?.viewModel.searchBirthdayByDay(fromDate: Date().startOfDay, toDate: Date().endOfDay)
                let appCount = self?.viewModel.searchAppointmentByDay(fromDate: Date().startOfDay, toDate: Date().endOfDay)
                
                if (appCount ?? 0) > 0 {
                    let data = self?.viewModel.searchAppointmentByDayData(fromDate: Date().startOfDay,
                                                               toDate: Date().endOfDay)
                    
                    self?.mapView.pointCamera(location: data?.addNote_location)
                }
                self?.appointmentsView.labelCount.text = "\(appCount ?? 0)"
                self?.birthdayView.labelCount.text = "\(bday ?? 0)"
                
                self?.calendarView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                
                let bday = self?.viewModel.searchBirthdayByDay(fromDate: Date().startOfDay, toDate: Date().endOfDay)
                let appCount = self?.viewModel.searchAppointmentByDay(fromDate: Date().startOfDay, toDate: Date().endOfDay)
                
                self?.appointmentsView.labelCount.text = "\(appCount ?? 0)"
                self?.birthdayView.labelCount.text = "\(bday ?? 0)"
                
                _ = deletions.map({
                    if let date = self?.clonedData[$0].addNote_alertDateTime {
                        
                        self?.clonedData.remove(at: $0)
                        let countDataInCalendar = self?.clonedData.filter({
                            (self?.gregorian.isDateInToday($0.addNote_alertDateTime!))! && $0.deleted_at == nil
                        }).count
                        
                        if countDataInCalendar == 0 {
                            self?.calendarView.deselect(date)
                        }
                    }
                    
                    if let notes = self?.viewModel.todoListData?.filter({ $0.status == "unread" && $0.deleted_at == nil }) {
                        if  notes.count > 0 {
                            self!.badgeLabel.backgroundColor = .red
                            self!.updateApplicationBadge(count: notes.count);
                            self?.badgeLabel.text = String(notes.count)
                            notificationImage.image = UIImage(named:"bell-icon-active")
                        } else {
                            notificationImage.image = UIImage(named:"bell-icon-inactive")
                            self!.badgeLabel.backgroundColor = .clear
                            self?.badgeLabel.text = ""
                        }
                    }
                    else
                    {
                        self!.badgeLabel.backgroundColor = .clear
                        self?.badgeLabel.text = ""
                    }
                    
                })
                
                _ = insertions.map({
                    //self?.calendarView.select(self?.viewModel.todoListData?[$0].addNote_alertDateTime)
                    if let note = self?.viewModel.todoListData?[$0] {
                        self?.clonedData.append(note)
                        self?.mapView.pin(data: note)
                    }
                })
                
                if modifications.count > 0 {
                    if let notes = self?.viewModel.todoListData?.filter({ $0.status == "unread" && $0.deleted_at == nil }) {
                        if  notes.count > 0 {
                            self!.updateApplicationBadge(count: notes.count);
                            self!.badgeLabel.backgroundColor = .red
                            self!.updateApplicationBadge(count: notes.count);
                            self?.badgeLabel.text = String(notes.count)
                            notificationImage.image = UIImage(named:"bell-icon-active")
                        } else {
                            self!.updateApplicationBadge(count: 0);
                            notificationImage.image = UIImage(named:"bell-icon-inactive")
                            self!.badgeLabel.backgroundColor = .clear
                            self?.badgeLabel.text = ""
                        }
                    }
                    else
                    {
                        self!.badgeLabel.backgroundColor = .clear
                        self?.badgeLabel.text = ""
                    }
                }
                
                
                self?.calendarView.reloadData()
                
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    func getCurrentLocation()
    {
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            //return (currentLocation.coordinate.longitude, currentLocation.coordinate.latitude)
            
        }
        else
        {
            coordinateLong = 0.00
            coordinateLat = 0.00
            //return (0.00, 0.00)
        }
    }
    
    func updateApplicationBadge(count:Int)
    {
        UIApplication.shared.applicationIconBadgeNumber = count;
    }
    
    @objc func previousCalendarButtonPressed() {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage)
        calendarView.setCurrentPage(previousMonth!, animated: true)
    }
    
    @objc func nextCalendarButtonPressed() {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendarView.currentPage)
        calendarView.setCurrentPage(nextMonth!, animated: true)
    }
    
    @objc func showMap() {
        let controller = ClusterMapViewController()
        controller.isControllerPresented = true
        controller.cc_setZoomTransition(originalView: mapView)
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func hideShowCalendar() {
        
        self.calendarLabelRightButton.isSelected = !self.calendarLabelRightButton.isSelected
        
        UIView.animate(withDuration:  0.4, animations: {
            self.calendarView.isHidden = !self.calendarView.isHidden
            self.calendarLabelLeftButton.isHidden = !self.calendarView.isHidden
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func addMoreButtonPressed() {
        self.moreLessButton.isSelected = !self.moreLessButton.isSelected
    }
    
    
    @objc func openNotificationPage() {
        let notifVC = NotificationsListViewController()
        self.navigationController?.pushViewController(notifVC, animated: false)
    }
    
    
//    func blurredBGImage() {
//
//        let hour = Calendar.current.component(.hour, from: Date())
//
//        switch hour {
//        case 6..<12 : imageView.image = UIImage(named:"morning.jpg") ; viewModel.timeByString = .morning
//        case 12 : imageView.image = UIImage(named:"noon.jpg") ; viewModel.timeByString = .noon
//        case 13..<17 : imageView.image = UIImage(named:"afternoon.jpg") ; viewModel.timeByString = .afternoon
//        case 17..<22 : imageView.image = UIImage(named:"evening.jpeg") ; viewModel.timeByString = .evening
//        default: imageView.image = UIImage(named:"evening.jpeg") ; viewModel.timeByString = .evening
//        }
//
//        let currentFilter = CIFilter(name: "CIGaussianBlur")
//        let beginImage = CIImage(image: imageView.image!)
//        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
//        currentFilter!.setValue(4, forKey: kCIInputRadiusKey)
//
//        let cropFilter = CIFilter(name: "CICrop")
//        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
//        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
//
//        let output = cropFilter!.outputImage
//        let cgimg = context.createCGImage(output!, from: output!.extent)
//        let processedImage = UIImage(cgImage: cgimg!)
//        imageView.image = processedImage
//    }
    
    deinit {
        viewModel.notificationToken?.invalidate()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            headerView.snp.makeConstraints {make in
                if #available(iOS 11.0, *) {
                    make.top.equalTo(view.safeArea.top).inset(5)
                } else {
                    make.top.equalTo(view).inset(60)
                }
                make.left.right.equalTo(view).inset(20)
                make.height.equalTo(60)
            }
            
            headerCountsView.snp.makeConstraints {make in
                make.top.equalTo(headerView.snp.bottom).offset(20)
                make.height.equalTo(view.snp.width).multipliedBy(0.28)
                make.left.right.equalTo(view).inset(20)
            }
            
            headerBGView.snp.makeConstraints {make in
                make.center.equalTo(headerCountsView)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(headerCountsView.snp.height).multipliedBy(1.2)
            }
            
            scrollView.snp.makeConstraints { (make) in
                make.left.right.equalTo(view)
                make.bottom.equalToSuperview().inset(50)
                make.top.equalTo(headerCountsView.snp.bottom).offset(10)
            }
            
            contentView.snp.makeConstraints {make in
                make.top.bottom.equalTo(scrollView)
                make.left.right.equalTo(view)
            }
            
            buttonMapSubView.snp.makeConstraints{ make in
                make.top.left.right.equalTo(contentView).inset(UIEdgeInsets.zero)
                make.height.equalTo(60)
            }
            
            calendarLabelLeftButton.snp.makeConstraints {make in
                make.size.equalTo(CGSize(width: 130, height: 40))
                make.left.equalTo(buttonMapSubView).inset(30)
                make.centerY.equalTo(buttonMapSubView.snp.centerY)
            }
            
            calendarLabelRightButton.snp.makeConstraints {make in
                make.size.equalTo(CGSize(width: 110, height: 40))
                make.right.equalTo(buttonMapSubView).inset(30)
                make.centerY.equalTo(buttonMapSubView.snp.centerY)
            }
            
            calendarView.snp.updateConstraints { (make) in
                make.height.equalTo(400)
            }
            
            previousCalendarButton.snp.makeConstraints{ make in
                make.top.equalToSuperview().inset(12)
                make.left.equalToSuperview().inset(30)
                make.size.equalTo(CGSize(width: 20, height: 20))
            }
            
            nextCalendarButton.snp.makeConstraints{ make in
                make.top.equalToSuperview().inset(12)
                make.right.equalToSuperview().inset(30)
                make.size.equalTo(CGSize(width: 20, height: 20))
            }
            
            calendarStackView.snp.makeConstraints { (make) in
                make.left.right.equalTo(contentView).inset(UIEdgeInsets.zero)
                make.top.equalTo(buttonMapSubView.snp.bottom).offset(0)
            }
            
            moreLessButton.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 80, height: 40))
                make.centerX.equalToSuperview()
                make.top.equalTo(calendarStackView.snp.bottom).offset(-10)
            }
            
            mapView.snp.makeConstraints { (make) in
                make.left.right.equalTo(contentView).inset(UIEdgeInsets.zero)
                make.top.equalTo(moreLessButton.snp.bottom).offset(5)
                make.bottom.equalTo(contentView).offset(0)
                make.height.greaterThanOrEqualTo(300)
            }
            
            buttonMapView.snp.makeConstraints{ make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(40)
            }
            
            buttonExpand.snp.makeConstraints{ make in
                make.right.equalToSuperview().inset(10)
                make.size.equalTo(CGSize(width: 100, height: 35))
                make.centerY.equalToSuperview()
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
        
        if let name = Defaults[.SessionUsername] {
            
            let msgAttributedText = NSMutableAttributedString(string: "")
            let first = NSAttributedString(string: viewModel.getHeaderMessage(),
                                           attributes: [.font: UIFont.ofSize(fontSize: 20, withType: .regular)])
            msgAttributedText.append(first)
            
            let second = NSAttributedString(string: name+"!",
                                           attributes: [.font: UIFont.ofSize(fontSize: 20, withType: .bold)])
            msgAttributedText.append(second)
            
            greetingsLabel.attributedText = msgAttributedText
        }
        
        self.followUpsView.labelCount.text = "\(self.viewModel.getCustomersCount())"
        self.appointmentLabel.text = self.viewModel.getAppointmentHeaderMessage()
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HomeViewControllerV2: FSCalendarDataSource,FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if clonedData.filter({
            convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
        }).count > 0
        {
            return 1
        }
        else
        {
            return 0
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! HomeCalendarCell
        if self.gregorian.isDateInToday(date) {
            viewModel.filteredDates =
                clonedData.filter({
                    convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
                })
            self.tableView.reloadData()
        }
        cell.titleLabel.textColor = .black
//        cell.circleImageView.isHidden = calendar.selectedDates.contains(date) ? false:true
        return cell
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//        return .clear
//    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        var eventcolors:[UIColor] = []
        
        _ = clonedData.map({
            if convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy") {
                eventcolors.append(CommonColor.turquoiseColor)
//                if $0.addNote_taskType.lowercased() == "customer birthday" {
//                    eventcolors.append(CommonColor.redColor)
//                } else {
//                    eventcolors.append(CommonColor.turquoiseColor)
//                }
            }
        })
        
        return  eventcolors.count > 0 ? eventcolors:[]
    }
    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//
//        return calendar.selectedDates.contains(date) ? true:false
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        viewModel.filteredDates = clonedData.filter({
            convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
        })
        mapView.clearAllPin()   // remove all marker first then add back when cellforrow
//        if let location = viewModel.filteredDates[indexPath.row].addNote_location {
//            self.mapView.pointCamera(location: location)
//        }
        
        tableView.reloadData()
    }
    
//    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//
//        viewModel.filteredDates = clonedData.filter({
//            convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
//        })
//
//        tableView.reloadData()
//
//        return false
//    }
}

extension HomeViewControllerV2: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCount = viewModel.filteredDates.count
        
        tableView.isHidden = dataCount == 0 ? true:false
        //self.moreLessButton.isHidden = (dataCount == 0 || dataCount < 3) ? true:false
        self.moreLessButton.isHidden = true // azlim
        return viewModel.filteredDates.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let location = viewModel.filteredDates[indexPath.row].addNote_location {
            self.mapView.pointCamera(location: location)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 999
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeTableViewCell
        
        let data = viewModel.filteredDates[indexPath.row]
    
        cell.titleLabel.text = data.addNote_subject
        let imageNamed = data.addNote_taskType.lowercased().contains("birthday") ? "birthday-icon2":"dashboard-task-icon2"
        cell.leftImageView.image = UIImage(named: imageNamed)
        cell.leftImageAppearance = data.addNote_taskType
        
        if data.status == "Follow Up"
        {
            cell.leftImageView.image = UIImage(named: imageNamed)
            cell.leftImageView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        else if data.status == "Discontinue"
        {
            cell.leftImageView.image = UIImage(named: imageNamed)
            cell.leftImageView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        else
        {
            cell.leftImageView.image = UIImage(named: imageNamed)
            cell.leftImageAppearance = data.addNote_taskType
        }
        
        let subText = "\(convertDateTimeToString(date: data.addNote_alertDateTime!))"
        cell.descriptionLabel.text = subText
        cell.descriptionLabel2.text = "\(data.addNote_location?.name ?? "")"
        cell.descriptionLabel3.text = "\(data.addNote_notes)"
        let contactDetail = ContactViewModel.queryContactTable(checkType: "", id: data.addNote_customerId!)
        cell.descriptionLabel4.text = contactDetail[0].C_Name
        
        // add back marker here
        mapView.pin(data: viewModel.filteredDates[indexPath.row])
        mapView.pointCamera(location: viewModel.filteredDates[indexPath.row].addNote_location)
        
        
        return cell
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//
//        if scrollView == self.scrollView {
//            if yOffset >= scrollView.contentSize.height - view.frame.height {
//                scrollView.isScrollEnabled = false
//                tableView.isScrollEnabled = true
//            }
//        }
//
//        if scrollView == self.tableView {
//            if yOffset <= 0 {
//                self.scrollView.isScrollEnabled = true
//                self.tableView.isScrollEnabled = false
//            }
//        }
//    }
}

extension HomeViewControllerV2:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationLast = locations.last as! CLLocation
        coordinateLat = locationLast.coordinate.latitude
        coordinateLong = locationLast.coordinate.longitude
    }
}

extension HomeViewControllerV2:MapViewDelegate
{
    func getMarkerLongLat(long: Double, lat: Double) {
        let actionSheet = UIAlertController(title: "Choose options", message: "Select navigation app.", preferredStyle: .actionSheet)
        
        
        let mapAction = UIAlertAction(title: "Apple Map", style: .default) { (action:UIAlertAction) in
            let directionsURL = "http://maps.apple.com/?saddr=\(self.coordinateLat),\(self.coordinateLong)&daddr=\(lat),\(long)"
            guard let url = URL(string: directionsURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            //UIApplication.shared.open(URL(string: "mailto:")!, options: [:], completionHandler: nil)
        }
        let wazeAction = UIAlertAction(title: "Waze", style: .default) { (action:UIAlertAction) in
            
            if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                let urlStr: String = "waze://?ll=\(lat),\(long)&navigate=yes"
                UIApplication.shared.open(URL(string: urlStr)!)
            }
            else {
                UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!, options: [:], completionHandler: nil)
            }
        }
        
        actionSheet.addAction(mapAction)
        actionSheet.addAction(wazeAction)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension HomeViewControllerV2:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView != tableView else {
            return
        }
        
        if scrollView.contentOffset.y < 0 {
            let headerHeight = self.headerView.frame.height + abs(scrollView.contentOffset.y)
            
            self.headerView.snp.updateConstraints{ make in
                make.height.equalTo(headerHeight)
            }
            
        } else if scrollView.contentOffset.y > 0 {
            let headerHeight = self.headerView.frame.height - (scrollView.contentOffset.y - 5)
            
            guard headerHeight >= 0 else {
                self.headerView.snp.updateConstraints{ make in
                    make.height.equalTo(0)
                }
                return
            }
            
            self.headerView.snp.updateConstraints{ make in
                make.height.equalTo(headerHeight)
            }
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView != tableView else {
            return
        }
        
        if self.headerView.frame.height > 60 {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView != tableView else {
            return
        }
        
        if self.headerView.frame.height > 60 {
            animateHeader()
        }
    }
    
    func animateHeader() {
        self.headerView.snp.updateConstraints{ make in
            make.height.equalTo(60)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


