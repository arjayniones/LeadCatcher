//
//  TodoListViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class TodoListViewController: ViewControllerProtocol,LargeNativeNavbar{
    var deleteNotification: AddNote?

    fileprivate let tableView = UITableView()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var searchFooter = SearchFooterView()
    fileprivate let viewModel = TodoListViewModel()
    let realmStore = RealmStore<AddNote>()
    var realmResults:Results<AddNote>?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "to_do_list".localized
        //view.addBackground()
        view.backgroundColor = .clear
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search_to_do".localized

	if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }

        definesPresentationContext = true

        searchController.searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = searchFooter
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        realmResults = viewModel.todoListData
        setRealmNotification()
        /*
        viewModel.notificationToken = viewModel.todoListData?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
*/

        view.updateConstraintsIfNeeded()
        view.needsUpdateConstraints()
    }

    deinit {
        viewModel.notificationToken?.invalidate()
    }


    override func updateViewConstraints() {
        if !didSetupConstraints {
            tableView.snp.makeConstraints { make in

                make.top.equalTo(view.safeArea.top)
                make.left.right.equalTo(view)

                make.bottom.equalTo(view).inset(50)
            }

            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = searchController
//        } else {
//            tableView.tableHeaderView = searchController.searchBar
//        }
//
//    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        super.viewWillAppear(animated)
        // to reset realm notification token to prevent filtering update error
        if isFiltering()
        {
            realmResults = viewModel.filteredNotes
        }
        else
        {
            realmResults = viewModel.todoListData
        }
        setRealmNotification()
        updateNavbarAppear()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = nil
//        } else {
//            tableView.tableHeaderView = nil
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRealmNotification()
    {
        viewModel.notificationToken?.invalidate()
        viewModel.notificationToken = realmResults?._observe({ [weak self] (changes:RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        })
    }

}

extension TodoListViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension TodoListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("T##items: Any...##Any")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        realmResults = viewModel.todoListData
        setRealmNotification()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.searchText(text: searchText)
            realmResults = viewModel.filteredNotes
            setRealmNotification()
            //print(realmResults?.count)
            //self.tableView.reloadData()
        }
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

extension TodoListViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        guard let data = viewModel.todoListData else {
            return nil
        }

        let note: AddNote

        if isFiltering() {
            note = viewModel.filteredNotes![indexPath.row]
        } else {
            note = data[indexPath.row]
        }

        let deleteAction = UITableViewRowAction(style: .destructive, title: "delete".localized) { (deleteAction, indexPath) -> Void in


            let alert = UIAlertController(title: "Warning", message: "Delete this ToDo ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "no".localized, style:.cancel, handler: nil));
            alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
                self.viewModel.realmStore.delete(modelToDelete: note, hard: false)
                let identifier = "user_notification_\(note.id)"

                //azlim : to do remember to apply function below when deleted data
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
                
               let identifier2 = "before_user_notification_\(note.id)"
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier2])

            }))
            self.present(alert, animated: true, completion:nil);



        }

//        let editAction = UITableViewRowAction(style: .normal, title: "edit".localized) { (editAction, indexPath) -> Void in
//            self.openDetailsNoteForEditing(model: note)
//        }

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.todoListData else {
            return
        }

        let note: AddNote

        if isFiltering() {
            note = viewModel.filteredNotes![indexPath.row]
        } else {
            note = data[indexPath.row]
        }

        self.openDetailsNoteForEditing(model: note)
    }

    func openDetailsNoteForEditing(model:AddNote) {
        let detailController = DetailsTodoListViewController()
        detailController.isControllerEditing = true

        let todoModel = AddNoteModel()
        todoModel.addNote_ID = model.id
        todoModel.addNote_alertDateTime = model.addNote_alertDateTime
        todoModel.addNote_repeat = model.addNote_repeat
        todoModel.addNote_subject = model.addNote_subject

        if let customerModel = RealmStore<ContactModel>().models(query: "id == '\(model.addNote_customerId!)'")?.first {
            todoModel.addNote_customer = customerModel
        }

        todoModel.addNote_taskType = model.addNote_taskType
        todoModel.addNote_notes = model.addNote_notes
        todoModel.addNote_location = model.addNote_location
        var checklist:[ChecklistTemp] = []

        for x in model.addNote_checklist {
            let checklisttemp = ChecklistTemp()
            checklisttemp.id = x.id
            checklisttemp.title = x.title
            checklisttemp.status = x.status
            checklist.append(checklisttemp)
        }

        todoModel.addNote_checkList = checklist

        detailController.setupModel = todoModel

        self.navigationController?.pushViewController(detailController, animated: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let data = viewModel.todoListData else {
            return 0
        }

        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: viewModel.filteredNotes!.count, of: data.count)
            return viewModel.filteredNotes!.count
        }

        searchFooter.setNotFiltering()

        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeTableViewCell

        //let data = viewModel.filteredDates[indexPath.row]
        //cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,reuseIdentifier: "cell")

        guard let data = viewModel.todoListData else {
            return cell
        }

        let note: AddNote
        var status:String = "";

        if isFiltering() {
            note = viewModel.filteredNotes![indexPath.row]
        } else {
            note = data[indexPath.row]
        }

//        cell.textLabel!.font = UIFont.ofSize(fontSize: 17, withType: .bold)
//        cell.textLabel!.text = note.addNote_subject
//        cell.detailTextLabel?.font = UIFont.ofSize(fontSize: 17, withType: .regular)
//        cell.detailTextLabel?.text = convertDateTimeToString(date: note.addNote_alertDateTime!)
//        cell.detailTextLabel?.textColor = .red
//        cell.imageView?.layer.cornerRadius = 15
//        cell.imageView?.layer.masksToBounds = true
//        let imageName = note.addNote_taskType.lowercased().contains("birthday") ? "birthday-icon2":"dashboard-task-icon2"
//        cell.imageView?.image = UIImage(named: imageName)
//
//        let leftImageAppearance = note.addNote_taskType
//
//        switch leftImageAppearance.lowercased() {
//        case "customer birthday":
//            cell.imageView?.backgroundColor = CommonColor.redColor
//        case "appointment":
//            cell.imageView?.backgroundColor = CommonColor.turquoiseColor
//        default:
//            cell.imageView?.backgroundColor = CommonColor.purpleColor
//        }
        

        cell.titleLabel.text = note.addNote_subject
        let imageNamed = note.addNote_taskType.lowercased().contains("birthday") ? "birthday-icon2":"dashboard-task-icon2"
        cell.leftImageAppearance = note.addNote_taskType
        if note.status == "Follow Up"
        {
            cell.leftImageView.image = UIImage(named: imageNamed)
            cell.leftImageView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        else if note.status == "Discontinue"
        {
            cell.leftImageView.image = UIImage(named: imageNamed)
            cell.leftImageView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        else
        {
            cell.leftImageView.image = UIImage(named: imageNamed)
            cell.leftImageAppearance = note.addNote_taskType
        }

        //
        let subText = "\(convertDateTimeToString(date: note.addNote_alertDateTime!))"
        cell.descriptionLabel.text = subText
        cell.descriptionLabel2.text = "\(note.addNote_location?.name ?? "")"
        cell.descriptionLabel3.text = "\(note.addNote_notes)"
        let contactDetail = ContactViewModel.queryContactTable(checkType: "", id: note.addNote_customerId!)
        cell.descriptionLabel4.text = contactDetail[0].C_Name

        return cell
    }

    @available (iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let data = viewModel.todoListData  else {
            return nil
        }
        if data[indexPath.row].addNote_taskType == "Customer Birthday"
        {
            return nil
        }
        else
        {
            let markCompleted = UIContextualAction(style: .normal, title: "Completed") { (action, view, handler) in

                let alert = UIAlertController(title: "Info", message: "Completed this ToDo ?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "no".localized, style:.cancel, handler: nil));
                alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
                    self.viewModel.updateToDoListStatus(id: data[indexPath.row].id,status:"Completed");
                    handler(true)
                }))
                self.present(alert, animated: true, completion:nil);
            }
            let markFollowUp = UIContextualAction(style: .normal, title: "Follow Up") { (action, view, handler) in

                let alert = UIAlertController(title: "Info", message: "Follow Up this ToDo ?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "no".localized, style:.cancel, handler: nil));
                alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
                    self.viewModel.updateToDoListStatus(id: data[indexPath.row].id,status:"Follow Up");
                    self.searchController.isActive = false
                    handler(true)
                }))
                self.present(alert, animated: true, completion:nil);
            }
            let markUnSuccess = UIContextualAction(style: .normal, title: "Discontinue") { (action, view, handler) in

                let alert = UIAlertController(title: "Info", message: "Discontinue this ToDo ?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "no".localized, style:.cancel, handler: nil));
                alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
                    self.viewModel.updateToDoListStatus(id: data[indexPath.row].id,status:"Discontinue");
                    self.searchController.isActive = false
                    handler(true)
                }))
                self.present(alert, animated: true, completion:nil);
            }

            markCompleted.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            markFollowUp.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            markUnSuccess.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            let configuration = UISwipeActionsConfiguration(actions: [markCompleted,markFollowUp,markUnSuccess])
            return configuration
        }


    }
}

extension Date {

    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format

        return formatter.string(from: yourDate!)
    }
}
