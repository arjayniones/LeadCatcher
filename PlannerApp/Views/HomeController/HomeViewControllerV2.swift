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

class HomeViewControllerV2: ViewControllerProtocol,NoNavbar,FSCalendarDelegateAppearance,UIScrollViewDelegate {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let viewModel = TodoListViewModel()
    
    fileprivate var clonedData: [AddNote] = []
    fileprivate let tableView = UITableView()
    
    fileprivate let imageView = UIImageView()
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
    
    fileprivate let calendarStackView = UIStackView()
    fileprivate let calendarView = FSCalendar()
    fileprivate let mapView = MapView()
    fileprivate let buttonMapView = UIView()
    fileprivate let buttonExpand = RightIconButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imageView.isUserInteractionEnabled = true
//        imageView.backgroundColor = .white
        viewModel.getGreetingByTime()
//        view = imageView
        
        view.backgroundColor = .white
        
        headerView.axis = .vertical
        headerView.alignment = .leading
        headerView.spacing = 10
        view.addSubview(headerView)
        
        greetingsLabel.textColor = viewModel.fontColorByTime()
        greetingsLabel.font = UIFont.ofSize(fontSize: 27, withType: .bold)
        headerView.addArrangedSubview(greetingsLabel)
        
        appointmentLabel.textColor = viewModel.fontColorByTime()
        appointmentLabel.font = UIFont.ofSize(fontSize: 20, withType: .bold)
        headerView.addArrangedSubview(appointmentLabel)
        
        headerCountsView.axis = .horizontal
        headerCountsView.distribution = .fillEqually
        headerCountsView.spacing = 5
        view.addSubview(headerCountsView)
        
        followUpsView.backgroundColor = .blue
        followUpsView.translatesAutoresizingMaskIntoConstraints = true
        headerCountsView.addArrangedSubview(followUpsView)
        
        appointmentsView.backgroundColor = .orange
        appointmentsView.translatesAutoresizingMaskIntoConstraints = true
        headerCountsView.addArrangedSubview(appointmentsView)
        
        birthdayView.backgroundColor = .red
        birthdayView.translatesAutoresizingMaskIntoConstraints = true
        headerCountsView.addArrangedSubview(birthdayView)
        
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        calendarLabelLeftButton.setTitle("15 Nov 2018", for: .normal)
        calendarLabelLeftButton.setTitleColor(.black, for: .normal)
        calendarLabelLeftButton.setImage(UIImage(named: "calendar-dash-icon"), for: .normal)
        calendarLabelLeftButton.titleLabel?.font = UIFont.ofSize(fontSize: 15, withType: .regular)
        contentView.addSubview(calendarLabelLeftButton)
        
        calendarLabelRightButton.setTitle("Calendar", for: .normal)
        calendarLabelRightButton.setTitleColor(.black, for: .normal)
        calendarLabelRightButton.setImage(UIImage(named: "switch-on-icon"), for: .normal)
        calendarLabelRightButton.setImage(UIImage(named: "switch-off-icon"), for: .selected)
        calendarLabelRightButton.addTarget(self, action: #selector(hideShowCalendar), for: .touchUpInside)
        calendarLabelRightButton.titleLabel?.font = UIFont.ofSize(fontSize: 15, withType: .regular)
        contentView.addSubview(calendarLabelRightButton)
        
        calendarStackView.distribution = .fillEqually
        calendarStackView.axis = .vertical
        contentView.addSubview(calendarStackView)
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.allowsMultipleSelection = true
        calendarView.backgroundColor = .clear
        calendarView.calendarHeaderView.backgroundColor = UIColor.clear
        calendarView.calendarWeekdayView.backgroundColor = UIColor.clear
        calendarView.appearance.headerTitleFont = UIFont.ofSize(fontSize: 18, withType: .bold)
        calendarView.appearance.weekdayFont = UIFont.ofSize(fontSize: 18, withType: .bold)
        calendarView.appearance.weekdayTextColor = viewModel.fontColorByTime()
        calendarView.appearance.headerTitleColor = viewModel.fontColorByTime()
        calendarView.appearance.borderRadius = 0
        calendarView.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendarView.register(HomeCalendarCell.self, forCellReuseIdentifier: "cell")
        calendarStackView.addArrangedSubview(calendarView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        calendarStackView.addArrangedSubview(tableView)
        
        contentView.addSubview(mapView)
        
        buttonMapView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        mapView.addSubview(buttonMapView)
        
        buttonExpand.setTitle("Full view", for: .normal)
        buttonExpand.setTitleColor(.white, for: .normal)
        buttonExpand.setImage(UIImage(named: "expand-icon"), for: .normal)
        buttonExpand.addTarget(self, action: #selector(showMap), for: .touchUpInside)
        buttonMapView.addSubview(buttonExpand)
        
        let notificationImage = UIImageView()
        notificationImage.image = UIImage(named:"bell-icon-inactive")
        notificationImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openNotificationPage)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationImage)
        
        viewModel.notificationToken = viewModel.todoListData?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.viewModel.todoListData?.forEach{ (data ) in
                    self?.calendarView.select(data.addNote_alertDateTime)
                    self?.clonedData.append(data)
                    if data.status == "unread" {
                        notificationImage.image = UIImage(named:"bell-icon-active")
                    }
                }
                self?.calendarView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                
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
                })
                _ = insertions.map({
                    self?.calendarView.select(self?.viewModel.todoListData?[$0].addNote_alertDateTime)
                    if let note = self?.viewModel.todoListData?[$0] {
                        self?.clonedData.append(note)
                    }
                })
                
                if modifications.count > 0 {
                    if let notes = self?.viewModel.todoListData?.filter({ $0.status == "unread" }) {
                        if  notes.count > 0 {
                            notificationImage.image = UIImage(named:"bell-icon-active")
                        } else {
                            notificationImage.image = UIImage(named:"bell-icon-inactive")
                        }
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
    @objc func showMap() {
        navigationController?.pushViewController(DashboardMapViewController(), animated: true)
    }
    
    @objc func hideShowCalendar() {
        
        self.calendarView.isHidden = !self.calendarView.isHidden
        self.calendarLabelRightButton.isSelected = self.calendarView.isHidden
        
//        let transitionOptions: UIView.AnimationOptions = self.calendarView.isHidden ? [.transitionCurlDown]:[.transitionCurlUp]
//
//        UIView.transition(with: calendarView, duration: 1.0, options:transitionOptions, animations: {
//
//        }, completion: { _ in
//
//        })
    }
    
    
    @objc func openNotificationPage() {
        let notifVC = NotificationsListViewController()
        self.navigationController?.pushViewController(notifVC, animated: true)
    }
    
    
    func blurredBGImage() {
        
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12 : imageView.image = UIImage(named:"morning.jpg") ; viewModel.timeByString = .morning
        case 12 : imageView.image = UIImage(named:"noon.jpg") ; viewModel.timeByString = .noon
        case 13..<17 : imageView.image = UIImage(named:"afternoon.jpg") ; viewModel.timeByString = .afternoon
        case 17..<22 : imageView.image = UIImage(named:"evening.jpeg") ; viewModel.timeByString = .evening
        default: imageView.image = UIImage(named:"evening.jpeg") ; viewModel.timeByString = .evening
        }
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: imageView.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(4, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        imageView.image = processedImage
    }
    
    deinit {
        viewModel.notificationToken?.invalidate()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            headerView.snp.makeConstraints {make in
                if #available(iOS 11.0, *) {
                    make.top.equalTo(view.safeArea.top).inset(5)
                } else {
                    make.top.equalTo(view).inset(5)
                }
                make.left.right.equalTo(view).inset(20)
            }
            
            headerCountsView.snp.makeConstraints {make in
                make.top.equalTo(headerView.snp.bottom).offset(20)
                make.height.equalTo(120)
                make.left.right.equalTo(view).inset(20)
            }
            
            scrollView.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(view)
                make.top.equalTo(headerCountsView.snp.bottom).offset(10)
            }
            
            contentView.snp.makeConstraints {make in
                make.top.bottom.equalTo(scrollView)
                make.left.right.equalTo(view)
            }
            
            calendarLabelLeftButton.snp.makeConstraints {make in
                make.size.equalTo(CGSize(width: 130, height: 40))
                make.left.equalTo(contentView).inset(30)
                make.top.equalTo(contentView).inset(10)
            }
            
            calendarLabelRightButton.snp.makeConstraints {make in
                make.size.equalTo(CGSize(width: 110, height: 40))
                make.right.equalTo(contentView).inset(30)
                make.top.equalTo(contentView).inset(10)
            }
            
            calendarView.snp.updateConstraints { (make) in
                make.height.equalTo(400)
            }
            
            tableView.snp.makeConstraints { (make) in
                make.height.equalTo(300)
            }
            
            calendarStackView.snp.updateConstraints { (make) in
                make.left.right.equalTo(contentView).inset(20)
                make.top.equalTo(calendarLabelLeftButton.snp.bottom).offset(10)
            }
            
            mapView.snp.makeConstraints { (make) in
                make.left.right.equalTo(contentView).inset(20)
                make.top.equalTo(calendarStackView.snp.bottom).offset(10)
                make.height.equalTo(300)
                make.bottom.equalTo(contentView).offset(-50)
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
            greetingsLabel.text = "\(viewModel.getHeaderMessage()) \(name)!"
        }
        
        self.appointmentLabel.text = self.viewModel.getAppointmentHeaderMessage()
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HomeViewControllerV2: FSCalendarDataSource,FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return clonedData.filter({
            convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
        }).count
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
        cell.circleImageView.isHidden = calendar.selectedDates.contains(date) ? false:true
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        var eventcolors:[UIColor] = []
        
        _ = clonedData.map({
            if convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy") {
                if $0.addNote_taskType.lowercased() == "customer birthday" {
                    eventcolors.append(UIColor.red)
                } else {
                    eventcolors.append(UIColor.green)
                }
            }
        })
        
        return  eventcolors.count > 0 ? eventcolors:[]
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        return calendar.selectedDates.contains(date) ? true:false
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        viewModel.filteredDates = clonedData.filter({
            convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
        })
        
        tableView.reloadData()
        
        return false
    }
}

extension HomeViewControllerV2: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCount = viewModel.filteredDates.count
        tableView.isHidden = dataCount == 0 ? true:false
        
        return viewModel.filteredDates.count
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
        let imageNamed = data.addNote_taskType.lowercased().contains("birthday") ? "birthday-icon":"dashboard-task-icon"
        cell.leftImageView.image = UIImage(named: imageNamed)
        let subText = "\(convertDateTimeToString(date: data.addNote_alertDateTime!))"
        cell.descriptionLabel.text = subText
        cell.descriptionLabel2.text = "\(data.addNote_location?.name ?? "")"
        cell.descriptionLabel3.text = "\(data.addNote_notes)"
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if scrollView == self.scrollView {
            if yOffset >= scrollView.contentSize.height - view.frame.height {
                scrollView.isScrollEnabled = false
                tableView.isScrollEnabled = true
            }
        }
        
        if scrollView == self.tableView {
            if yOffset <= 0 {
                self.scrollView.isScrollEnabled = true
                self.tableView.isScrollEnabled = false
            }
        }
    }
}


