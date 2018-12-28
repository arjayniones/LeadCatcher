//
//  MapView.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 26/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

protocol MapViewDelegate:class {
    func getMarkerLongLat(long:Double, lat:Double)
}

class MapView: UIView,GMSMapViewDelegate {
    
    private var mapView:GMSMapView!
    weak var delegate: MapViewDelegate?
    private var didSetupConstraints:Bool = false
    
    //var tap = UITapGestureRecognizer();

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //tap = UITapGestureRecognizer(target: self, action: #selector(tapCustomInfoView))
        self.isUserInteractionEnabled = true
        let cameraPosition = GMSCameraPosition.camera(withLatitude:  3.048226, longitude: 101.68849909999994,
                                                      zoom: 14)
        mapView = GMSMapView.map(withFrame: .zero, camera: cameraPosition)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        addSubview(mapView)
        
        needsUpdateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            mapView.snp.makeConstraints{ make in
                make.edges.equalToSuperview()
            }
            
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pin(data:AddNote) {
        
        guard let location = data.addNote_location else {
            
            return
        }
        
        let destinationMarker = GMSMarker()
        destinationMarker.appearAnimation = .pop
        destinationMarker.icon = UIImage(named: "map-pin-icon")
        destinationMarker.title = data.addNote_subject
        destinationMarker.snippet = location.name
        destinationMarker.map = mapView
        destinationMarker.position = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
        
    }
    
    func clearAllPin()
    {
        // clear all marker
        mapView.clear()
    }
    
    func pointCamera(location:LocationModel?) {
        guard location != nil else {
            return
        }
        
        let pos = GMSCameraPosition.camera(withLatitude:  location!.lat, longitude: location!.long,
                                 zoom: 14)
        mapView.camera = pos
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        self.delegate?.getMarkerLongLat(long:marker.position.longitude, lat: marker.position.latitude)
    }
    /*
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        view.isUserInteractionEnabled = true
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        let btn = UIButton(frame: CGRect(x:lbl1.frame.origin.x, y:lbl2.frame.size.height + lbl2.frame.origin.y + 5, width:view.frame.size.width - 16, height:30))
        btn.isUserInteractionEnabled = true
        btn.setTitle("Go", for: .normal)
        btn.setTitleColor(CommonColor.systemBlueColor, for: .normal)
        btn.addTarget(self, action: #selector(tapCustomInfoView), for: .touchUpInside)
        //view.addSubview(btn)
        
        return view
        
    }
    */
    
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        print("did long press")
    }
    
    @objc func tapCustomInfoView(sender: UIButton!)
    {
        print("i am custom info view")
    }
    
}
