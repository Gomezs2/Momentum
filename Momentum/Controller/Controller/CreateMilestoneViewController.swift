//
//  CreateMilestone.swift
//  Momentum
//
//  Created by Paul Lim on 4/1/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class CreateMilestoneViewController: UIViewController {
    
    @IBOutlet weak var milestoneNameField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var remindTimeField: UITextField!
    @IBOutlet weak var reminderPicker: UIPickerView!
    private let reminderOptions:[String] = ["Minutes", "Hours", "Days"]
    var reminderOption:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // connect reminderOptions to UIPicker
        reminderPicker.dataSource = self
        reminderPicker.delegate = self
    }
    
    @IBAction func createButton(_ sender: Any) {
        // current reminder option selected by user is stored in reminderOptions automatically
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// pickerView for milestone reminder
extension CreateMilestoneViewController : UIPickerViewDelegate, UIPickerViewDataSource {
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
