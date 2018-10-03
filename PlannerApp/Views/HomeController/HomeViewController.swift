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

class HomeViewController: ViewControllerProtocol,NativeNavbar,FSCalendarDelegateAppearance {
    
    fileprivate let calendarView = FSCalendar()
//    fileprivate weak var eventLabel: UILabel!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let viewModel = TodoListViewModel()
    
    fileprivate var clonedData: [AddNote] = []
    fileprivate let tableView = UITableView()
    fileprivate var filteredDates: [AddNote] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Dashboard"
        view.backgroundColor = UIColor(rgb: 0xee5858)
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.allowsMultipleSelection = true
        calendarView.backgroundColor = .yellow
        calendarView.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendarView.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
//        calendarView.appearance.eventSelectionColor = UIColor.white
        calendarView.register(HomeCalendarCell.self, forCellReuseIdentifier: "cell")
        
        calendarView.appearance.eventOffset = CGPoint(x: 0, y: -7)
//        calendarView.register(CalendarViewCell.self, forCellReuseIdentifier: "cell")
//        calendarView.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        view.addSubview(calendarView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        viewModel.notificationToken = viewModel.todoListData?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.viewModel.todoListData?.forEach{ (data ) in
                    self?.calendarView.select(data.addNote_alertDateTime)
                    self?.clonedData.append(data)
                }
                self?.tableView.reloadData()
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
            calendarView.snp.updateConstraints { (make) in
                make.top.left.right.equalTo(self.view).inset(UIEdgeInsets.zero)
                make.height.equalTo(300)
            }
            tableView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.view).inset(UIEdgeInsets.zero)
                make.top.equalTo(calendarView.snp.bottom)
                make.bottom.equalTo(self.view)
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
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
//        return cell
//    }
//
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return 2
//    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! HomeCalendarCell
        
        return cell
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        filteredDates = clonedData.filter({
            convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
        })
        
        tableView.reloadData()
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
        
        cell?.textLabel!.text = data.addNote_subject
        cell?.imageView?.image = UIImage(named: "book-icon")
        cell?.detailTextLabel?.text = convertDateTimeToString(date: data.addNote_alertDateTime!)
        cell?.detailTextLabel?.textColor = .red
        
        return cell!
    }
}

