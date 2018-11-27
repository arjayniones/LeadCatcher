//
//  SelfSizedTableView.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 27/11/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let x = CGFloat(self.numberOfRows(inSection: 0))
        
        let height = min(contentSize.height,x * maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
