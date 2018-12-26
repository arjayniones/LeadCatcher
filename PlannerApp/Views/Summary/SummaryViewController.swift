//
//  SummaryViewController.swift
//  PlannerApp
//
//  Created by Niones Arjay Orcullo on 02/10/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class SummaryViewController: ViewControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate,ChartViewDelegate, LargeNativeNavbar {
    
    var resultContactList:Results<ContactModel>!;
    let realmStoreContact = RealmStore<ContactModel>()
    let realmStoreAddNote = RealmStore<AddNote>()
    let summaryCell = SummaryCollectionViewCell()
    var collectionview: UICollectionView!
    var cellId = "Cell"
    fileprivate let viewModel = SummaryViewModel()
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
   
    var barChart = SummaryBarChart()
    var chartView = BarChartView()

    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        
        return formatter
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateDataEntries()
       
        barChart.dataEntries = dataEntries
    }
    
    
    func generateDataEntries() -> [SummaryBarEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), .brown, #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [SummaryBarEntry] = []
        //var meetingCount = viewModel.todoList?.count
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
        view.backgroundColor = .clear
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: (view.frame.width - 40)  / 3 , height: 105)
        layout.headerReferenceSize = CGSize(width: 100, height: 15)
        
        collectionview = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(SummaryCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionview.register(HeaderViewClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderViewClass")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        
        //collectionview.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/3)
        
        // azlim : temp btn to generate excel file
//        let exportBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportCustomerData));
//        navigationItem.rightBarButtonItem = exportBtn;
        
        //barChart.backgroundColor = .clear
        //barChart.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height/3)
        self.view.addSubview(collectionview)
        //self.view.addSubview(barChart)
        
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(collectionview)
        
        //stackView.addArrangedSubview(barChart)
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        chartView.backgroundColor = .white
        chartView.maxVisibleCount = 40
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.highlightFullBarEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = self;
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 4
        l.xEntrySpace = 6
        stackView.addArrangedSubview(chartView)
        filteringOutContactTypeByDate()
       
        setChartData(count: 12, flag:"Lead")
    }
    
    func setChartData(count: Int, flag:String) {
        // count = x value
        // mult = customer count
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            var val1 = 0.00
            var val2 = 0.00
            var val3 = 0.00
            if flag == "Lead"
            {
                if let fetchData = realmStoreContact.models(query: "deleted_at == nil") {
                    fetchData.forEach{ (data) in
                        //print(data);
                        if(data.updated_at!.isContain(this: i+1, filterElement: .month))
                        {
                            print(data.C_Status)
                            switch data.C_Status{
                                
                            case "Customer":
                                val1 += 1
                            case "Potential":
                                val2 += 1
                            case "Others":
                                val3 += 1
                            default:
                                val1 += 0;
                                val2 += 0;
                                val3 += 0;
                            }
                            
                        }
                    }
                }
            }
            else
            {
                if let fetchData = realmStoreAddNote.models(query: "deleted_at == nil")
                {
                    fetchData.forEach({ (AddNote) in
                        if(AddNote.updated_at!.isContain(this: i+1, filterElement: .month))
                        {
                            switch AddNote.status{
                            case "Completed":
                                val1 += 1;
                            case "Follow Up":
                                val2 += 1;
                            case "Discontinue":
                                val3 += 1;
                            default:
                                val1 += 0;
                                val2 += 0;
                                val3 += 0;
                            }
                        }
                        
                        
                    })
                }
            }
            
            return BarChartDataEntry(x: Double(i), yValues: [val1, val2, val3], icon: #imageLiteral(resourceName: "whatsapp-icon"))
        }
        
        let set = BarChartDataSet(values: yVals, label: "")
        set.drawIconsEnabled = false
        
        //let collectionCellColor = [#colorLiteral(red: 0.4078431373, green: 0.4274509804, blue: 0.8784313725, alpha: 1),#colorLiteral(red: 0, green: 0.8235294118, blue: 0.8274509804, alpha: 1),#colorLiteral(red: 1, green: 0.1529411765, blue: 0.1529411765, alpha: 1)];
        
        //set.colors = [ChartColorTemplates.material()[0], ChartColorTemplates.material()[1], ChartColorTemplates.material()[2]]
        set.colors = [#colorLiteral(red: 0.4078431373, green: 0.4274509804, blue: 0.8784313725, alpha: 1),#colorLiteral(red: 0, green: 0.8235294118, blue: 0.8274509804, alpha: 1),#colorLiteral(red: 1, green: 0.1529411765, blue: 0.1529411765, alpha: 1)]
        if flag == "Lead"{
            set.stackLabels = ["Customer", "Potential", "Others"]
        }
        else if flag == "AddNote"
        {
            set.stackLabels = ["Appointment", "Birthday", "Other"]
        }
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueTextColor(.clear)
        
        chartView.fitBars = true
        chartView.data = data
    }
    
    override func updateViewConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).inset(50)
        }
        
        collectionview.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.frame.width, height: view.frame.height/2))
            
            
        }
        
        chartView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: view.frame.width, height: view.frame.height/3))
        }
        
//            barChart.snp.makeConstraints { make in
//                make.size.equalTo(CGSize(width: view.frame.width, height: view.frame.height/3))
//
//            }
   
        super.updateViewConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       updateNavbarAppear()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionview
        {
            return viewModel.detailRows.count
        }
        else
        {
            return viewModel.activitiesDetailRows.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "HeaderViewClass",
                                                                             for: indexPath) as! HeaderViewClass
            let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20));
            label1.textAlignment = .center
            label1.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            if indexPath.section == 0
            {
                label1.text = "Customer"
            }
            else
            {
                label1.text = "Activities"
            }
            
            headerView.addSubview(label1)
            return headerView
            
        default:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "HeaderViewClass",
                                                                             for: indexPath) as! HeaderViewClass
            return headerView
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SummaryCollectionViewCell
        var name:String = "";
        var number:Int = 0;
        if indexPath.section == 0
        {
            name = viewModel.detailRows[indexPath.row].nameLbl
            number = viewModel.detailRows[indexPath.row].valueLbl
        }else
        {
            name = viewModel.activitiesDetailRows[indexPath.row].nameLbl
            number = viewModel.activitiesDetailRows[indexPath.row].valueLbl
        }
        
        //let data = viewModel.detailRows[indexPath.row]
        
        let collectionCellColor = [#colorLiteral(red: 0.4078431373, green: 0.4274509804, blue: 0.8784313725, alpha: 1),#colorLiteral(red: 0, green: 0.8235294118, blue: 0.8274509804, alpha: 1),#colorLiteral(red: 1, green: 0.1529411765, blue: 0.1529411765, alpha: 1)];
        
        if indexPath.row == 0 || indexPath.row == 3
        {
            myCell.outerView.backgroundColor = collectionCellColor[0];
            //myCell.backgroundView?.backgroundColor = collectionCellColor[0];
        }
        else if indexPath.row == 1 || indexPath.row == 4
        {
            myCell.outerView.backgroundColor = collectionCellColor[1];
        }
        else if indexPath.row == 2 || indexPath.row == 5
        {
            myCell.outerView.backgroundColor = collectionCellColor[2];
        }
        
        myCell.textLabel.text = name == "" ? "No Label":  name
        
        myCell.numberLabel.text = number == 0 ? "0": "\(number)"
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
        if indexPath.section == 0
        {
            setChartData(count: 12, flag: "Lead")
        }
        else
        {
            setChartData(count: 12, flag: "AddNote")
        }
    }
    
    @objc func exportCustomerData()
    {
        let viewModel = SummaryViewModel()
        viewModel.exportContactData(); // used to export contact info
        viewModel.exportToDoData(); // used to export to do data
    }
    
    func filteringOutContactTypeByDate()
    {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        for i in 1...12 {
            //let dateFromTo = viewModel.generateDateForFilter(mth: i, yrs: year)
            
            
            
        }
    }
    
    
}

extension SummaryViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value) % months.count]
    }
}
