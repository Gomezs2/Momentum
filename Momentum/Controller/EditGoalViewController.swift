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

    @IBOutlet var categories: UIPickerView!
    @IBOutlet var repetitions: UIPickerView!
  
    var categoryOptions = ["General", "Efficency", "Fitness", "Health", "Hobbies", "Social","Skills" ]
    var repetitionOptions = ["Never", "Daily", "Weekly", "Monthly", "Yearly"]
    
    //change these variables to the user's previous choice
    var selectedCategory = "Default"
    var selectedRepetition = "Never"
    
    
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
