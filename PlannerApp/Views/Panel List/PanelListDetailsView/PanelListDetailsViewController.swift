//
//  PanelListDetailsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 03/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class PanelListDetailsViewController: ViewControllerProtocol, LargeNativeNavbar {
    
    private var mapView:GMSMapView!
    private var locationManager = CLLocationManager()
    fileprivate let viewModel: PanelListDetailsViewModel
     var isControllerEditing:Bool = false
   private let realmStore = RealmStore<PanelListModel>()
    var latitude : Double!
    var longitude: Double!
    
    
    var setupModel: AddPanelModel? {
        didSet {
            viewModel.addPanelModel = setupModel
        }
    }
    
    required init() {
        viewModel = PanelListDetailsViewModel()
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        //view.layer.shadowColor = UIColor.black as! CGColor
        
        
        
        return view
    }()
    
    
    let nameLabel : UILabel = {
        let namLbl = UILabel()
        namLbl.text = "Hospital Name: "
        namLbl.textColor = .darkGray
        return namLbl
    }()
    
    let nameTextField : UITextField = {
        let nametxt = UITextField()
        nametxt.placeholder = "Enter hospital name here "
        //nametxt.isEnabled = false
        return nametxt
    }()
    
    let contactLabel : UILabel = {
        let contactLbl = UILabel()
        contactLbl.text = "Contact No.: "
        contactLbl.textColor = .darkGray
        return contactLbl
    }()
    
    let contactTextField : UITextField = {
        let contacttxt = UITextField()
        contacttxt.placeholder = "Enter contact number here "
        //contacttxt.isEnabled = false
        
        return contacttxt
    }()
    
    let emailLabel : UILabel = {
        let emailLbl = UILabel()
        emailLbl.text = "Email: "
        emailLbl.textColor = .darkGray
        return emailLbl
    }()
    
    let emailTextField : UITextField = {
        let emailtxt = UITextField()
        emailtxt.placeholder = "Enter email address here "
        emailtxt.text = " Niones Street, Villa Ambrosia Carmen Bohol Philippines 6319"
        //emailtxt.isEnabled = false
        
        return emailtxt
    }()
    
    let addressLabel : UILabel = {
        let addLbl = UILabel()
        addLbl.text = "Address: "
        addLbl.textColor = .darkGray
        return addLbl
    }()
    
    let addressTextField : UITextField = {
        let addresstxt = UITextField()
        addresstxt.placeholder = "Drag the pin to the desired location"
        addresstxt.textAlignment = .left
        addresstxt.adjustsFontForContentSizeCategory = true
        addresstxt.isEnabled = false
        addresstxt.textColor = .black
        addresstxt.adjustsFontSizeToFitWidth = true
        return addresstxt
    }()
    
    @objc func save(){
        
        
        self.viewModel.addPanelModel?.addPanel_name = self.nameTextField.text!
        self.viewModel.addPanelModel?.addPanel_phoneNum = self.contactTextField.text!
        self.viewModel.addPanelModel?.addPanel_email = self.emailTextField.text!
        self.viewModel.addPanelModel?.addPanel_address = self.addressTextField.text!
        
        
        self.viewModel.savePanel(completion: { val in
            if val {
                let alert = UIAlertController(title: "Success,New Contact has been saved.", message: "Clear the fields?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style:.cancel, handler: nil));
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.viewModel.addPanelModel = AddPanelModel()
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion:nil);
            } else {
                let alert = UIAlertController.alertControllerWithTitle(title: "Error", message: "Contacts not saved.")
                self.present(alert, animated: true, completion: nil);
            }
        })
        
    }
    
    @objc func clear() {
        let controller = UIAlertController(title: "Info", message: "Clear the fields?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style:.cancel, handler: nil));
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.viewModel.addPanelModel = AddPanelModel()
            ///self.tableView.reloadData()
        }))
        
        self.present(controller, animated: true, completion: nil);
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation();
        }
        
//        let data = realmStore.models()
//
//        for x in data {
//            self.pin(long: (x.addNote_location?.long)!,
//                     lat: (x.addNote_location?.lat)!,
//                     name: (x.addNote_location?.name)!)
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Panel List Details"
        
        view.addSubview(mainView)
        mainView.addSubview(nameLabel)
        mainView.addSubview(contactLabel)
        mainView.addSubview(addressLabel)
        mainView.addSubview(nameTextField)
        mainView.addSubview(contactTextField)
        mainView.addSubview(addressTextField)
        mainView.addSubview(emailLabel)
        mainView.addSubview(emailTextField)
        
        self.setupMap()
        isAuthorizedtoGetUserLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
      
        
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.sizeToFit()
        saveButton.frame = CGRect(x: 0, y: -2, width: saveButton.width, height: saveButton.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        
        view.setNeedsUpdateConstraints()
        
        self.loadData()
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
    }
    
    
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            mainView.snp.makeConstraints { make in
                make.top.left.right.equalTo(view).inset(10)
                make.bottom.equalTo(view).inset(60)
            }
            nameLabel.snp.makeConstraints {  make in
                make.top.left.equalTo(mainView).offset(10)
                make.height.equalTo(30);
                make.width.equalTo(130)
            }
            
            nameTextField.snp.makeConstraints { make in
                make.top.equalTo(mainView).offset(5)
                make.left.equalTo(nameLabel.snp.right).offset(5)
                make.right.equalTo(mainView).offset(5)
                make.height.equalTo(30);
                
            }
            
            
            contactLabel.snp.makeConstraints {  make in
                make.top.equalTo(nameLabel.snp.bottom)
                make.left.equalTo(mainView).offset(10)
                make.height.equalTo(30);
                make.width.equalTo(130)
            }
            
            contactTextField.snp.makeConstraints { make in
                make.top.equalTo(nameTextField.snp.bottom)
                make.left.equalTo(contactLabel.snp.right).offset(2)
                make.right.equalTo(mainView).offset(5)
                make.height.equalTo(30);
                
            }
            
            emailLabel.snp.makeConstraints {  make in
                make.top.equalTo(contactLabel.snp.bottom)
                make.left.equalTo(mainView).offset(10)
                make.height.equalTo(30);
                make.width.equalTo(130)
            }
            
            emailTextField.snp.makeConstraints { make in
                make.top.equalTo(contactTextField.snp.bottom)
                make.left.equalTo(emailLabel.snp.right).offset(2)
                make.right.equalTo(mainView).offset(5)
                make.height.equalTo(30);
                
            }
            
            addressLabel.snp.makeConstraints {  make in
                make.top.equalTo(emailLabel.snp.bottom)
                make.left.right.equalTo(mainView).offset(10)
                //make.bottom.equalTo(view).offset(20)
                make.height.equalTo(30)
            }
            
            addressTextField.snp.makeConstraints { make in
                make.top.equalTo(emailTextField.snp.bottom)
                make.left.equalTo(emailLabel.snp.right).offset(2)
                make.right.equalTo(mainView).offset(5)
                make.height.equalTo(100);
                
            }
            
            mapView.snp.makeConstraints { make in
                //make.edges.equalTo(view).inset(UIEdgeInsets.zero)
                make.top.equalTo(addressTextField.snp.bottom)
                make.left.right.equalTo(mainView).inset(10)
                make.bottom.equalTo(mainView).inset(30)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func setupMap() {
        
        let cameraPosition = GMSCameraPosition.camera(withLatitude:  3.048226, longitude: 101.68849909999994,
                                                      zoom: 14)
        mapView = GMSMapView.map(withFrame: .zero, camera: cameraPosition)
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
    }
    
    func pin(long: CLLocationDegrees,lat:CLLocationDegrees,name:String) {
        
        let destinationMarker = GMSMarker()
        destinationMarker.appearAnimation = .pop
        destinationMarker.icon = UIImage(named: "map-pin-icon")
        destinationMarker.title = name
        destinationMarker.snippet = name
        destinationMarker.map = mapView
        destinationMarker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    func loadData(){
        
        self.nameTextField.text = self.viewModel.addPanelModel?.addPanel_name
        
        self.contactTextField.text = self.viewModel.addPanelModel?.addPanel_phoneNum
        
        self.emailTextField.text = self.viewModel.addPanelModel?.addPanel_email
        
        self.addressTextField.text = self.viewModel.addPanelModel?.addPanel_address
        
      
        setupMap()
    }
    
    
}

extension PanelListDetailsViewController: CLLocationManagerDelegate {
    func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let latitude = locations.first?.coordinate.latitude else {
            return
        }
        
        self.latitude = latitude
        guard let longitude = locations.first?.coordinate.longitude else {
            return
        }
        self.longitude = longitude
        
        print("my location longitude: ",locations.first?.coordinate.longitude ?? "no longitude")
        print("my location latitude: ",locations.first?.coordinate.latitude ?? "no latitude")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
}



