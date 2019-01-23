//
//  HelpViewController.swift
//  PlannerApp
//
//  Created by Lim Ai Zhi on 16/01/2019.
//  Copyright © 2019 SICMSB. All rights reserved.
//

import UIKit

class HelpViewController:ViewControllerProtocol {
    let backgroundImageView = UIImageView()
    var closeImage = UIImageView()
    //let closeBtn = UIButton()
    let uiview = UIView()
    var imageName:String = ""
    let naviBarLeftButton = UIButton()
    let titleLabel = UILabel()
    let infoImage = UIImageView()
    
    override func viewDidLoad() {
        self.view.backgroundColor  = .white
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear

            let blurEffect = UIBlurEffect(style: .prominent)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            view.backgroundColor = .white
        }
        
        infoImage.image = UIImage(named: "svgInfo")
        titleLabel.text = "Help info"
        titleLabel.textColor = CommonColor.darkGrayColor
        
        uiview.addSubview(infoImage)
        uiview.addSubview(titleLabel)
        
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = .scaleAspectFit
        //view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        //closeImage = UIImage(named: "svgClose")!
        closeImage.image = UIImage(named: "svgClose")
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissThisView))
        closeImage.isUserInteractionEnabled = true
        closeImage.addGestureRecognizer(closeTapGesture);
        
        //closeBtn.setBackgroundImage(closeImage, for: .normal)
        
        //closeBtn.addTarget(self, action: #selector(dismissThisView), for: .touchUpInside)
        
        //backgroundImageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scaleImage(_:))))
        //view.addSubview(backgroundImageView)
        uiview.addSubview(closeImage)
        uiview.layer.cornerRadius = 10
        //uiview.layer.borderWidth = 0.2
        uiview.layer.shadowRadius = 10
        uiview.layer.shadowOpacity = 0.2
        uiview.backgroundColor = UIColor.white
        uiview.addSubview(backgroundImageView)
        self.view.addSubview(uiview)
        /*
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        let scrollImg: UIScrollView = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0
        
        self.view.addSubview(scrollImg)
        backgroundImageView.clipsToBounds = false
        scrollImg.addSubview(backgroundImageView)
            */
        
//        naviBarLeftButton.setTitle("Close", for: .normal)
//        naviBarLeftButton.contentHorizontalAlignment = .left
//        naviBarLeftButton.backgroundColor = .clear
//        naviBarLeftButton.setTitleColor(CommonColor.systemBlueColor, for: .normal)
//        naviBarLeftButton.addTarget(self, action: #selector(dismissThisView), for: .touchUpInside)
//        self.view.addSubview(naviBarLeftButton)
        
        
        
        view.needsUpdateConstraints()
        view.updateConstraintsIfNeeded()
    }
    
    @objc func dismissThisView()
    {
        self.dismiss(animated: false, completion: nil);
    }
    
//    @objc func scaleImage(_ sender: UIPinchGestureRecognizer) {
//        backgroundImageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
//    }
//
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return self.backgroundImageView
//    }
//
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.backgroundImageView
//    }
    
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
//            naviBarLeftButton.snp.makeConstraints { (make) in
//                make.left.equalTo(view).inset(10);
//                make.top.equalTo(30)
//                make.height.equalTo(50);
//                make.width.equalTo(100);
//            }
            
            uiview.snp.makeConstraints { (make) in
                make.top.equalTo(view).inset(60)
                make.left.right.equalTo(view).inset(15)
                make.height.equalTo(view.snp.height).multipliedBy(0.4)
            }
            
            infoImage.snp.makeConstraints { (make) in
                make.left.equalTo(uiview).inset(10)
                make.top.equalTo(uiview).inset(10)
                make.height.width.equalTo(30)
            }
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(uiview).inset(15)
                make.left.equalTo(infoImage.snp.right).offset(10)
                make.height.equalTo(21)
                make.width.equalTo(100)
            }
            
            closeImage.snp.makeConstraints { (make) in
                make.top.equalTo(uiview).inset(10)
                make.right.equalTo(uiview).inset(10)
                make.height.width.equalTo(30)
            }
            
            if imageName == "help3"
            {
                backgroundImageView.snp.makeConstraints { (make) in
                    make.top.equalTo(closeImage.snp.bottom).inset(10)
                    make.left.right.equalTo(uiview).inset(5)
                    make.height.equalTo(216)
                    make.bottom.equalTo(uiview).inset(10)
                }
            }
            else
            {
                backgroundImageView.snp.makeConstraints { (make) in
                    make.top.equalTo(closeImage.snp.bottom).inset(10)
                    make.left.right.equalTo(uiview).inset(5)
                    make.height.equalTo(110)
                    make.bottom.equalTo(uiview).inset(10)
                }
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}
