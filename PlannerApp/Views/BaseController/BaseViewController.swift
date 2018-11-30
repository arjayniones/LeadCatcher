//
//  BaseViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 06/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class BaseViewController: ViewControllerProtocol,UINavigationControllerDelegate {
    
    enum ActiveTab: Equatable {
        case home,contact,addNote,todoList,addMore
    }
    fileprivate var homeNavController: BaseNavigationController
    fileprivate var contactNavController: BaseNavigationController
    fileprivate var addNoteNavController: BaseNavigationController
    fileprivate var toDoListNavController: BaseNavigationController
    fileprivate var settingsNavController: BaseNavigationController
    
    fileprivate var activeNavViewController: BaseNavigationController
    
    let homeButton = ActionButton()
    let contactButton = ActionButton()
    let addNoteButton = ActionButton()
    let todoListButton = ActionButton()
    let addMoreButton = ActionButton()
    
    var activeTab:ActiveTab = .home
    
    let tabView = UIStackView()
    let bgTabView = UIView()
    var bgImageView:UIImageView!
    
    required init() {
        homeNavController = HomeNavController()
        settingsNavController = SettingsNavController()
        contactNavController = ContactListNavViewController()
        addNoteNavController = AddNoteNavViewController()
        toDoListNavController = TodoListNavViewController()
        
        activeNavViewController = homeNavController
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView = UIImageView(frame: view.bounds)
        bgImageView.isUserInteractionEnabled = true
        bgImageView.image = UIImage(named: "contact-details-gradiant-bg")
        view = bgImageView
        
        addChild(homeNavController)
        view.insertSubview(homeNavController.view, at: 0)
        
        bgTabView.backgroundColor = .clear
        self.view.addSubview(bgTabView)
        
        tabView.spacing = 0
        tabView.axis = .horizontal
        tabView.distribution = .fillEqually
        self.view.addSubview(tabView)
        
        homeButton.setImage(UIImage(named:"home-icon-inactive"), for: .normal)
        homeButton.setImage(UIImage(named:"home-icon-active"), for: .selected)
        homeButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addArrangedSubview(homeButton)
        
        contactButton.setImage(UIImage(named:"profile-icon-inactive"), for: .normal)
        contactButton.setImage(UIImage(named:"profile-icon-active"), for: .selected)
        contactButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addArrangedSubview(contactButton)
        
        addNoteButton.setImage(UIImage(named:"plus-icon-inactive"), for: .normal)
        addNoteButton.setImage(UIImage(named:"plus-icon-active"), for: .selected)
        addNoteButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addArrangedSubview(addNoteButton)
        
        todoListButton.setImage(UIImage(named:"book-icon-inactive"), for: .normal)
        todoListButton.setImage(UIImage(named:"book-icon-active"), for: .selected)
        todoListButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addArrangedSubview(todoListButton)
        
        addMoreButton.setImage(UIImage(named:"more-icon-inactive"), for: .normal)
        addMoreButton.setImage(UIImage(named:"more-icon-active"), for: .selected)
        addMoreButton.addTarget(self, action: #selector(tabButtonPressed(sender:)), for: .touchUpInside)
        tabView.addArrangedSubview(addMoreButton)
        
        activeTabColor()
        
        SessionService.onLogout(performAlways: true) {
            self.resetTabController()
        }
        
        view.updateConstraintsIfNeeded()
        view.setNeedsUpdateConstraints()
    }
    
    func resetTabController() {
        //====== Reset controllers
        homeNavController = HomeNavController()
        settingsNavController = SettingsNavController()
        contactNavController = ContactListNavViewController()
        addNoteNavController = AddNoteNavViewController()
        toDoListNavController = TodoListNavViewController()
        // ======
        
        self.activeNavViewController.view.removeFromSuperview()
        self.view.insertSubview(self.homeNavController.view, at: 0)
        self.activeNavViewController = self.homeNavController
        self.activeTab = .home
        self.activeTabColor()
    }
  
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            tabView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.zero)
                make.height.equalTo(50)
            }
            
            bgTabView.snp.makeConstraints { make in
                make.center.equalTo(tabView)
                make.size.equalTo(tabView)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
        
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
        case .contact:
            view.insertSubview(contactNavController.view, at: 0);
            activeNavViewController = contactNavController
        case .addNote:
            view.insertSubview(addNoteNavController.view, at: 0)
            activeNavViewController = addNoteNavController
            break
        case .todoList:
            view.insertSubview(toDoListNavController.view, at: 0)
            activeNavViewController = toDoListNavController
            break
        case .addMore:
            view.insertSubview(settingsNavController.view, at: 0)
            activeNavViewController = settingsNavController
            break
        }
        
//        checkToLogin()
    }
    
    func activeTabColor() {
        homeButton.isSelected = false
        contactButton.isSelected = false
        addNoteButton.isSelected = false
        todoListButton.isSelected = false
        addMoreButton.isSelected = false
        
        switch self.activeTab {
        case .home:
            homeButton.isSelected = true
        case .contact:
            contactButton.isSelected = true
        case .addNote:
            addNoteButton.isSelected = true
        case .todoList:
            todoListButton.isSelected = true
        case .addMore:
            addMoreButton.isSelected = true
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

class PassThroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}







