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

    let geocoder = GMSGeocoder()
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 1.285,
                                              longitude: 103.848,
                                              zoom: 12)
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
    }
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapView.clear()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                let marker = GMSMarker()
                marker.position = cameraPosition.target
                marker.title = result.lines?[0]
                marker.snippet = result.lines?[1]
                marker.map = mapView
            }
        }
    }


}

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

