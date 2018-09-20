//
//  DateAndTimePickerViewController.swift
//  PlannerApp
//
//  Created by Alkuino Robert John Matias on 19/09/2018.
//  Copyright © 2018 SICMSB. All rights reserved.
//

import UIKit

protocol DateAndTimePickerViewControllerDelegate {
    var selectedDate:Date { get set }
    func pickerControllerDidExit()
}

class DateAndTimePickerViewController: ViewControllerProtocol {

    let datePicker = UIDatePicker()
    
    let dateTimeLabel = UILabel()
    
    let doneButton = ActionButton()
    let cancelButton = ActionButton()
    
    var delegate: DateAndTimePickerViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        view.addSubview(datePicker)
        
        dateTimeLabel.text = convertDateTimeToString(date:datePicker.date)
        view.addSubview(dateTimeLabel)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .clear
        doneButton.setTitleColor(.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        view.addSubview(doneButton)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.setTitleColor(.blue, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        view.updateConstraintsIfNeeded()
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        dateTimeLabel.text = convertDateTimeToString(date:sender.date)
        
        delegate?.selectedDate = sender.date
    }
    
    @objc func datePickerPressed() {
        datePicker.datePickerMode = .dateAndTime
    }
    
    @objc func doneButtonPressed() {
        
        delegate?.selectedDate = datePicker.date
        delegate?.pickerControllerDidExit()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonPressed() {
        delegate?.pickerControllerDidExit()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func updateViewConstraints() {
        
        dateTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
            make.height.equalTo(40)
            make.centerY.equalTo(view.snp.centerY).offset(-100)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(20)
            make.right.equalTo(view).inset(10)
            make.width.equalTo(CGSize(width: 100, height: 40))
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(20)
            make.left.equalTo(view).inset(10)
            make.size.equalTo(CGSize(width: 100, height: 40))
        }
        
        datePicker.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(200)
        }
        
        super.updateViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

