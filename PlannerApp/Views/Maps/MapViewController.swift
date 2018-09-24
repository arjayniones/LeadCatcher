//
//  MapsPickerViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 21/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//
//

import GoogleMaps
import GooglePlaces
import UIKit

protocol MapViewControllerControllerDelegate:class {
    func controllerDidExit(customerPlace: LocationModel)
}

class MapViewController: ViewControllerProtocol {

    var mapView:GMSMapView!
    var chosenPlace: LocationModel?
    var cameraPosition: GMSCameraPosition!
    weak var delegate: MapViewControllerControllerDelegate?
    
    let txtFieldSearch: UITextField = {
        let tf=UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder="Search for a location"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pick A Location"
        self.view.backgroundColor = UIColor.white

        self.setupMap()
        self.setupTextField()
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        doneButton.sizeToFit()
        doneButton.frame = CGRect(x: 0, y: -2, width: doneButton.width, height: doneButton.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    @objc func doneButtonPressed() {
        
        if let data = chosenPlace {
            delegate?.controllerDidExit(customerPlace:data)
        }
        
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTextField(){
        let img = UIImage(named: "map-pin-icon")
        txtFieldSearch.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        txtFieldSearch.leftView = paddingView
    }
    
    func setupMap() {
        
        cameraPosition = GMSCameraPosition.camera(withLatitude:  28.7041, longitude: 77.1025,
                                                  zoom: 14)
        mapView = GMSMapView.map(withFrame: .zero, camera: cameraPosition)
        mapView.delegate = self
        
        view = mapView
        
        let marker = GMSMarker()
        marker.position = cameraPosition.target
        marker.appearAnimation = .pop
        marker.icon = UIImage(named: "pin_me")
        marker.snippet = "Me"
        marker.map = mapView
        marker.isDraggable = true
    }

}
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        let locationData = LocationModel()
        locationData.name = ""
        locationData.long = marker.position.longitude
        locationData.lat = marker.position.latitude
        
        
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        // TODO: Add code to get address components from the selected place.
        
        // Close the autocomplete widget.
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}



