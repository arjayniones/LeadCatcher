//
//  SettingsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//


import UIKit
import SwiftyUserDefaults
import Contacts

class SettingsViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource,LargeNativeNavbar {
    let tableView = UITableView()
    let settingsModel = SettingsViewModel()
    
     let settingsLabels = SettingsViewModel.getSettingsLabels() // model with get settings label func
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
        tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            tableView.snp.makeConstraints { make in
                make.top.left.right.equalTo(view)
                make.bottom.equalTo(view).inset(50)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = settingsLabels[indexPath.row].labelName
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsLabels.count //total number of array using models
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let securityVC = SecurityViewController()
            self.navigationController?.pushViewController(securityVC, animated: true) //call security navigation view controller
        }
        else if indexPath.row == 5
        {
            self.getTheContact();
        }
        else if indexPath.row == 10{
            popUpLogOut(title: "Log out", message: "Are you sure you want to log out?")
            
        }
    }
    
    func popUpLogOut(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { val in
            SessionService.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - import phonebook
    func getTheContact()
    {
        let store = CNContactStore();
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    self.presentSettingsActionSheet();
                }
                return
            }
            
            // get the contacts
            
            var contacts = [CNContact]();
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey] as [Any]
            
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor]);
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact);
                }
            } catch {
                print(error);
            }
            
            // do something with the contacts array
            ContactViewModel.processUserContact(contacts:contacts);
        }
    }
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet);
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplicationOpenSettingsURLString)!;
            UIApplication.shared.open(url);
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel));
        present(alert, animated: true);
    }
}


