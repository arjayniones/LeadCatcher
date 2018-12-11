//
//  ResourceViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 23/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import MobileCoreServices
import RealmSwift

class ResourceViewController: ViewControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate,LargeNativeNavbar  {

    fileprivate var collectionview: UICollectionView!
    let viewModel = ResourcesAndFilesModel()
    fileprivate var isRemoveButtonEnabled:Bool = false
    
    fileprivate let trashButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Resources"
        view.backgroundColor = .clear
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: (view.frame.width - 40)  / 3 , height: ((view.frame.width - 40)/3)+20)
        
        collectionview = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(FileCell.self, forCellWithReuseIdentifier: "cell")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        self.view.addSubview(collectionview)
        
        let importButton = UIButton()
        importButton.frame = CGRect(x:0, y:0, width:30, height:30)
        let image = UIImage(named: "plus-grey-icon" )
        importButton.setBackgroundImage(image, for: .normal)
        importButton.addTarget(self, action: #selector(importButtonPressed), for: .touchUpInside)
        let rightAddBarButton = UIBarButtonItem(customView: importButton)
        
        trashButton.frame = CGRect(x:0, y:0, width:30, height:30)
        trashButton.setBackgroundImage(UIImage(named: "trash-icon" ), for: .normal)
        trashButton.setBackgroundImage(UIImage(named: "okay-icon" ), for: .selected)
        trashButton.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
        let rightTrashBarButton = UIBarButtonItem(customView: trashButton)
        
        navigationItem.rightBarButtonItems = [rightTrashBarButton,rightAddBarButton]
        
        viewModel.notificationToken = viewModel.files?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionview else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, _, _, _):
                collectionView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    @objc func removeButtonPressed() {
        
        self.trashButton.isSelected = !self.isRemoveButtonEnabled
        self.isRemoveButtonEnabled = !self.isRemoveButtonEnabled
        
        self.collectionview.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavbarAppear()
    }
    
    func removeCheck(data:UserFiles) {
        let filePath = getFilePathString(filename: data.filename + "." + "\(data.fileType)")
        
        let fileData = FileData()
        fileData.url = URL(fileURLWithPath: filePath)
        
        let alert = UIAlertController(title: "", message: "Remove this file?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style:.default, handler: { _ in
            removeFile(fileData: fileData, completion: { val in
                if val {
                    DispatchQueue.main.async {
                        self.viewModel.realmStore.delete(modelToDelete: data, hard: true)
                    }
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style:.cancel, handler:nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            collectionview.snp.makeConstraints { make in
                make.top.equalTo(view.safeArea.top).inset(10)
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
        return viewModel.files?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = viewModel.files![indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FileCell
        
        cell.nameLabel.text = data.filename
        cell.removeButton.isHidden = !isRemoveButtonEnabled
        
        if data.fileType.lowercased() == "pdf" {
            cell.fileImage.image = UIImage(named:"file-pdf-icon")
        } else if (["xlsx","xls","xlsm"].filter{ $0 == data.fileType.lowercased()}.count) > 0 {
            cell.fileImage.image = UIImage(named:"file-excel-icon")
        } else {
            cell.fileImage.image = UIImage(named:"file-unknown-icon")
        }
        
        cell.removeCallback = {
            self.removeCheck(data: data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.files![indexPath.row]
        
        let filePath = getFilePathString(filename: data.filename + "." + "\(data.fileType)")
        
        showFileWithPath(path: filePath)
    }
}

extension ResourceViewController:UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        print("import result : \(url)")
        
        let fileData = FileData()
        fileData.url = url
        
        let userFiles = UserFiles().newInstance()
        userFiles.fileType = url.pathExtension
        
        
        let alert = UIAlertController(title: "Adding File", message: "Enter your desired filename", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Insert filename"
            textField.keyboardType = .default
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let text = textField?.text,text != "" {
                print("Text field: \(text)")
                fileData.filename = text+"."+url.pathExtension
                userFiles.filename = text
            } else {
                userFiles.filename = userFiles.id
                fileData.filename = userFiles.id+"."+url.pathExtension
            }
            
            self.viewModel.saveFile(userFiles: userFiles, dataFile: fileData)
            
        }))
        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in
//        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController,
                             didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func alert(message:String) {
        let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style:.cancel, handler: nil));
        present(alert, animated: true, completion: nil)
    }
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        } else {
            self.alert(message: "Can't open the file.")
        }
    }
}

extension ResourceViewController:UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        
        return self
    }
}

class FileCell: UICollectionViewCell {
    
    fileprivate let nameLabel = UILabel()
    let fileImage = UIImageView()
    
    var personName:String = "" {
        didSet {
            nameLabel.text = personName
        }
    }
    
    fileprivate var didSetupConstraints:Bool = false
    
    let removeButton = UIButton()
    
    var removeCallback:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fileImage.contentMode = .scaleToFill
        fileImage.isUserInteractionEnabled = true
        contentView.addSubview(fileImage)
        
        nameLabel.font = UIFont.ofSize(fontSize: 15, withType: .regular)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        
        removeButton.setBackgroundImage(UIImage(named:"remove-icon"), for: .normal)
        removeButton.isHidden = true
        removeButton.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
        fileImage.addSubview(removeButton)
        
        updateConstraintsIfNeeded()
        needsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func removeButtonPressed() {
        if let callback = removeCallback {
            callback()
        }
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            fileImage.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
            }
            
            removeButton.snp.makeConstraints { make in
                make.bottom.right.equalToSuperview().inset(2)
                make.size.equalTo(CGSize(width: 30, height: 30))
            }
            
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(fileImage.snp.bottom).offset(5)
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(20)
            }
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}

