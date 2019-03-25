//
//  EditGoalViewController.swift
//  Momentum
//
//  Created by Linnea Cajuste on 2019-03-24.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit

class EditGoalViewController:
    UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet var goalName: UITextField! //TO DO set goal name to the user's previous goal name
    @IBOutlet var categories: UIPickerView!
    @IBOutlet var repetitions: UIPickerView!
    @IBOutlet var weekdayButtons: [UIButton]!
    
    @IBOutlet var endDate: UIDatePicker!
    @IBOutlet var startDate: UIDatePicker!
    
    @IBAction func startDateChanges(_ sender: Any) {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateStyle = DateFormatter.Style.short
        let strStartDate = startDateFormatter.string( from: startDate.date) ///strStartDate string stores the goal start date in MM/DD/YY
        print(strStartDate)
    }
    
    @IBAction func endDateChanges(_ sender: Any) {
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateStyle = DateFormatter.Style.short
        let strEndDate = endDateFormatter.string( from: endDate.date) ///strEndDate string stores the goal start date in MM/DD/YY
        print(strEndDate)
    }
    
    
    var daysSelected = "" //String that stores weekdays to repeat goal. Format: S|M|T|W|
    
    var categoryOptions = ["General", "Efficency", "Fitness", "Health", "Hobbies", "Social","Skills" ]
    var repetitionOptions = ["Never", "Daily", "Weekly", "Monthly", "Yearly"]
    
    //TO DO: change these variables to the user's previous choice
    var selectedCategory = "Default"
    var selectedRepetition = "Never"
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
