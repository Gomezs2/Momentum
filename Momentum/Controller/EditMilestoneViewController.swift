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
    var reminderOption = ""
    var selectedStartDate = ""
    var selectedEndDate = ""
    var milestoneData: Milestone?

    override func viewDidLoad() {
        super.viewDidLoad()
        // connect reminderOptions to UIPicker
        reminderPicker.dataSource = self
        reminderPicker.delegate = self
    }
    
    @IBAction func startDateChanges(_ sender: UIDatePicker) {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateStyle = DateFormatter.Style.short
        selectedStartDate = startDateFormatter.string( from: startDatePicker.date)
    }
    
    @IBAction func endDateChanges(_ sender: UIDatePicker) {
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateStyle = DateFormatter.Style.short
        selectedEndDate = endDateFormatter.string( from: endDatePicker.date)
    }
    
    func updateName() -> String{
        if milestoneName.text!.count != 0 && milestoneName.text! != milestoneData!.name {
            return milestoneName.text!
        }
        return milestoneData!.name
    }
    
    func updateStartDate() -> String{
        if selectedStartDate != "" && selectedStartDate != milestoneData!.startDate {
            return selectedStartDate
        }
        return milestoneData!.startDate
    }
    
    func updateEndDate() -> String{
        if selectedEndDate != "" && selectedEndDate != milestoneData!.endDate {
            return selectedEndDate
        }
        return milestoneData!.endDate
    }
    
    func updateReminderValue() -> String{
        if reminderTime.text!.count != 0 && reminderTime.text! != milestoneData!.endDate {
            return reminderTime.text!
        }
        return milestoneData!.reminderValue
    }
    
    func updateReminderLength() -> String{
        if reminderOption != "" && reminderOption != milestoneData!.endDate {
            return reminderOption
        }
        return milestoneData!.reminderLength
    }
    
    func updateMilestone() {
        let milestoneDB = Database.database().reference().child("Milestones")
        let updatedData = [
            "name" : updateName(),
            "startDate" : updateStartDate(),
            "endDate" : updateEndDate(),
            "reminderValue" : updateReminderValue(),
            "reminderLength" : updateReminderLength(),
            "completed" : milestoneData!.completed // should be false
        ]
        
        let childUpdates = ["\(milestoneData!.key)" : updatedData]
        milestoneDB.updateChildValues(childUpdates)
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteMilestone() {
        let milestoneToDel = Database.database().reference().child("Milestones").child("\(milestoneData!.key)")
        milestoneToDel.removeValue()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        updateMilestone()
    }
    
    func completeMilestone() {
        let milestoneDB = Database.database().reference().child("Milestones")
        let updatedData = [
            "name" : updateName(),
            "startDate" : updateStartDate(),
            "endDate" : updateEndDate(),
            "reminderValue" : updateReminderValue(),
            "reminderLength" : updateReminderLength(),
            "completed" : "true"
        ]
        
        let childUpdates = ["\(milestoneData!.key)" : updatedData]
        milestoneDB.updateChildValues(childUpdates)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completePressed(_ sender: Any) {
        completeMilestone()
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
