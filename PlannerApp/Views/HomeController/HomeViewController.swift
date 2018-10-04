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

class HomeViewController: ViewControllerProtocol,NoNavbar,FSCalendarDelegateAppearance {
    
    fileprivate let calendarView = FSCalendar()
//    fileprivate weak var eventLabel: UILabel!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let viewModel = TodoListViewModel()
    
    fileprivate var clonedData: [AddNote] = []
    fileprivate let tableView = UITableView()
    fileprivate var filteredDates: [AddNote] = []
    fileprivate let imageView = UIImageView(image:UIImage(named: "bg.jpg"))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.allowsMultipleSelection = true
        calendarView.backgroundColor = .clear
        calendarView.calendarHeaderView.backgroundColor = UIColor.clear
        calendarView.calendarWeekdayView.backgroundColor = UIColor.clear
        calendarView.appearance.headerTitleFont = UIFont.ofSize(fontSize: 17, withType: .bold)
        calendarView.appearance.weekdayFont = UIFont.ofSize(fontSize: 15, withType: .bold)
        calendarView.appearance.weekdayTextColor = .lightGray
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.borderRadius = 0
        calendarView.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendarView.dropShadow()
        calendarView.register(HomeCalendarCell.self, forCellReuseIdentifier: "cell")
        imageView.addSubview(calendarView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        imageView.addSubview(tableView)
        
        viewModel.notificationToken = viewModel.todoListData?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.viewModel.todoListData?.forEach{ (data ) in
                    self?.calendarView.select(data.addNote_alertDateTime)
                    self?.clonedData.append(data)
                }
                self?.calendarView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                _ = deletions.map({
                    if let date = self?.clonedData[$0].addNote_alertDateTime {
                        self?.calendarView.deselect(date)
                        self?.clonedData.remove(at: $0)
                    }
                })
                _ = insertions.map({
                    self?.calendarView.select(self?.viewModel.todoListData?[$0].addNote_alertDateTime)
                    if let note = self?.viewModel.todoListData?[$0] {
                        self?.clonedData.append(note)
                    }
                })
                
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        view.updateConstraintsIfNeeded()
        view.setNeedsUpdateConstraints()
    }
    
    deinit {
        viewModel.notificationToken?.invalidate()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            imageView.snp.makeConstraints {make in
                make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
            }
            
            calendarView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.imageView).inset(UIEdgeInsets.zero)
                make.top.equalTo(self.imageView).inset(60)
                make.height.equalTo(400)
            }
            
            tableView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.imageView).inset(UIEdgeInsets.zero)
                make.top.equalTo(calendarView.snp.bottom).offset(10)
                make.bottom.equalTo(self.imageView)
            }
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
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
            filteredDates = clonedData.filter({
                convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
            })
            self.tableView.reloadData()
        }
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
        
        filteredDates = clonedData.filter({
            convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
        })
        
        tableView.reloadData()
        
        return false
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle,reuseIdentifier: "cell")
        
        let data = filteredDates[indexPath.row]
        
        cell?.backgroundColor = .clear
        cell?.textLabel!.text = data.addNote_subject
        cell?.textLabel!.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        let imageNamed = data.addNote_taskType.lowercased().contains("birthday") ? "birthday-icon":"dashboard-task-icon"
        cell?.imageView?.image = UIImage(named: imageNamed)
        cell?.detailTextLabel?.text = convertDateTimeToString(date: data.addNote_alertDateTime!)
        cell?.detailTextLabel?.font = UIFont.ofSize(fontSize: 11, withType: .bold)
        
        return cell!
    }
}

