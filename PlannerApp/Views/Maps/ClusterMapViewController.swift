//
//  ClusterMapViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 26/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import CoreLocation
import UIKit
import RealmSwift

class ClusterMapViewController: ViewControllerProtocol {

    
    
    private var mapView = MapView()
    private var locationManager = CLLocationManager()
    private let realmStore = RealmStore<AddNote>()
    private let closeButton = ActionButton()

    var isControllerPresented:Bool = false
    var isFromSetting:Bool = false
    let bottomView = UIView();
    
    let headerDateView = UIView();
    let buttonHeaderDate = UIButton();
    let buttonHeaderLeft = UIButton();
    let buttonHeaderRight = UIButton();
    var index:Int = 0
    let calendar = NSCalendar.current
    var currentDate = Date()
    
    let buttonLeft = UIButton();
    let buttonRight = UIButton();
    let datePickerView = UIDatePicker();
    fileprivate let viewModel = TodoListViewModel()
    fileprivate var clonedData: [AddNote] = []
    var selectedDate = Date();

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        title = "Map"
        self.view.backgroundColor = .clear
        view.addSubview(mapView)
        isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        closeButton.setBackgroundImage(UIImage(named: "left-arrow-icon"), for: .normal)
        closeButton.isHidden = !isControllerPresented
        closeButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        view.addSubview(closeButton)
        if isFromSetting == true {
            headerDateView.backgroundColor = UIColor.white
            buttonHeaderRight.setImage(UIImage(named: "chevron-right"), for: .normal)
            buttonHeaderRight.addTarget(self, action: #selector(didNextAction), for: .touchUpInside)

            buttonHeaderLeft.setImage(UIImage(named: "chevron-left"), for: .normal)
            buttonHeaderLeft.addTarget(self, action: #selector(didBackAction), for: .touchUpInside)

            buttonHeaderDate.setTitle(convertDateTimeToString(date: currentDate,dateFormat: "dd MMM yyyy"), for: .normal)
            buttonHeaderDate.addTarget(self, action: #selector(didDateAction), for: .touchUpInside)
            buttonHeaderDate.setTitleColor(UIColor.black, for: .normal);
            buttonHeaderDate.titleLabel?.font = UIFont.ofSize(fontSize: 20, withType: .regular)
            headerDateView.addSubview(buttonHeaderDate)
            headerDateView.addSubview(buttonHeaderLeft)
            headerDateView.addSubview(buttonHeaderRight)

            view.addSubview(headerDateView)

            // for datepicker
            bottomView.backgroundColor = UIColor.white;
            buttonLeft.setTitle("Cancel", for: .normal);
            buttonRight.setTitle("Done", for: .normal);
            buttonLeft.setTitleColor(self.view.tintColor, for: .normal);
            buttonRight.setTitleColor(self.view.tintColor, for: .normal);
            datePickerView.datePickerMode = .date;
            datePickerView.timeZone = NSTimeZone.local;
            buttonRight.addTarget(self, action: #selector(doneButtonClick), for: .touchUpInside);
            buttonLeft.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside);
            self.view.addSubview(bottomView);
            self.bottomView.addSubview(datePickerView);
            self.bottomView.addSubview(buttonLeft);
            self.bottomView.addSubview(buttonRight);
            self.bottomView.isHidden = true;
        }

        viewModel.notificationToken = viewModel.todoListData?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .update(_, _, let insertions,  _):
                
                _ = insertions.map({
                    if let note = self?.viewModel.todoListData?[$0] {
                        self?.clonedData.append(note)
                        self?.mapView.pin(data: note)
                    }
                    
                })
            case .initial(_):
                self?.viewModel.todoListData?.forEach{ (data ) in
                    self?.mapView.pin(data: data)
                    
                    self?.clonedData.append(data)
                    
                }
                self!.updatePin(date: Date())
                break
            case .error(_):
                break
            }
        }
        view.updateConstraintsIfNeeded()
        view.needsUpdateConstraints()
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation();
        }
        var dateStart = Calendar.current.startOfDay(for: Date())
        if !isFromSetting
        {
            dateStart = selectedDate
        }
        
        updatePin(date: dateStart)
        /*
        let predicate = SettingsViewModel.init().dateFilterForClusterMapView(date: dateStart)
        let data = realmStore.models(query: "deleted_at == nil && status != 'Completed'")?.filter(predicate)
        
        if data!.count > 0
        {
            //mapView.clearAllPin()
            for x in data! {
                mapView.pin(data: x)
            }
            
            if data!.count > 0 {
                mapView.pointCamera(location: data!.first?.addNote_location)
            }
        }
 */
        
        
        updateViewConstraints()

    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            closeButton.snp.makeConstraints { make in
                make.top.equalTo(view.safeArea.top).inset(20)
                make.size.equalTo(CGSize(width: 40, height: 40))
                make.left.equalToSuperview().inset(20)
            }
            
            mapView.snp.makeConstraints { make in
                //make.edges.equalTo(view).inset(UIEdgeInsets.zero)
                make.top.equalTo(view.safeArea.top)
                make.left.right.equalTo(view)
                make.bottom.equalTo(view).inset(50)
            }
     
            if isFromSetting == true {
            headerDateView.snp.makeConstraints { make in
                    //make.edges.equalTo(view).inset(UIEdgeInsets.zero)
                    make.top.equalTo(view.safeArea.top)
                    make.left.right.equalTo(view)
                    make.height.equalTo(50)
                }
                buttonHeaderLeft.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.width.equalTo(80)
                    make.left.equalToSuperview()
                }
                buttonHeaderRight.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.width.equalTo(80)
                    make.rightMargin.equalTo(0)
                }
                buttonHeaderDate.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.leading.equalTo(0)
                    make.trailing.equalTo(0)
                }

                
            bottomView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.view).inset(0);
                make.bottom.equalTo(self.view).inset(50);
                make.height.equalTo(210)
            }
            
            buttonLeft.snp.makeConstraints { (make) in
                make.left.equalTo(0);
                make.top.equalTo(self.bottomView).inset(10);
                make.width.equalTo(70);
                make.height.equalTo(36);
            }
            
            buttonRight.snp.makeConstraints { (make) in
                make.right.equalTo(0);
                make.top.equalTo(self.bottomView).inset(10);
                make.width.equalTo(70);
                make.height.equalTo(36);
            }
            
            datePickerView.snp.makeConstraints { (make) in
                make.left.right.equalTo(self.bottomView).inset(0);
                make.bottom.equalTo(self.view).inset(50);
                make.top.equalTo(self.buttonRight.snp.bottom).offset(5);
                make.height.equalTo(162);
                
            }
            }
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func cancelButtonClick()
    {
        self.bottomView.isHidden = true;
    }
    
    @objc func doneButtonClick() {
//        viewModel.addNoteModel?.addNote_alertDateTime = self.datePickerView.date
        updatePin(date: datePickerView.date)
        currentDate = datePickerView.date
        buttonHeaderDate.setTitle(convertDateTimeToString(date: datePickerView.date,dateFormat: "dd MMM yyyy"), for: .normal)

        self.bottomView.isHidden = true;
    }
    @objc func didBackAction() {
        let comps2 = NSDateComponents()
        comps2.day = index - 1
        let previousDate = calendar.date(byAdding: comps2 as DateComponents, to: currentDate)
        currentDate = previousDate!
        buttonHeaderDate.setTitle(convertDateTimeToString(date: currentDate,dateFormat: "dd MMM yyyy"), for: .normal)
        updatePin(date: currentDate)
        
    }
    
    @objc func didNextAction() {
        let comps2 = NSDateComponents()
        comps2.day = index + 1
        let nextDate = calendar.date(byAdding: comps2 as DateComponents, to: currentDate)
        currentDate = nextDate!
        buttonHeaderDate.setTitle(convertDateTimeToString(date: currentDate,dateFormat: "dd MMM yyyy"), for: .normal)
        updatePin(date: currentDate)

    }
    
   @objc func didDateAction() {
        self.bottomView.isHidden = false
        updatePin(date: currentDate)
    }
    
    func updatePin(date:Date)  {
        mapView.clearAllPin()
        viewModel.filteredDates =  clonedData.filter({
            convertDateTimeToString(date: $0.addNote_alertDateTime!,dateFormat: "dd MMM yyyy") == convertDateTimeToString(date: date,dateFormat: "dd MMM yyyy")
        })
        
        for i in 0..<viewModel.filteredDates.count
        {
            mapView.pin(data: viewModel.filteredDates[i])
        }
        
        if viewModel.filteredDates.count > 0 {
            mapView.pointCamera(location: viewModel.filteredDates[0].addNote_location)
        }
        
        
    }
}


extension ClusterMapViewController:MapViewDelegate
{
    func getMarkerLongLat(long: Double, lat: Double) {
        
        let actionSheet = UIAlertController(title: "Choose options", message: "Select navigation app.", preferredStyle: .actionSheet)
        
        
        let mapAction = UIAlertAction(title: "Apple Map", style: .default) { (action:UIAlertAction) in
            let directionsURL = "http://maps.apple.com/?saddr=\(self.locationManager.location!.coordinate.latitude),\(self.locationManager.location!.coordinate.longitude)&daddr=\(lat),\(long)"
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
            //UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
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


extension ClusterMapViewController: CLLocationManagerDelegate {
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
        guard let longitude = locations.first?.coordinate.longitude else {
            return
        }
        
        print("my location longitude: ",locations.first?.coordinate.longitude ?? "no longitude")
        print("my location latitude: ",locations.first?.coordinate.latitude ?? "no latitude")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
}




