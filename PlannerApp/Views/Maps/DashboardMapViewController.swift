//
//  DashboardMapViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 26/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import PreviewTransition
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class DashboardMapViewController: PTDetailViewController {
    
    private var mapView:GMSMapView!
    private var locationManager = CLLocationManager()
    private let realmStore = RealmStore<AddNote>()
    private var didSetupConstraints:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
        self.view.backgroundColor = UIColor.white
        
        self.setupMap()
        
        isAuthorizedtoGetUserLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        view.updateConstraintsIfNeeded()
        view.needsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation();
        }
        
        let data = realmStore.models()
        
        for x in data {
            self.pin(long: (x.addNote_location?.long)!,
                     lat: (x.addNote_location?.lat)!,
                     name: (x.addNote_location?.name)!)
        }
        
        //        let _ = data.map{
        //            self.pin(long: ($0.addNote_location?.long)!,
        //                     lat: ($0.addNote_location?.lat)!,
        //                     name: ($0.addNote_location?.name)!)
        //        }
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            mapView.snp.makeConstraints { make in
                make.edges.equalTo(view).inset(UIEdgeInsets.zero)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}

extension DashboardMapViewController: CLLocationManagerDelegate {
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





