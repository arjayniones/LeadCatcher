//
//  MapsPickerViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 21/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//
//

import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import UIKit

protocol MapViewControllerDelegate:class {
    func controllerDidExit(customerPlace: LocationModel)
}

class MapViewController: ViewControllerProtocol, LargeNativeNavbar {

    private var mapView:GMSMapView!
    weak var delegate: MapViewControllerDelegate?
    private var locationManager = CLLocationManager()
    
    let txtFieldSearch: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder="Search a location"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        let image = UIImage(named: "mylocation-icon")
        btn.setImage(image, for: .normal)
        
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    private var coordinates:[CLLocationCoordinate2D]?
    
    private var destinationMarker:GMSMarker!
    
    private var fingerIsInTheMap:Bool = false
    
    required init(coordinates:[CLLocationCoordinate2D]?) {
        self.coordinates = coordinates
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pick A Location"
        self.view.backgroundColor = .clear

        self.setupMap()
        self.setupTextField()
        
        self.view.addSubview(btnMyLocation)
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.ofSize(fontSize: 17, withType: .bold)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        doneButton.sizeToFit()
        doneButton.frame = CGRect(x: 0, y: -2, width: doneButton.frame.width, height: doneButton.frame.height)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        
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
        if let userSelectedCoordinates = self.coordinates , userSelectedCoordinates.count > 0{
            
            let camera = self.pin(long: userSelectedCoordinates[0].longitude,
                                lat: userSelectedCoordinates[0].latitude,
                                place: nil)
            
            self.mapView.animate(to: camera)
        }
        
        updateNavbarAppear()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            mapView.snp.makeConstraints { make in
                make.top.equalTo(view.safeArea.top)
                make.left.right.equalTo(view)
                make.bottom.equalTo(view).inset(50)
            }
            
            txtFieldSearch.snp.makeConstraints { make in
                make.top.equalTo(view.safeArea.top)
                make.left.right.equalTo(view)
                make.height.equalTo(40)
            }
            
            btnMyLocation.snp.makeConstraints { make in
                make.bottom.equalTo(view).inset(60)
                make.left.equalTo(view).inset(10)
                make.size.equalTo(CGSize(width:40,height:40))
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    @objc func btnMyLocationAction() {
        let location: CLLocation? = self.mapView.myLocation
        if location != nil {
            mapView.animate(toLocation: (location?.coordinate)!)
        }
    }
    
    @objc func doneButtonPressed() {
        
        if destinationMarker != nil {
            let locationModel = LocationModel()
            locationModel.newInstance()
            locationModel.lat = destinationMarker.position.latitude
            locationModel.long = destinationMarker.position.longitude
            
            if let placeName = destinationMarker.title {
                locationModel.name = placeName
                self.delegate?.controllerDidExit(customerPlace:locationModel)
                self.navigationController?.popViewController(animated: true)
            } else {
                let coordinate = CLLocationCoordinate2D(latitude: destinationMarker.position.latitude, longitude: destinationMarker.position.longitude)
                
                getPlaceDetails(coordinate: coordinate, complete: { val in
                    locationModel.name = val!
                    self.delegate?.controllerDidExit(customerPlace:locationModel)
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTextField(){
        let img = UIImage(named: "map-pin-icon")
        txtFieldSearch.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        txtFieldSearch.leftView = paddingView
        txtFieldSearch.delegate = self
        view.addSubview(txtFieldSearch)
    }
    
    func setupMap() {
    
        let cameraPosition = GMSCameraPosition.camera(withLatitude:  3.048226, longitude: 101.68849909999994,
                                                  zoom: 14)
        mapView = GMSMapView.map(withFrame: .zero, camera: cameraPosition)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("aaaa")
        return true;
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print(marker.position.latitude)
    }
    
    func pin(long: CLLocationDegrees,lat:CLLocationDegrees,place: GMSPlace?) -> GMSCameraPosition {
        
        let cameraPosition = GMSCameraPosition.camera(withLatitude:  lat, longitude: long,zoom: 14)
        
        guard destinationMarker != nil else {
            destinationMarker = GMSMarker()
            destinationMarker.icon = UIImage(named: "map-pin-icon")
            destinationMarker.appearAnimation = .pop
            destinationMarker.map = mapView
            destinationMarker.position = cameraPosition.target
            if place != nil {
                destinationMarker.title = "\(place!.name)"
                destinationMarker.snippet = "\(place!.formattedAddress!)"
                
            } else {
                destinationMarker.snippet = "Me"
            }
            
            return cameraPosition
        }
        
        if place != nil {
            destinationMarker.title = "\(place!.name)"
            destinationMarker.snippet = "\(place!.formattedAddress!)"
        } else {
            destinationMarker.snippet = "Me"
        }
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.1)
        destinationMarker.position = cameraPosition.target
        CATransaction.commit()
        
        return cameraPosition
        
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            fingerIsInTheMap = true
        }
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        fingerIsInTheMap = false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if fingerIsInTheMap {
            _ = self.pin(long: position.target.longitude, lat: position.target.latitude, place: nil)
        }
    }
}
extension MapViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.coordinates = nil
        
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        txtFieldSearch.text = place.formattedAddress
        
        self.mapView.animate(to: self.pin(long: long, lat: lat,place: place))
        self.dismiss(animated: true, completion: nil)
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

extension MapViewController: CLLocationManagerDelegate {
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
        
        guard self.coordinates == nil && self.destinationMarker == nil else {
            return
        }
        
        let camera = self.pin(long: longitude, lat: latitude, place: nil)
        self.mapView.animate(to: camera)
        
        print("my location longitude: ",locations.first?.coordinate.longitude ?? "no longitude")
        print("my location latitude: ",locations.first?.coordinate.latitude ?? "no latitude")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
}



