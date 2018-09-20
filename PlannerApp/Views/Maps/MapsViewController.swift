//
//  MapsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 19/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController, GMSMapViewDelegate {
    
    private var infoWindow = MapMarkerWindow()
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    
    func loadNiB() -> MapMarkerWindow {
        let infoWindow = MapMarkerWindow.instanceFromNib() as! MapMarkerWindow
        return infoWindow
    }

    override func viewDidLoad() {
        
        self.infoWindow = loadNiB()
        
        
        //let latitude = ""
        //let longitude = ""
        
         //Create a GMSCameraPosition that tells the map to display the
                // coordinate -33.86,151.20 at zoom level 6.
                let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                //mapView.animate(toZoom: 200)
                mapView.settings.myLocationButton = true
                view = mapView
        
                // Creates a marker in the center of the map.
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
                marker.title = "Sydney"
                marker.snippet = "Australia"
                marker.map = mapView
        
        
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
        
        
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var markerData : NSDictionary?
        if let data = marker.userData! as? NSDictionary {
            markerData = data
        }
        locationMarker = marker
        infoWindow.removeFromSuperview()
        infoWindow = loadNiB()
        guard let location = locationMarker?.position else {
            print("locationMarker is nil")
            return false
        }
        // Pass the spot data to the info window, and set its delegate to self
        infoWindow.spotData = markerData
        infoWindow.delegate = self as? MapMarkerDelegate
        // Configure UI properties of info window
        infoWindow.alpha = 0.9
        infoWindow.layer.cornerRadius = 12
        infoWindow.layer.borderWidth = 2
        infoWindow.layer.borderColor = UIColor.red as! CGColor
        infoWindow.viewBtn.layer.cornerRadius = infoWindow.viewBtn.frame.height / 2
        
        let eventName = markerData!["event"]!
        let dateTime = markerData!["dateTime"]!
        let desc = markerData!["desc"]!
        //let toTime = markerData!["toTime"]!
        
        infoWindow.eventNameLbl.text = eventName as? String
        infoWindow.dateTimeLbl.text = dateTime as? String //date here
        infoWindow.descLbl.text = desc as? String //load desc info here
        
        // Offset the info window to be directly above the tapped marker
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - 82
        self.view.addSubview(infoWindow)
        return false
    }
}
    
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

//UIViewController {
//
//
//    // You don't need to modify the default init(nibName:bundle:) method.
//
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        //mapView.animate(toZoom: 200)
//        mapView.settings.myLocationButton = true
//        view = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//
//
//
//    }
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

