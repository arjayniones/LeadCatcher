//
//  MapMarkerWindow.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 20/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import Foundation
import UIKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: NSDictionary)
}

class MapMarkerWindow: UIView {
    
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    
    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton(data: spotData!)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
