//
//  ContactListViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 24/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI
import ImagePicker
import Kingfisher
import SwiftyUserDefaults

protocol ContactListViewControllerDelegate:class {
    func didSelectCustomer(user:ContactModel)
}

class ContactListViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource,LargeNativeNavbar {
    let tableView = UITableView()
    
   

    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var searchFooter = SearchFooterView()
    let viewModel = ContactListViewModel()
    weak var delegate:ContactListViewControllerDelegate?
    var userInContactsSelection: Bool = false
    var userIdSelected:UUID?
    
    let allButton = ActionButton()
    let potentialButton = ActionButton()
    let customerButton = ActionButton()
    let disqualifiedButton = ActionButton()
    let topStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contact"
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.delegate = self

        title = "Contacts"
        
        allButton.setTitle("All", for: .normal)
        allButton.setTitleColor(.white, for: .normal)
        allButton.setTitleColor(.black, for: .selected)
        allButton.titleLabel?.font =  .systemFont(ofSize: 11)
        allButton.isSelected = true
        allButton.backgroundColor = .white
        allButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        //view.addSubview(allButton)
        
        potentialButton.setTitle("Potential", for: .normal)
        potentialButton.backgroundColor = CommonColor.naviBarBlackColor
        potentialButton.isSelected = false
        potentialButton.setTitleColor(.white, for: .normal)
        potentialButton.setTitleColor(.black, for: .selected)
        potentialButton.titleLabel?.font =  .systemFont(ofSize: 11)
        potentialButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        //view.addSubview(potentialButton)
        
        customerButton.setTitle("Customers", for: .normal)
        customerButton.backgroundColor = CommonColor.naviBarBlackColor
        customerButton.isSelected = false
        customerButton.setTitleColor(.white, for: .normal)
        customerButton.setTitleColor(.black, for: .selected)
        customerButton.titleLabel?.font =  .systemFont(ofSize: 11)
        customerButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        //view.addSubview(customerButton)
        
        disqualifiedButton.setTitle("Disqualified", for: .normal)
        disqualifiedButton.backgroundColor = CommonColor.naviBarBlackColor
        disqualifiedButton.isSelected = false
        disqualifiedButton.setTitleColor(.white, for: .normal)
        disqualifiedButton.setTitleColor(.black, for: .selected)
        disqualifiedButton.titleLabel?.font =  .systemFont(ofSize: 11)
        disqualifiedButton.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
        //view.addSubview(disqualifiedButton)
        
        
        view.addSubview(topStack)
        topStack.axis = .horizontal
        
        topStack.distribution = .fillEqually
        topStack.addArrangedSubview(allButton)
        topStack.addArrangedSubview(potentialButton)
        topStack.addArrangedSubview(customerButton)
        topStack.addArrangedSubview(disqualifiedButton)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsMultipleSelection = false
        //tableView.estimatedRowHeight = 200
        tableView.register(ContactListTableViewCell.self, forCellReuseIdentifier: "contactListCell")
        //tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cellReuseIdentifier")
        view.addSubview(tableView)
        
        let addButton = UIButton()
        let image = UIImage(named: "plus-grey-icon" )
        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(addContact), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        
        //need to implement this , correct reloading of table after it was been populated.
        
        viewModel.notificationToken = viewModel.contactList?.observe { [weak self] (changes: RealmCollectionChange) in
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
        
        view.needsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
   
    
    @objc func filterPressed(sender:UIButton) {
        
        switch sender {
            
        case  allButton :
            
                allButton.isSelected = true
                potentialButton.isSelected = false
                customerButton.isSelected = false
                disqualifiedButton.isSelected = false
                allButton.backgroundColor = .white
                potentialButton.backgroundColor = CommonColor.naviBarBlackColor
                customerButton.backgroundColor = CommonColor.naviBarBlackColor
                disqualifiedButton.backgroundColor = CommonColor.naviBarBlackColor
                viewModel.filterContact(isPotential: false, isCustomer: false, isDisqualified: false)
            
            break
        case potentialButton:
                allButton.isSelected = false
                potentialButton.isSelected = true
                customerButton.isSelected = false
                disqualifiedButton.isSelected = false
                allButton.backgroundColor = CommonColor.naviBarBlackColor
                potentialButton.backgroundColor = .white
                customerButton.backgroundColor = CommonColor.naviBarBlackColor
                disqualifiedButton.backgroundColor = CommonColor.naviBarBlackColor
                viewModel.filterContact(isPotential: true, isCustomer: false, isDisqualified: false)
            
            break
        
        case customerButton :
                allButton.isSelected = false
                potentialButton.isSelected = false
                customerButton.isSelected = true
                disqualifiedButton.isSelected = false
                allButton.backgroundColor = CommonColor.naviBarBlackColor
                potentialButton.backgroundColor = CommonColor.naviBarBlackColor
                customerButton.backgroundColor = .white
                disqualifiedButton.backgroundColor = CommonColor.naviBarBlackColor
                viewModel.filterContact(isPotential: false, isCustomer: true, isDisqualified: false)
                
            break
        
        case disqualifiedButton :
                allButton.isSelected = false
                potentialButton.isSelected = false
                customerButton.isSelected = false
                disqualifiedButton.isSelected = true
                allButton.backgroundColor = CommonColor.naviBarBlackColor
                potentialButton.backgroundColor = CommonColor.naviBarBlackColor
                customerButton.backgroundColor = CommonColor.naviBarBlackColor
                disqualifiedButton.backgroundColor = .white
                viewModel.filterContact(isPotential: false, isCustomer: false, isDisqualified: true)
                
            break
  
        
        default :
                allButton.isSelected = true
                potentialButton.isSelected = false
                customerButton.isSelected = false
                disqualifiedButton.isSelected = false
                allButton.backgroundColor = .white
                potentialButton.backgroundColor = CommonColor.naviBarBlackColor
                customerButton.backgroundColor = CommonColor.naviBarBlackColor
                disqualifiedButton.backgroundColor = CommonColor.naviBarBlackColor
                viewModel.filterContact(isPotential: false, isCustomer: false, isDisqualified: false)
            
            
        }
       
        tableView.reloadData()
    }
    
    deinit {
        viewModel.notificationToken?.invalidate()
    }
    
    
    @objc func addContact() {
        let contactsDetailsVC = ContactDetailsViewController()
        self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavbarAppear()
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            navigationItem.searchController = nil
        }
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            topStack.snp.makeConstraints { make in
                make.top.equalTo(view.safeArea.top)
                make.left.right.equalToSuperview()
                make.height.equalTo(30)
            }
            

            tableView.snp.makeConstraints { make in
                make.left.right.equalTo(view)
                make.top.equalTo(topStack.snp.bottom)
                make.bottom.equalTo(view).inset(50)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let data = viewModel.contactList  else {
            return []
        }
        
        let contactData: ContactModel
        
        if isFiltering() {
            contactData = viewModel.filteredContacts![indexPath.row]
        } else {
            contactData = data[indexPath.row]
        }
        
        
    
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            self.viewModel.realmStore.delete(modelToDelete: contactData,hard:false)
        }
        
        return [deleteAction]
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        guard let data = viewModel.contactList  else {
            return nil
        }
        
        let contactData: ContactModel
        
        if isFiltering() {
            contactData = viewModel.filteredContacts![indexPath.row]
        } else {
            contactData = data[indexPath.row]
        }
        
        
        let callAction = UIContextualAction(style: .normal, title: "Call") { (action, view, handler) in
            let contactNum = contactData.C_PhoneNo
            
            print(contactNum)
            let url:URL = URL(string: "tel://\(contactNum)")!
            UIApplication.shared.open(url, options: [:], completionHandler: { val in
                
            })
            
        }
        let smsAction = UIContextualAction(style: .normal, title: "SMS") { (action, view, handler) in
            let contactNum = contactData.C_PhoneNo
            let contactName = contactData.C_Name
            
            let actionSheet = UIAlertController(title: "Choose options", message: "Send SMS greetings to your lead.", preferredStyle: .actionSheet)
            
            
            let smsAction = UIAlertAction(title: "SMS", style: .default) { (action:UIAlertAction) in
                //UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
                self.sendSMS(num: contactNum, name: contactName)
            }
            let whatsappAction = UIAlertAction(title: "Whatsapp", style: .default) { (action:UIAlertAction) in
                self.sendWhatsapp(num: contactNum, name: contactName)
            }
           
            actionSheet.addAction(smsAction)
            actionSheet.addAction(whatsappAction)
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(actionSheet, animated: true, completion: nil)
        
        }
        
        let emailAction = UIContextualAction(style: .normal, title: "Email") { (action, view, handler) in
            let emailAddress = contactData.C_Email
            let customerName = contactData.C_Name
            
            if MFMailComposeViewController.canSendMail() {
                
                
                let emailTitle = "Hello"
                let messageBody = "Hello \(customerName),"
                let toRecipents = [emailAddress]
                let mc: MFMailComposeViewController = MFMailComposeViewController()
                mc.mailComposeDelegate = self
                mc.setSubject(emailTitle)
                mc.setMessageBody(messageBody, isHTML: false)
                mc.setToRecipients(toRecipents)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(mc, animated: true, completion: nil)
            } else {
                // show failure alert
                print("Can't send messages.")
            }
            
           
       
        }
        
        
        callAction.backgroundColor = .green
        smsAction.backgroundColor = .yellow
        emailAction.backgroundColor = .orange
        let configuration = UISwipeActionsConfiguration(actions: [callAction,smsAction,emailAction])
        return configuration
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactListCell") as! ContactListTableViewCell
        
        guard let data = viewModel.contactList  else {
            return cell
        }
        
        let contactData: ContactModel
        
        if isFiltering() {
            contactData = viewModel.filteredContacts![indexPath.row]
        } else {
            contactData = data[indexPath.row]
        }
        
        if let userId = userIdSelected,userId == data[indexPath.row].id {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
       
        cell.customerName.text = contactData.C_Name == "" ? "No name": contactData.C_Name
        cell.status.text = contactData.C_Status == "" ? "No Status": contactData.C_Status
        cell.phoneNum.text = contactData.C_PhoneNo == "" ? "No Number": contactData.C_PhoneNo
        cell.email.text = contactData.C_Email == "" ? "No Email": contactData.C_Email
        
        cell.lastCom.text = contactData.C_LastComm == "" ? "Not contacted yet": contactData.C_LastComm
        cell.toFollow.text = contactData.C_ToFollow == "" ? "No meeting yet": contactData.C_ToFollow
        
        if contactData.C_Status == "Potential" {
            
           cell.cellView.backgroundColor =  .lightGray
           cell.toFollow.text = "To Follow"
           cell.toFollow.textColor = .green
            
        } else if contactData.C_Status == "Customer" {
            
            cell.cellView.backgroundColor =  .green
            cell.toFollow.text = "Keep In Touch"
            cell.toFollow.textColor = .blue
            
        } else if contactData.C_Status == "Disqualified" {
            
            cell.cellView.backgroundColor =  .red
            cell.toFollow.text = "Delete Contact"
            cell.toFollow.textColor = .black
            cell.rating.textColor = .black
           
            
        } else {
            
                cell.cellView.backgroundColor = .white
       
        }
        
        //cell.rating.text = "\(contactData.C_Scoring)" == "0" ? "⭐⭐⭐⭐⭐": "\(contactData.C_Scoring)" //⭐
        
        if contactData.C_Scoring == 0 {
            cell.rating.text = "No Ratings"
            cell.rating.textColor = .black
        } else if contactData.C_Scoring == 1 {
             cell.rating.text = "★✩✩✩✩"
             cell.rating.textColor = .yellow
        } else if contactData.C_Scoring == 2 {
            cell.rating.text = "★★✩✩✩"
            cell.rating.textColor = .yellow
        } else if contactData.C_Scoring == 3 {
            cell.rating.text = "★★★✩✩"
            cell.rating.textColor = .yellow
        } else if contactData.C_Scoring == 4 {
            cell.rating.text = "★★★★✩"
            cell.rating.textColor = .yellow
        } else if contactData.C_Scoring == 5 {
            cell.rating.text = "★★★★★"
            cell.rating.textColor = .yellow
        }
        
        ImageCache.default.retrieveImage(forKey: "profile_"+contactData.id, options: nil) {
            image, cacheType in
            if let image = image {
                cell.imgUser.image = image
            } else {
                print("Not exist in cache.")
            }
        }
        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = viewModel.contactList else {
            return 0
        }
        
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: viewModel.filteredContacts!.count, of: data.count)
            return viewModel.filteredContacts!.count
        }
        
        searchFooter.setNotFiltering()
        
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.contactList  else {
            return
        }
        
        let contactData: ContactModel
        
        if isFiltering() {
            contactData = viewModel.filteredContacts![indexPath.row]
        } else {
            contactData = data[indexPath.row]
        }
        
        
        
        if userInContactsSelection {
            delegate?.didSelectCustomer(user:contactData)
            userIdSelected = contactData.id
            tableView.reloadData()
        } else {
            self.openContactForEditing(model: contactData)
//            let contactsDetailsVC = ContactDetailsViewController()
//            self.navigationController?.pushViewController(contactsDetailsVC, animated: true)
        }
    }
    
    func openContactForEditing(model:ContactModel) {
        let detailController = ContactDetailsViewController()
        detailController.isControllerEditing = true
        
        let contactModel = AddContactModel()
        contactModel.addContact_contactName = model.C_Name
        contactModel.addContact_dateOfBirth = model.C_DOB
        contactModel.addContact_address = model.C_Address
        contactModel.addContact_phoneNum = model.C_PhoneNo
        contactModel.addContact_email = model.C_Email
        contactModel.addContact_leadScore = model.C_Scoring
        contactModel.addContact_remarks = model.C_Remark
        contactModel.addContact_status = model.C_Status
        contactModel.addContact_id = model.id
        
        detailController.setupModel = contactModel
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    @objc func sendSMS(num: String, name:String){
        
        
        let mc: MFMessageComposeViewController = MFMessageComposeViewController()
        //let composeVC = MFMessageComposeViewController()
        mc.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        mc.recipients = [num]
        mc.body = "Hello \(name)"
        
        if MFMessageComposeViewController.canSendText() {
            //             UIApplication.shared.keyWindow?.rootViewController?.present(mc, animated: true, completion: nil)
            self.present(mc, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    @objc func sendWhatsapp(num: String, name: String){

        
       
         let url  = "whatsapp://send?phone=\(num)&text=Hello \(name)\nFirst Whatsapp Share"
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
       if let escapedString = url.addingPercentEncoding(withAllowedCharacters: characterSet) {
            
            if let whatsappURL = NSURL(string: escapedString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL){
                    UIApplication.shared.open(whatsappURL as URL)
                }
                else {
                    let errorAlert = UIAlertView(title: "Cannot Send Message", message: "Your device is not able to send WhatsApp messages. Please install Whatsapp in your phone", delegate: self, cancelButtonTitle: "OK")
                    errorAlert.show()
                    
                }
            }
        }
       
    }
    
}

extension ContactListViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ContactListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            viewModel.searchText(text: searchText)
            self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}
   

extension ContactListViewController : MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
}
