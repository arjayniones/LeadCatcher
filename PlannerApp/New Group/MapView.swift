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

class MapView: UIView {
    
    private var mapView:GMSMapView!
    private var didSetupConstraints:Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cameraPosition = GMSCameraPosition.camera(withLatitude:  3.048226, longitude: 101.68849909999994,
                                                      zoom: 14)
        mapView = GMSMapView.map(withFrame: .zero, camera: cameraPosition)
        mapView.isMyLocationEnabled = true
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
