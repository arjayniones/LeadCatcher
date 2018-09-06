//
//  SecurityViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//


import UIKit

class SecurityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor =  .yellow
       
        edgesForExtendedLayout = []
        
        view.setNeedsUpdateConstraints()
        
    }
    override func updateViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        super.updateViewConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! securityTableViewCell
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

class securityTableViewCell: UITableViewCell {
    let textSample:String = "the quick brown fox jumps over the lazy dog. \nthe quick brown fox jumps over the lazy dog. the quick brown fox jumps over the lazy dog. the quick brown fox jumps over the lazy dog \nthe quick brown fox jumps over the lazy dog."
    let label = UILabel()
    
    var didSetupContraints = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.text = textSample
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        contentView.addSubview(label)
        
    }
    
    override func updateConstraints() {
        if !didSetupContraints {
            
            label.snp.makeConstraints { make in
                make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(10, 10, 10, 0))
            }
            didSetupContraints = true
        }
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


