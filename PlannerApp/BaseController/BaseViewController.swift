//
//  BaseViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class BaseViewController: UIViewController,UINavigationControllerDelegate {
    
    enum ActiveTab: Equatable {
        case rightTab,leftTab
    }
    
    let tabView = UIView()
    
    let homeNavController: BaseNavigationController
    let profileNavController: BaseNavigationController
    var activeNavViewController: BaseNavigationController
    
    let feedButton = UIButton()
    let cameraButton = UIButton()
    let profileButton = UIButton()
    
    
    required init() {
        feedNavController = FeedNavViewController()
        profileNavController = ProfileNavViewController()
        
        activeNavViewController = feedNavController
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(feedNavController)
        addChildViewController(profileNavController)
        
        view.insertSubview(feedNavController.view, at: 0)
        
        tabView.frame = CGRect(x: 0, y: view.height - 50, width: view.width, height: 50)
        tabView.backgroundColor = .white
        self.view.addSubview(tabView)
        
        feedButton.setTitle("🏠", for: UIControlState())
        feedButton.titleLabel?.font = UIFont.ofSize(fontSize: 30, withType: .bold)
        feedButton.addTarget(self, action: #selector(feedButtonPressed), for: .touchUpInside)
        tabView.addSubview(feedButton)
        
        cameraButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCameraButton)))
        cameraButton.addTarget(self, action: #selector(touchStartCameraButton), for: [.touchDown])
        cameraButton.addTarget(self, action: #selector(touchEndCameraButton), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        tabView.addSubview(cameraButton)
        
        profileButton.setTitle("🙎🏻‍♂️", for: UIControlState())
        profileButton.titleLabel?.font = UIFont.ofSize(fontSize: 30, withType: .bold)
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        tabView.addSubview(profileButton)
    }
    
    override func viewDidLayoutSubviews() {
        tabView.groupInCenter(group: .horizontal, views: [feedButton,cameraButton,profileButton], padding: 0, width: view.width/3, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        activeTabColor(.leftTab)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func feedButtonPressed() {
        activeTabColor(.leftTab)
        updateActiveTab(.leftTab)
    }
    
    @objc func profileButtonPressed() {
    }
    
    func updateActiveTab(_ side:ActiveTab) {
        
        activeNavViewController.view.removeFromSuperview()
        
        switch side {
        case .leftTab:
            view.insertSubview(feedNavController.view, at: 0)
            activeNavViewController = feedNavController
        case .rightTab:
            view.insertSubview(profileNavController.view, at: 0)
            activeNavViewController = profileNavController
        }
    }
    
    func hideTabBar() {
        tabView.isHidden = true
    }
    
    func showTabBar() {
        tabView.isHidden = false
    }
    
    func activeTabColor(_ side:ActiveTab) {
        feedButton.isHidden = false
        profileButton.isHidden = false
        tabView.isHidden = false
        
        switch side {
        case .leftTab:
            feedButton.backgroundColor = UIColor("#ffb378").withAlphaComponent(0.5)
            profileButton.backgroundColor = .clear
        case .rightTab:
            profileButton.backgroundColor = UIColor("#ffb378").withAlphaComponent(0.5)
            feedButton.backgroundColor = .clear
        }
    }
}





