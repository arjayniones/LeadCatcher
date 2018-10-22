//
//  HomeViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 12/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar
import CoreImage
import SwiftyUserDefaults
import UserNotifications

public enum TimeStatus {
    case morning
    case noon
    case evening
    case afternoon
}

class HomeViewController: ViewControllerProtocol,NoNavbar,FSCalendarDelegateAppearance,UIScrollViewDelegate {
    
    fileprivate let calendarView = FSCalendar()
//    fileprivate weak var eventLabel: UILabel!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named:"bgimage.jpg")
//        self.blurredBGImage()
        self.getGreetingByTime()
        view = imageView
        
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
        
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)
        
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
        contentView.addSubview(calendarView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        contentView.addSubview(tableView)
        
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
        
        view.updateConstraintsIfNeeded()
        view.setNeedsUpdateConstraints()
    }
    
    @objc func openNotificationPage() {
        let notifVC = NotificationsListViewController()
        self.navigationController?.pushViewController(notifVC, animated: true)
    }
    
    func getGreetingByTime() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
            case 6..<12 : viewModel.timeByString = .morning
            case 12 : viewModel.timeByString = .noon
            case 13..<17 : viewModel.timeByString = .afternoon
            case 17..<22 : viewModel.timeByString = .evening
            default: viewModel.timeByString = .evening
        }
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
                make.top.equalTo(view.safeArea.top).inset(5)
                make.left.right.equalTo(contentView).inset(20)
            }
            
            scrollView.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(view)
                make.top.equalTo(headerView.snp.bottom)
            }
            
            contentView.snp.makeConstraints {make in
                make.top.bottom.equalTo(scrollView)
                make.left.right.equalTo(view)
            }
            
            calendarView.snp.updateConstraints { (make) in
                make.left.right.equalTo(contentView).inset(UIEdgeInsets.zero)
                make.top.equalTo(contentView).offset(10)
                make.height.equalTo(400)
            }
            
            tableView.snp.makeConstraints { (make) in
                make.left.right.equalTo(contentView).inset(UIEdgeInsets.zero)
                make.top.equalTo(calendarView.snp.bottom).offset(10)
                make.height.equalTo(300)
                make.bottom.equalTo(contentView).offset(-50)
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
extension HomeViewController: FSCalendarDataSource,FSCalendarDelegate {
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

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle,reuseIdentifier: "cell")
        
        let data = viewModel.filteredDates[indexPath.row]
        
        cell?.backgroundColor = .clear
        cell?.textLabel?.text = data.addNote_subject
        cell?.textLabel?.textColor = viewModel.fontColorByTime()
        cell?.textLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        let imageNamed = data.addNote_taskType.lowercased().contains("birthday") ? "birthday-icon":"dashboard-task-icon"
        cell?.imageView?.image = UIImage(named: imageNamed)
        cell?.detailTextLabel?.text = convertDateTimeToString(date: data.addNote_alertDateTime!)
        cell?.detailTextLabel?.textColor = viewModel.fontColorByTime()
        cell?.detailTextLabel?.font = UIFont.ofSize(fontSize: 11, withType: .bold)
        
        return cell!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if scrollView == self.scrollView {
            if yOffset >= scrollView.contentSize.height - view.height {
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

