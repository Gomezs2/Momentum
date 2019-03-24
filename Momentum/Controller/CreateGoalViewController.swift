//
//  CreateGoalViewController.swift
//  Momentum
//
//  Created by Sergio Gomez on 3/23/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class CreateGoalViewController: UIViewController {

    @IBOutlet weak var goalName: UITextField!
    @IBOutlet weak var goalCategory: UIPickerView!
    @IBOutlet weak var goalStartDate: UIDatePicker!
    @IBOutlet weak var goalEndDate: UIDatePicker!
    @IBOutlet weak var goalRepeatOption: UIPickerView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var firstGoal = false
    var userGoals : [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func userInteractionEnabled(value : Bool){
        doneButton.isEnabled = value
        goalName.isEnabled = value
        goalCategory.isUserInteractionEnabled = value
        goalStartDate.isUserInteractionEnabled = value
        goalEndDate.isUserInteractionEnabled = value
        goalRepeatOption.isUserInteractionEnabled = value
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
        
        // Once UIPicker's are init - update this code
        let goalData = [
            "name" : goalName.text!,
            "category" : "UIPicker not init",
            "startDate" : "UIPicker not init",
            "endDate" : "UIPicker not init",
            "goalRepeatOption" : "UIPicker not init"
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
