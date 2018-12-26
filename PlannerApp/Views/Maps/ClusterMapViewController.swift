//
//  ClusterMapViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 26/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import CoreLocation
import UIKit

class ClusterMapViewController: ViewControllerProtocol {
    
    private var mapView = MapView()
    private var locationManager = CLLocationManager()
    private let realmStore = RealmStore<AddNote>()
    private let closeButton = ActionButton()
    var isControllerPresented:Bool = false
    
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
        
        let data = realmStore.models()
        
        for x in data {
            mapView.pin(data: x)
        }
        
        if data.count > 0 {
            mapView.pointCamera(location: data.first?.addNote_location)
        }
        
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
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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




