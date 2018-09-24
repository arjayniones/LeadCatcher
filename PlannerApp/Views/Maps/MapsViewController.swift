//
//  MapsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 19/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapsViewController: UIViewController, CLLocationManagerDelegate {

    let markers = [
        MarkerStruct(name: "Appointment 1", lat: 3.0334820, long: 101.66767983, snippet: "Meet with Mr. Lee"),
        MarkerStruct(name: "Appointment 2", lat: 3.0343830, long: 101.63434989, snippet: "Meet with Mr. Yong"),
        MarkerStruct(name: "Appointmet 3", lat: 3.0456640, long: 101.6867993, snippet: "Meet with Mr. Farhar"),
        MarkerStruct(name: "Appointment 4", lat: 3.046850, long: 101.6854973, snippet: "Meet with Mr. Lim"),
         MarkerStruct(name: "Appointment 4", lat: 3.236850, long: 101.6554973, snippet: "Meet with Mr. White")
        ]
    
    
    private var infoWindow = MapMarkerWindow()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    let locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    let didFindMyLocation = false
    var mapMarkers : [GMSMarker] = []

    func loadNiB() -> MapMarkerWindow {
        let infoWindow = MapMarkerWindow.instanceFromNib() as! MapMarkerWindow
        return infoWindow
    }
    
    

    override func viewDidLoad() {

        self.infoWindow = loadNiB()

       
        
        if CLLocationManager.locationServicesEnabled() {

            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        // User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()


        let camera = GMSCameraPosition.camera(withLatitude: 3.046818, longitude: 101.6867983, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView

        //current location 3.046818,101.6867983
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 3.046818, longitude: 101.6867983)
        marker.title = "Software International Corporation"
        marker.snippet = "Kuala Lumpur Malaysia"
        marker.map = mapView


//        // Add a Custom marker 3.0431158,101.6855846
//        let markerAppointments = GMSMarker()
//        markerAppointments.position = CLLocationCoordinate2D(latitude: 3.0431158, longitude: 101.6855846)
//        markerAppointments.title = "Appointment"
//        markerAppointments.snippet = "You have meeting here"
//        markerAppointments.map = mapView
//        markerAppointments.icon = UIImage(named: "book-icon")
        
        //adding multiple markers
        for marker in markers {
                            let position = CLLocationCoordinate2D(latitude: marker.lat, longitude: marker.long)
                            let locationmarker = GMSMarker(position: position)
                            locationmarker.title = marker.name
                            locationmarker.snippet = marker.snippet
                            locationmarker.map = mapView
                            locationmarker.icon = UIImage(named: "book-icon")
                            mapMarkers.append(locationmarker)
        }

    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)

        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView

        locationManager.stopUpdatingLocation()
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
    {
        let markerr = GMSMarker(position: coordinate)
        markerr.position.latitude = coordinate.latitude
        markerr.position.longitude = coordinate.longitude
        print("hello")
        print(markerr.position.latitude)
        let ULlocation = markerr.position.latitude
        let ULlgocation = markerr.position.longitude
        print(ULlocation)
        print(ULlgocation)
        markerr.map = mapView

    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
               mapView.clear()
    }
    
    struct MarkerStruct {
                let name: String
                let lat: CLLocationDegrees
                let long: CLLocationDegrees
                let snippet: String
            }

}


//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        var markerData : NSDictionary?
//        if let data = marker.userData! as? NSDictionary {
//            markerData = data
//        }
//        locationMarker = marker
//        infoWindow.removeFromSuperview()
//        infoWindow = loadNiB()
//        guard let location = locationMarker?.position else {
//            print("locationMarker is nil")
//            return false
//        }
//        // Pass the spot data to the info window, and set its delegate to self
//        infoWindow.spotData = markerData
//        infoWindow.delegate = self as? MapMarkerDelegate
//        // Configure UI properties of info window
//        infoWindow.alpha = 0.9
//        infoWindow.layer.cornerRadius = 12
//        infoWindow.layer.borderWidth = 2
//        infoWindow.layer.borderColor = UIColor.red as! CGColor
//        infoWindow.viewBtn.layer.cornerRadius = infoWindow.viewBtn.frame.height / 2
//
//        let eventName = markerData!["event"]!
//        let dateTime = markerData!["dateTime"]!
//        let desc = markerData!["desc"]!
//        //let toTime = markerData!["toTime"]!
//
//        infoWindow.eventNameLbl.text = eventName as? String
//        infoWindow.dateTimeLbl.text = dateTime as? String //date here
//        infoWindow.descLbl.text = desc as? String //load desc info here
//
//        // Offset the info window to be directly above the tapped marker
//        infoWindow.center = mapView.projection.point(for: location)
//        infoWindow.center.y = infoWindow.center.y - 82
//        self.view.addSubview(infoWindow)
//        return false
//    }
//}

//        func loadMarkersFromDB() {
//            let ref = FIRDatabase.database().reference().child("spots")
//            ref.observe(.childAdded, with: { (snapshot) in
//                if snapshot.value as? [String : AnyObject] != nil {
//                    self.gMapView.clear()
//                    guard let spot = snapshot.value as? [String : AnyObject] else {
//                        return
//                    }
//                    // Get coordinate values from DB
//                    let latitude = spot["latitude"]
//                    let longitude = spot["longitude"]
//
//                    DispatchQueue.main.async(execute: {
//                        let marker = GMSMarker()
//                        // Assign custom image for each marker
//                        let markerImage = self.resizeImage(image: UIImage.init(named: "ParkSpaceLogo")!, newWidth: 30).withRenderingMode(.alwaysTemplate)
//                        let markerView = UIImageView(image: markerImage)
//                        // Customize color of marker here:
//                        markerView.tintColor = rented ? .lightGray : UIColor(hexString: "19E698")
//                        marker.iconView = markerView
//                        marker.position = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
//                        marker.map = self.gMapView
//                        // *IMPORTANT* Assign all the spots data to the marker's userData property
//                        marker.userData = spot
//                    })
//                }
//            }, withCancel: nil)
//        }




//    let geocoder = GMSGeocoder()
//    override func loadView() {
//        let camera = GMSCameraPosition.camera(withLatitude: 1.285,
//                                              longitude: 103.848,
//                                              zoom: 12)
//
//        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//        mapView.delegate = self
//        self.view = mapView
//    }
//
//    // MARK: GMSMapViewDelegate
//
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
//    }
//
//
//    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        mapView.clear()
//    }
//
//    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
//        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
//            guard error == nil else {
//                return
//            }
//
//            if let result = response?.firstResult() {
//                let marker = GMSMarker()
//                marker.position = cameraPosition.target
//                marker.title = result.lines?[0]
//                //marker.snippet = result.lines?[1]
//                marker.map = mapView
//            }
//        }
//    }
//
//
//}



//
//extension MapsViewController: GMSMapViewDelegate{
//    /* handles Info Window tap */
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        print("didTapInfoWindowOf")
//    }
//
//    /* handles Info Window long press */
//    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
//        print("didLongPressInfoWindowOf")
//    }
//
//    /* set a custom Info Window */
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
//        view.backgroundColor = UIColor.white
//        view.layer.cornerRadius = 6
//
//        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
//        lbl1.text = "Hi there!"
//        view.addSubview(lbl1)
//
//        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
//        lbl2.text = "I am a custom info window."
//        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        view.addSubview(lbl2)
//
//        return view
//    }
//
//    //MARK - GMSMarker Dragging
//    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
//        print("didBeginDragging")
//    }
//    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
//        print("didDrag")
//    }
//    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
//        print("didEndDragging")
//    }
//
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
//
//        let marker = GMSMarker()
//        marker.position = coordinate
//    }
//}




//sample code to add multiple markers
//    struct MarkerStruct {
//        let name: String
//        let lat: CLLocationDegrees
//        let long: CLLocationDegrees
//    }
//
//    class MapsViewController: UIViewController, GMSMapViewDelegate {
//        let markers = [
//            MarkerStruct(name: "Food Hut 1", lat: 52.649030, long: 1.174155),
//            MarkerStruct(name: "Foot Hut 2", lat: 35.654154, long: 1.174185),
//            MarkerStruct(name: "Foot Hut 3", lat: 22.654154, long: 1.174185),
//            MarkerStruct(name: "Foot Hut 4", lat: 50.654154, long: 1.174185),
//            ]
//
//        var mapView : GMSMapView? = nil
//
//        var mapMarkers : [GMSMarker] = []
//        var timer : Timer? = nil
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            let camera = GMSCameraPosition.camera(withLatitude: 52.649030, longitude: 1.174155, zoom: 14)
//            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//
//            mapView?.delegate = self
//            self.view = mapView
//
//            for marker in markers {
//                let position = CLLocationCoordinate2D(latitude: marker.lat, longitude: marker.long)
//                let locationmarker = GMSMarker(position: position)
//                locationmarker.title = marker.name
//                locationmarker.map = mapView
//                mapMarkers.append(locationmarker)
//            }
//
//            timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector:  #selector(self.selectRandomMarker), userInfo: nil, repeats: true)
//
//        }
//
//        //Selecting random marker
//        @objc func selectRandomMarker(){
//            let randomIndex = arc4random_uniform(UInt32(self.mapMarkers.count))
//            self.mapView?.selectedMarker = self.mapMarkers[Int(randomIndex)]
//            self.mapView?.animate(toLocation: (self.mapView?.selectedMarker!.position)!)
//        }
//
//}

