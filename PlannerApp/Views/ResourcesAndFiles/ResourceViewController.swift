//
//  ResourceViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 23/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import MobileCoreServices

class ResourceViewController: ViewControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate,LargeNativeNavbar  {

    var collectionview: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Resources"
        view.addBackground()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: (view.frame.width - 40)  / 3 , height: 110)
        
        collectionview = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        self.view.addSubview(collectionview)
        
        let importButton = UIButton()
        let image = UIImage(named: "plus-grey-icon" )
        importButton.setImage(image, for: .normal)
        importButton.addTarget(self, action: #selector(importButtonPressed), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: importButton)
        
    }
    
    func savePDF() {
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            collectionview.snp.makeConstraints { make in
                make.top.equalTo(view.safeArea.top)
                make.left.right.equalTo(view)
                make.bottom.equalTo(view).inset(50)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    @objc func importButtonPressed() {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeVideo),String(kUTTypeSpreadsheet)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}

extension ResourceViewController:UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        print("import result : \(myURL)")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
