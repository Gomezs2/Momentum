//
//  EditGoalViewController.swift
//  Momentum
//
//  Created by Linnea Cajuste on 2019-03-24.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class EditGoalViewController:
    UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet var goalName: UITextField! //TO DO set goal name to the user's previous goal name
    @IBOutlet var categories: UIPickerView!
    @IBOutlet var repetitions: UIPickerView!
    @IBOutlet var weekdayButtons: [UIButton]!
    @IBOutlet var endDate: UIDatePicker!
    @IBOutlet var startDate: UIDatePicker!
    
    var categoryOptions = ["General", "Efficency", "Fitness", "Health", "Hobbies", "Social","Skills" ]
    var repetitionOptions = ["Never", "Daily", "Weekly", "Monthly", "Yearly"]
    
    var goalData: Goal?
    var daysSelected = "" //String that stores weekdays to repeat goal. Format: S|M|T|W|
    var selectedStartDate = ""
    var selectedEndDate = ""
    //TO DO: change these variables to the user's previous choice
    var selectedCategory = "Default"
    var selectedRepetition = "Never"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startDateChanges(_ sender: Any) {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateStyle = DateFormatter.Style.short
        selectedStartDate = startDateFormatter.string( from: startDate.date) ///strStartDate string stores the goal start date in MM/DD/YY
        print(selectedStartDate)
    }
    
    @IBAction func endDateChanges(_ sender: Any) {
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateStyle = DateFormatter.Style.short
        selectedEndDate = endDateFormatter.string( from: endDate.date) ///strEndDate string stores the goal start date in MM/DD/YY
        print(selectedEndDate)
    }
    
    //handle categories and repeat picker views
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
            print(selectedCategory)
        }
        else{
            selectedRepetition = repetitionOptions[row]
            print(selectedRepetition)
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
    
    //handle weekday buttons at the bottom of the screen
    @IBAction func weekdayButtonPressed(_ sender: UIButton) {
        
        //adding days to daysSelected string
        //changing button colors based on state
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
                    daysSelected += "X|" //using X for sunday to differentiate from S
                }
                
            } else if sender == button && button.backgroundColor ==  UIColor.gray{
                //TO DO add method to delete weekday from string
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
                    deleteDays(day : "X|")//using X for sunday to differentiate from S
                }
            }
        }
        print(daysSelected)
    }
    
    //deletes days from the selected weekday string
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
    
    func updateName() -> String{
        if goalName.text!.count != 0 && goalName.text! != goalData!.name {
            return goalName.text!
        }
        return goalData!.name
    }
    
    func updateCategory() -> String{
        if selectedCategory != "Default" && selectedCategory != goalData!.category {
            return selectedCategory
        }
        return goalData!.category
    }
    
    func updateStartDate() -> String{
        if selectedStartDate != "" && selectedStartDate != goalData!.startDate {
            return selectedStartDate
        }
        return goalData!.startDate
    }
    
    func updateEndDate() -> String{
        if selectedEndDate != "" && selectedEndDate != goalData!.endDate {
            return selectedEndDate
        }
        return goalData!.endDate
    }
    
    func updateRepeatOption() -> String {
        if selectedRepetition != "Never" && selectedRepetition != goalData!.repeatOption {
            return selectedRepetition
        }
        return goalData!.repeatOption
    }
    
    func updateGoal() {
        let goalsDB = Database.database().reference().child("Goals")
        let updatedData = [
            "name" : updateName(),
            "category" : updateCategory(),
            "startDate" : updateStartDate(),
            "endDate" : updateEndDate(),
            "goalRepeatOption" : updateRepeatOption(),
            ]
        
        let childUpdates = ["\(goalData!.key)" : updatedData]
        goalsDB.updateChildValues(childUpdates)
        popTwo()
    }
    
    func deleteGoal() {
        let goalToDel = Database.database().reference().child("Goals").child("\(goalData!.key)")
        goalToDel.removeValue()
        popTwo()
    }
    
    func popTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }

    @IBAction func donePressed(_ sender: Any) {
        updateGoal()
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        deleteGoal()
    }
    
}
