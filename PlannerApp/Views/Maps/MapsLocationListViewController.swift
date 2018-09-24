//
//  MapsLocationListViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 21/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapsLocationListViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var currentlocationlbl: UILabel!
    
    var mapView:GMSMapView!
    
    var locationManager:CLLocationManager! = CLLocationManager.init()
    var geoCoder:GMSGeocoder!
    var marker:GMSMarker!
    
    var initialcameraposition:GMSCameraPosition!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView = GMSMapView()
        self.geoCoder = GMSGeocoder()
        self.marker = GMSMarker()
        self.initialcameraposition = GMSCameraPosition()
        
        // Create gms map view------------->
        mapView.frame = CGRect(x: 0, y: 150, width: 414, height: 667)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.isBuildingsEnabled = false
        
        mapView.isTrafficEnabled = false
        self.view.addSubview(mapView)
        // create cureent location label---------->
        
        self.currentlocationlbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.currentlocationlbl.numberOfLines = 3
        self.currentlocationlbl.text = "Fetching address.........!!!!!"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        if locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))
        {
            self.locationManager.requestAlwaysAuthorization()
        }
        self.locationManager.startUpdatingLocation()
        
        if #available(iOS 9, *)
        {
            self.locationManager.allowsBackgroundLocationUpdates = true
        }
        else
        {
            //fallback earlier version
        }
        
        self.locationManager.startUpdatingLocation()
        self.marker.title = "Current Location"
        self.marker.map = self.mapView
        
        // Gps button add mapview
        
        let gpbtn:UIButton! = UIButton.init()
        gpbtn.frame = CGRect(x: 374, y: 500, width: 40, height: 40)
        //gpbtn.addTarget(self, action: #selector(gpsAction), for: .touchUpInside)
        gpbtn.setImage(UIImage(named:"gps.jpg"), for: .normal)
        self.mapView.addSubview(gpbtn)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        var location123 = CLLocation()
        location123 = locations[0]
        let coordinate:CLLocationCoordinate2D! = CLLocationCoordinate2DMake(location123.coordinate.latitude, location123.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16.0)
        
        self.mapView.camera = camera
        self.initialcameraposition = camera
        self.marker.position = coordinate
        self.locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        self.currentAddres(position.target)
    }
    
    func currentAddres(_ coordinate:CLLocationCoordinate2D) -> Void
    {
        geoCoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            
            if error == nil
            {
                if response != nil
                {
                    let address:GMSAddress! = response!.firstResult()
                    
                    if address != nil
                    {
                        let addressArray:NSArray! = address.lines! as NSArray
                        
                        if addressArray.count > 1
                        {
                            var convertAddress:AnyObject! = addressArray.object(at: 0) as AnyObject!
                            let space = ","
                            let convertAddress1:AnyObject! = addressArray.object(at: 1) as AnyObject!
                            let country:AnyObject! = address.country as AnyObject!
                            
                            convertAddress = (((convertAddress.appending(space) + (convertAddress1 as! String)) + space) + (country as! String)) as AnyObject
                            
                            self.currentlocationlbl.text = "\(convertAddress!)".appending(".")
                        }
                        else
                        {
                            self.currentlocationlbl.text = "Fetching current location failure!!!!"
                        }
                    }
                }
            }
        }
    }
}
