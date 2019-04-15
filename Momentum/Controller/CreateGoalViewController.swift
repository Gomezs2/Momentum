//
//  CreateGoalViewController.swift
//  Momentum
//
//  Created by Sergio Gomez on 3/23/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class CreateGoalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var repetition: UIPickerView!
    @IBOutlet var category: UIPickerView!
    @IBOutlet weak var goalName: UITextField!
    @IBOutlet weak var goalStartDate: UIDatePicker!
    @IBOutlet weak var goalEndDate: UIDatePicker!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet var weekdayButtons: [UIButton]!
    
    var categoryOptions = ["General", "Efficency", "Fitness", "Health", "Hobbies", "Social","Skills" ]
    var repetitionOptions = ["Never", "Daily", "Weekly", "Monthly", "Yearly"]
    
    var daysSelected = "" //String that stores weekdays to repeat goal. Format: S|M|T|W|
    var firstGoal = false
    var userGoals : [String : Any] = [:]
    var selectedCategory = "Default"
    var selectedRepetition = "Never"
    var selectedStartDate = ""
    var selectedEndDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedStartDate = formatInitDate(date: goalStartDate.date)
        selectedEndDate = formatInitDate(date: goalStartDate.date)
    }
    
    func formatInitDate(date : Date) -> String {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateStyle = DateFormatter.Style.short
        return startDateFormatter.string( from: date)
    }
    
    @IBAction func startDateChanged(_ sender: Any) {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateStyle = DateFormatter.Style.short
        selectedStartDate = startDateFormatter.string( from: goalStartDate.date) ///strStartDate string stores the goal start date in MM/DD/YY
    }
    
    @IBAction func endDateChanged(_ sender: Any) {
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateStyle = DateFormatter.Style.short
        selectedEndDate = endDateFormatter.string( from: goalEndDate.date) ///strStartDate string stores the goal start date in MM/DD/YY
    }
    
    
    //Set up categories and repeat picker views
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (pickerView.tag == 1){
            return categoryOptions.count
        }
        else{
            return repetitionOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView.tag == 1){
            return categoryOptions[row]
        }
        else{
            return repetitionOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (pickerView.tag == 1){
            selectedCategory = categoryOptions[row]
        }
        else{
            selectedRepetition = repetitionOptions[row]
            if selectedRepetition == "Weekly"{
                for button in weekdayButtons{
                    button.isEnabled = true
                }
            }else{
                daysSelected = ""
                for button in weekdayButtons{
                    button.isEnabled = false
                    if button.tag == 0 || button.tag == 2 || button.tag == 4 || button.tag == 6{
                        button.backgroundColor = UIColor.blue
                    }else{
                        button.backgroundColor = UIColor.clear
                    }
                }
            }
        }
    }
    
    @IBAction func weekdayButtonPressed(_ sender: UIButton) {
        for button in weekdayButtons{
            if sender == button && button.backgroundColor !=  UIColor.gray{
                button.backgroundColor = UIColor.gray
                if sender.tag == 0{
                    daysSelected += "S|"
                }else if sender.tag == 1{
                    daysSelected += "M|"
                }else if sender.tag == 2{
                    daysSelected += "T|"
                }else if sender.tag == 3{
                    daysSelected += "W|"
                }else if sender.tag == 4{
                    daysSelected += "R|"
                }else if sender.tag == 5{
                    daysSelected += "F|"
                }else if sender.tag == 6{
                    //using X for sunday to differentiate from S
                    daysSelected += "X|"
                }
                
            } else if sender == button && button.backgroundColor ==  UIColor.gray{
                if sender.tag == 0 || sender.tag == 2 || sender.tag == 4 || sender.tag == 6{
                    button.backgroundColor = UIColor.blue
                }else{
                    button.backgroundColor = UIColor.clear
                }
                if sender.tag == 0{
                    deleteDays(day : "S|")
                }else if sender.tag == 1{
                    deleteDays(day : "M|")
                }else if sender.tag == 2{
                    deleteDays(day : "T|")
                }else if sender.tag == 3{
                    deleteDays(day : "W|")
                }else if sender.tag == 4{
                    deleteDays(day : "R|")
                }else if sender.tag == 5{
                    deleteDays(day : "F|")
                }else if sender.tag == 6{
                    deleteDays(day : "X|")
                }
            }
        }
    }
    
    //Deletes days from the selected weekday string
    func deleteDays(day : String){
        var present = false
        for i in daysSelected{
            let b = String(i)+"|"
            if b == day{
                daysSelected = daysSelected.replacingOccurrences(of: b, with: "", options: NSString.CompareOptions.literal, range: nil)
                present = true
            }
        }
        if present == false{
            daysSelected += day
        }
    }
    
    func userInteractionEnabled(value : Bool){
        doneButton.isEnabled = value
        goalName.isEnabled = value
        category.isUserInteractionEnabled = value
        goalStartDate.isUserInteractionEnabled = value
        goalEndDate.isUserInteractionEnabled = value
        repetition.isUserInteractionEnabled = value
    }
    
    func updateUsersGoal(goalKey: String){
        let userID = Auth.auth().currentUser?.uid
        let userDB =  Database.database().reference().child("Users").child(userID!)
        
        if self.firstGoal {
            self.userGoals = [
                goalKey : true
            ]
        }
        else {
            self.userGoals[goalKey] = true
        }
        
        userDB.child("goals").setValue(self.userGoals)
        self.userInteractionEnabled(value: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addGoal(userID: String, goalID: String){
        let key = userID + ":" + goalID
        let goalsDB = Database.database().reference().child("Goals")
        
        let goalData : [String : Any] = [
            "name" : goalName.text!,
            "category" : selectedCategory,
            "startDate" : selectedStartDate,
            "endDate" : selectedEndDate,
            "goalRepeatOption" : selectedRepetition,
            "milestones" : false
            ]
        
        goalsDB.child(key).setValue(goalData) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                self.updateUsersGoal(goalKey: reference.key!)
            }
        }
    }
    
    func createGoalID(){
        let userID = Auth.auth().currentUser?.uid
        let userDB =  Database.database().reference().child("Users").child(userID!)
        
        userDB.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get users Data
            let snapshotValue = snapshot.value as! NSDictionary

            // Check if this is first goal
            var goalID = -1
            if snapshotValue["goals"] is Bool{
                self.firstGoal = true
                goalID = 1
                self.addGoal(userID: userID!, goalID: String(goalID))
            }
            else{
                self.userGoals = (snapshotValue["goals"] as! NSDictionary) as! [String : Any]
                goalID = (snapshotValue["goals"] as! NSDictionary).count + 1
                self.addGoal(userID: userID!, goalID: String(goalID))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        // Disable fields to that we dont duplicate send
        userInteractionEnabled(value: false)
        // Create unique goal id, add to goal table and user's goal setting
        createGoalID()
    }
}
