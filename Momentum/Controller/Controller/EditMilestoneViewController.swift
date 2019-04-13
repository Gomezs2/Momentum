//
//  EditMilestoneViewController.swift
//  Momentum
//
//  Created by Linnea Cajuste on 2019-04-03.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class EditMilestoneViewController: UIViewController {

    @IBOutlet weak var milestoneName: UITextField!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!

    @IBOutlet weak var reminderTime: UITextField!
    
    @IBOutlet weak var reminderPicker: UIPickerView!
    
    private let reminderOptions:[String] = ["Minutes", "Hours", "Days"]
    var reminderOption:String?
    var selectedStartDate = ""
    var selectedEndDate = ""
    
    @IBAction func startDateChanges(_ sender: UIDatePicker) {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateStyle = DateFormatter.Style.short
        selectedStartDate = startDateFormatter.string( from: startDatePicker.date) ///strStartDate string stores the goal start date in MM/DD/YY
        print("start date ", selectedStartDate)
    }
    
    @IBAction func endDateChanges(_ sender: UIDatePicker) {
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateStyle = DateFormatter.Style.short
        selectedEndDate = endDateFormatter.string( from: endDatePicker.date) ///strStartDate string stores the goal start date in MM/DD/YY
        print("end date ", selectedEndDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // connect reminderOptions to UIPicker
        reminderPicker.dataSource = self
        reminderPicker.delegate = self
    }
}

extension EditMilestoneViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    // Number of components/columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderOptions.count
    }
    // updates UIPicker if user scrolls to a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reminderOption = reminderOptions[row]
    }
    
    // The data to return  the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reminderOptions[row]
        
    }
    
}
