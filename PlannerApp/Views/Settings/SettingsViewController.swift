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
import Kingfisher

class SettingsViewController: ViewControllerProtocol,UITableViewDelegate,UITableViewDataSource,LargeNativeNavbar {
    let tableView = UITableView()
    let settingsModel = SettingsViewModel()
    
    let settingsLabels = SettingsViewModel.getSettingsLabels() // model with get settings label func
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
        view.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        imagePicker.delegate = self
        
        view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
        view.updateConstraintsIfNeeded()
        tableView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = settingsLabels[indexPath.row].labelName
        cell.textLabel?.font = UIFont.ofSize(fontSize: 20, withType: .bold)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
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
            //SummaryViewController
            let summaryVC = SummaryViewController()
            self.navigationController?.pushViewController(summaryVC, animated: true)

        } else if indexPath.row == 1{
            self.navigationController?.pushViewController(ClusterMapViewController(), animated: false)
        } else if indexPath.row == 2{
             self.getTheContact();
        } else if indexPath.row == 3{
            let messageTempVC = MessageTemplatesViewController()
            self.navigationController?.pushViewController(messageTempVC, animated: true)
        } else if indexPath.row == 4{
            let resourcesVC = ResourceViewController()
            self.navigationController?.pushViewController(resourcesVC, animated: true)
        } else if indexPath.row == 5 {
            self.uploadImage()
        }

    }
    

//    func popUpLogOut(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { val in
//            SessionService.logout()
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//
//    }

    
    // MARK: - import phonebook
    func getTheContact()
    {
        let store = CNContactStore();
        // show permission to access phonebook
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    // user not allow at first time and click import again then call this
                    self.presentSettingsActionSheet();
                }
                return
            }
            
            // get the contacts
            var contacts = [CNContact]();
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey,CNContactPostalAddressesKey] as [Any]
            
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor]);
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    print(contact.postalAddresses);
                    contacts.append(contact);
                }
            } catch {
                print(error);
            }
            
            // do something with the 'contacts' array
            ContactViewModel.processUserContact(contacts: contacts, completetion:
            {
                result in
                if result == "Success"
                {
                    let alert = UIAlertController.alertControllerWithTitle(title: "Info", message: "Success import contact from phonebook");
                    self.present(alert, animated:false, completion: nil);
                }
            });
        }
    }
    
    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet);
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!;
            UIApplication.shared.open(url);
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel));
        present(alert, animated: true);
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func uploadImage() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.saveImage(image: pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(image:UIImage) {
        ImageCache.default.store(image, forKey: "background_image")

        NotificationCenter.default.post(name: notificationChangeImage, object: nil)
        
    }
}
 
