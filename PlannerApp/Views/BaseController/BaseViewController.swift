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
    let settingsNavController: BaseNavigationController
    
    var activeNavViewController: BaseNavigationController
    
    let homeButton = ActionButton()
    let contactButton = ActionButton()
    let addNoteButton = ActionButton()
    let todoListButton = ActionButton()
    let addMoreButton = ActionButton()
    
    var activeTab:ActiveTab = .home
    
    required init() {
        homeNavController = HomeNavController()
        settingsNavController = SettingsNavController()
        
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
        
        homeButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addSubview(homeButton)
        
        contactButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addSubview(contactButton)
        
        addNoteButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addSubview(addNoteButton)
        
        todoListButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addSubview(todoListButton)
        
        addMoreButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addSubview(addMoreButton)
        
        self.activeTabColor()
    }
    
    
    override func viewDidLayoutSubviews() {
        tabView.groupInCenter(group: .horizontal, views: [homeButton,contactButton,addNoteButton,todoListButton,addMoreButton], padding: 0, width: view.width/5, height: 50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tabButtonPressed(sender:UIButton) {
        switch sender {
        case homeButton:
            self.activeTab = .home
            break
        case contactButton:
            self.activeTab = .contact
            break
        case addNoteButton:
            self.activeTab = .addNote
            break
        case todoListButton:
            self.activeTab = .todoList
            break
        case addMoreButton:
            self.activeTab = .addMore
            break
            
        default:
            break
        }
        
        activeTabColor()
        updateActiveTab()
    }
    
    func updateActiveTab() {
        
        activeNavViewController.view.removeFromSuperview()
        
        switch self.activeTab {
        case .home:
            view.insertSubview(homeNavController.view, at: 0)
            activeNavViewController = homeNavController
//        case .contact:
//            view.insertSubview(RegisterViewController1 at: 1);
//            activeNavViewController =
        case .todoList:
            SessionService.logout()
            break
        case .addMore:
            view.insertSubview(settingsNavController.view, at: 0)
            print("addmore")
            break
        default:
            break
        }
    }
    
    func activeTabColor() {
        homeButton.isActive = false
        contactButton.isActive = false
        addNoteButton.isActive = false
        todoListButton.isActive = false
        addMoreButton.isActive = false
        
        switch self.activeTab {
        case .home:
            homeButton.isActive = true
        case .contact:
            contactButton.isActive = true
        case .addNote:
            addNoteButton.isActive = true
        case .todoList:
            todoListButton.isActive = true
        case .addMore:
            addMoreButton.isActive = true
        }
        
    }
    
    func hideTabBar() {
        tabView.isHidden = true
    }
    
    func showTabBar() {
        tabView.isHidden = false
    }
}





