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
    
    fileprivate var homeNavController: BaseNavigationController
//    let contactNavController: BaseNavigationController
//    let toDoListNavController: BaseNavigationController
//    let addNoteNavController: BaseNavigationController
    fileprivate var settingsNavController: BaseNavigationController
    
    fileprivate var activeNavViewController: BaseNavigationController
    
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
        
        activeTabColor()
        
        SessionService.onLogout(performAlways: true) {
            self.resetTabController()
        }
    }
    
    func resetTabController() {
        //====== Reset controllers
        homeNavController = HomeNavController()
        settingsNavController = SettingsNavController()
        // ======
        
        self.activeNavViewController.view.removeFromSuperview()
        self.view.insertSubview(self.homeNavController.view, at: 0)
        self.activeNavViewController = self.homeNavController
        self.activeTab = .home
        self.activeTabColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkToLogin()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabView.groupInCenter(group: .horizontal, views: [homeButton,contactButton,addNoteButton,todoListButton,addMoreButton], padding: 0, width: view.width/5, height: 50)
    }
    
    func checkToLogin() {
        if !SessionService.isLoggedIn {
            self.present(LoginViewController(), animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tabButtonPressed(sender:UIButton) {
        switch sender {
        case homeButton:
            self.resetEachController(newTab: .home, oldTab: self.activeTab)
            self.activeTab = .home
            break
        case contactButton:
            self.resetEachController(newTab: .contact, oldTab: self.activeTab)
            self.activeTab = .contact
            break
        case addNoteButton:
            self.resetEachController(newTab: .addNote, oldTab: self.activeTab)
            self.activeTab = .addNote
            break
        case todoListButton:
            self.resetEachController(newTab: .todoList, oldTab: self.activeTab)
            self.activeTab = .todoList
            break
        case addMoreButton:
            self.resetEachController(newTab: .addMore, oldTab: self.activeTab)
            self.activeTab = .addMore
            break
            
        default:
            break
        }
        
        activeTabColor()
        updateActiveTab()
    }
    func resetEachController(newTab:ActiveTab ,oldTab:ActiveTab) {
        if newTab == oldTab {
            self.activeNavViewController.popToRootViewController(animated: true)
        }
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
            break
        case .addMore:
            view.insertSubview(settingsNavController.view, at: 0)
            activeNavViewController = settingsNavController
            break
        default:
            break
        }
        
        checkToLogin()
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

extension UIViewController {
    var tabController: BaseViewController? {
        return navigationController?.parent as? BaseViewController
    }
}





