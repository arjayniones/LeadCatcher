//
//  SummaryViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 02/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

class SummaryViewController: ViewControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //let summaryCell = SummaryCollectionViewCell()
    var collectionview: UICollectionView!
    var cellId = "Cell"
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = UILayoutConstraintAxis.vertical
        sv.alignment = UIStackViewAlignment.center
        sv.distribution = UIStackViewDistribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
   
    var barChart = SummaryBarChart()

    
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateDataEntries()
       
        barChart.dataEntries = dataEntries
    }
    
    func generateDataEntries() -> [SummaryBarEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), .brown, #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [SummaryBarEntry] = []
        for i in 0..<20 {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            result.append(SummaryBarEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: formatter.string(from: date)))
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Summary"
        view.backgroundColor = UIColor.gray
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: (view.frame.width - 40)  / 3 , height: 110)
        
        collectionview = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(SummaryCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        //collectionview.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/3)
        
        barChart.backgroundColor = UIColor.white
        //barChart.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/3)
        self.view.addSubview(collectionview)
        self.view.addSubview(barChart)
        
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(collectionview)
        stackView.addArrangedSubview(barChart)
        
        
       
        
    }
    
  
    
    override func updateViewConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(view).inset(50)
        }
        
        collectionview.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.width, height: view.height/2))
            
            
        }
        
            barChart.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: view.width, height: view.height/3))
             
            }
   
        super.updateViewConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return myCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print("User tapped on item \(indexPath.row)")
    }

}
