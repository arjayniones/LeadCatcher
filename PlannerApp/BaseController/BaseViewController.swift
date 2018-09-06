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
        case home,contact,addNote,todoList,addMore
    }
    
    let tabView = UIView()
    
    let homeNavController: BaseNavigationController
//    let contactNavController: BaseNavigationController
//    let toDoListNavController: BaseNavigationController
//    let addNoteNavController: BaseNavigationController
    
    var activeNavViewController: BaseNavigationController
    
    let homeButton = UIButton()
    let contactButton = UIButton()
    let addNoteButton = UIButton()
    let todoListButton = UIButton()
    let addMoreButton = UIButton()
    
    required init() {
        homeNavController = HomeNavController()
        
        activeNavViewController = homeNavController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(homeNavController)
        
        view.insertSubview(homeNavController.view, at: 0)
        
        tabView.frame = CGRect(x: 0, y: view.height - 50, width: view.width, height: 50)
        tabView.backgroundColor = .white
        self.view.addSubview(tabView)
        
        homeButton.setTitle("🏠", for: UIControlState())
        homeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        tabView.addSubview(homeButton)
        
        contactButton.setTitle("🏠", for: UIControlState())
        contactButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        contactButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        tabView.addSubview(contactButton)
        
        addNoteButton.setTitle("🏠", for: UIControlState())
        addNoteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        addNoteButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        tabView.addSubview(addNoteButton)
        
        todoListButton.setTitle("🏠", for: UIControlState())
        todoListButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        todoListButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        tabView.addSubview(todoListButton)
        
        addMoreButton.setTitle("🏠", for: UIControlState())
        addMoreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        addMoreButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        tabView.addSubview(addMoreButton)
    }
    
    override func viewDidLayoutSubviews() {
        tabView.groupInCenter(group: .horizontal, views: [homeButton,contactButton,addNoteButton,todoListButton,addMoreButton], padding: 0, width: view.width/5, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        activeTabColor(.home)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func homeButtonPressed() {
        
    }
    
    @objc func profileButtonPressed() {
    }
    
    func updateActiveTab(_ side:ActiveTab) {
        
        activeNavViewController.view.removeFromSuperview()
        
        switch side {
        case .home:
            view.insertSubview(homeNavController.view, at: 0)
            activeNavViewController = homeNavController
        default:
            break
        }
    }
    
    func hideTabBar() {
        tabView.isHidden = true
    }
    
    func showTabBar() {
        tabView.isHidden = false
    }
    
    func activeTabColor(_ side:ActiveTab) {
        switch side {
        case .home:
            homeButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        default:
            break
        }
    }
}





