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
    
    // Goal data passed in by segue
    var goalData: Goal?
    var selectedStartDate = ""
    var selectedEndDate = ""
    var reminderOption : String = "Minutes"
    var firstMilestone = false
    var goalMilestones : [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // connect reminderOptions to UIPicker
        reminderPicker.dataSource = self
        reminderPicker.delegate = self
        selectedStartDate = formatInitDate(date: startDatePicker.date)
        selectedEndDate = formatInitDate(date: startDatePicker.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func formatInitDate(date : Date) -> String {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateStyle = DateFormatter.Style.short
        return startDateFormatter.string( from: date)
    }
    
    @IBAction func StartDatePickerChanged(_ sender: Any) {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateStyle = DateFormatter.Style.short
        selectedStartDate = startDateFormatter.string( from: startDatePicker.date)
    }
    
    @IBAction func EndDatePickerChanged(_ sender: Any) {
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateStyle = DateFormatter.Style.short
        selectedEndDate = endDateFormatter.string( from: endDatePicker.date)
    }
    
    func userInteractionEnabled(value : Bool){
        milestoneNameField.isEnabled = value
        startDatePicker.isEnabled = value
        endDatePicker.isEnabled = value
        remindTimeField.isEnabled = value
    }
    
    func updateGoalsMilestone(milestoneKey: String){
        let goalID = goalData?.key
        let goalDB = Database.database().reference().child("Goals").child(goalID!)
        
        if self.firstMilestone {
            self.goalMilestones = [
                milestoneKey : true
            ]
        }
        else {
            self.goalMilestones[milestoneKey] = true
        }
        
        goalDB.child("milestones").setValue(self.goalMilestones)
        self.userInteractionEnabled(value: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addMilestone(goalID: String, milestoneID: String){
        let key = goalID + ":" + milestoneID
        let milestoneDB = Database.database().reference().child("Milestones")
        
        let milestoneData = [
            "name" : milestoneNameField.text!,
            "startDate" : selectedStartDate,
            "endDate" : selectedEndDate,
            "reminderValue" : remindTimeField.text!,
            "reminderLength" : reminderOption
        ]
        
        milestoneDB.child(key).setValue(milestoneData) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                self.updateGoalsMilestone(milestoneKey: reference.key!)
            }
        }
    }
    
    func createMilestoneID(){
        let goalID = goalData?.key
        let goalsDB =
            Database.database().reference().child("Goals").child(goalID!)
        
        goalsDB.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get users Data
            let snapshotValue = snapshot.value as! NSDictionary
            
            // Check if this is first milestone
            var milestoneID = -1
            if snapshotValue["milestones"] is Bool{
                self.firstMilestone = true
                milestoneID = 1
                self.addMilestone(goalID: goalID!, milestoneID: String(milestoneID))
            }
            else{
                self.goalMilestones = (snapshotValue["milestones"] as! NSDictionary) as! [String : Any]
                milestoneID = (snapshotValue["milestones"] as! NSDictionary).count + 1
                self.addMilestone(goalID: goalID!, milestoneID: String(milestoneID))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func createButton(_ sender: Any) {
        userInteractionEnabled(value: false)
        createMilestoneID()
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
