//
//  NotesViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 18/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

protocol NotesViewControllerDelegate {
    var userNotes:String { get set }
}

class NotesViewController: ViewControllerProtocol {
    
    var delegate: NotesViewControllerDelegate?
    
    fileprivate let notesPopUp = NotesPopUpControllerView()
    fileprivate let doneButton = ActionButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(rgb:0xFFFFCC)
        view.addSubview(notesPopUp)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .clear
        doneButton.setTitleColor(.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        view.addSubview(doneButton)
        
        view.updateConstraintsIfNeeded()
    }
    
    @objc func doneButtonPressed() {
        
        if let data = notesPopUp.tField.text {
            delegate?.userNotes = data
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            doneButton.snp.makeConstraints { make in
                make.top.equalTo(view).inset(20)
                make.right.equalTo(view).inset(10)
                make.size.equalTo(CGSize(width: 100, height: 40))
            }
            notesPopUp.snp.makeConstraints { make in
                make.bottom.left.right.equalTo(view).inset(10)
                make.top.equalTo(view).inset(60)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
