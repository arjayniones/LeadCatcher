//
//  PanelListDetailsViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 03/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class PanelListDetailsViewController: ViewControllerProtocol, LargeNativeNavbar {

    private var mapView:GMSMapView!
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        //view.layer.shadowColor = UIColor.black as! CGColor
        
        
        return view
    }()
    
    let nameLabel : UILabel = {
        let namLbl = UILabel()
        namLbl.text = "Hospital Name: "
        namLbl.textColor = .white
        return namLbl
    }()
    
    let contactLabel : UILabel = {
        let contactLbl = UILabel()
        contactLbl.text = "Contact Number: "
        contactLbl.textColor = .white
        return contactLbl
    }()
    
    let addressLabel : UILabel = {
        let addLbl = UILabel()
        addLbl.text = "Address"
        addLbl.textColor = .white
        return addLbl
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Panel List Details"
        
        view.addSubview(mainView)
        mainView.addSubview(nameLabel)
        mainView.addSubview(contactLabel)
        mainView.addSubview(addressLabel)

        self.setupMap()
        
        view.setNeedsUpdateConstraints()

        func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
        

 }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            mainView.snp.makeConstraints { make in
                make.top.left.right.equalTo(view).inset(10)
                make.bottom.equalTo(view).inset(60)
            }
            nameLabel.snp.makeConstraints {  make in
               make.top.left.equalTo(mainView).offset(5)
                make.height.equalTo(30);
               // make.bottom.equalTo(view).offset(20)
            }
            contactLabel.snp.makeConstraints {  make in
                make.top.equalTo(nameLabel.snp.bottom)
                make.left.right.equalTo(nameLabel).offset(0)
                make.height.equalTo(30);
                //make.bottom.equalTo(view).offset(20)
            }
            addressLabel.snp.makeConstraints {  make in
                make.top.equalTo(contactLabel.snp.bottom)
                make.left.right.equalTo(contactLabel).offset(0)
                //make.bottom.equalTo(view).offset(20)
                make.height.equalTo(50)
            }
            
            mapView.snp.makeConstraints { make in
                //make.edges.equalTo(view).inset(UIEdgeInsets.zero)
                make.top.equalTo(addressLabel.snp.bottom)
                make.left.right.equalTo(mainView).inset(10)
                make.bottom.equalTo(mainView).inset(30)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func setupMap() {
        
        let cameraPosition = GMSCameraPosition.camera(withLatitude:  3.048226, longitude: 101.68849909999994,
                                                      zoom: 14)
        mapView = GMSMapView.map(withFrame: .zero, camera: cameraPosition)
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
    }

}