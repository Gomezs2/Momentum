//
//  SingleGoalViewController.swift
//  Momentum
//
//  Created by Sergio Gomez on 3/23/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class SingleGoalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var goalDate: UILabel!
    @IBOutlet weak var goalProgress: UIProgressView!
    @IBOutlet weak var milestonesTableView: UITableView!
    
    // Goal data passed in by segue
    var goalData: Goal?
    var milestoneArray : [Milestone] = [Milestone]()
    var rowChoosen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = goalData?.name
        goalDate.text = goalData?.endDate
        
        self.goalProgress.transform = CGAffineTransform(scaleX: 1, y: 8)
        
        // Table View
        milestonesTableView.delegate = self
        milestonesTableView.dataSource = self
        milestonesTableView.register(UINib(nibName:"MilestoneCell", bundle: nil), forCellReuseIdentifier: "customMilestoneCell")
        
        retrieveMilestones()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMilestoneCell", for: indexPath) as! MilestonesTableViewCell
        cell.title.text = milestoneArray[indexPath.row].name
        cell.endDate.text =  milestoneArray[indexPath.row].endDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milestoneArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowChoosen = indexPath.row
        performSegue(withIdentifier: "goToEditMilestone", sender: self)
    }
    
    func retrieveMilestones() {
        let milestoneDB = Database.database().reference().child("Milestones")
        //message will run whenever a new message is added to the messages database
        milestoneDB.observe(.childAdded) { (snapshot) in
            //Check if this is current User's data
            let keyArray = snapshot.key.components(separatedBy: ":")
            let goalID = keyArray[0] + ":" + keyArray[1]
        
            if goalID != self.goalData?.key {
                return
            }
            
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            let milestoneCompleted = snapshotValue["completed"]! as! String
            if milestoneCompleted == "true" {
                // check if milestone is complete; if so, don't add to table
                return
            }
            
            let milestoneName = snapshotValue["name"]! as! String
            let milestoneStartDate = snapshotValue["startDate"]! as! String
            let milestoneEndDate = snapshotValue["endDate"]! as! String
            let milestoneReminderValue = snapshotValue["reminderValue"]! as! String
            let milestoneReminderLength = snapshotValue["reminderLength"]! as! String
          
            let milestone = Milestone(milestoneKey: snapshot.key, name: milestoneName, startDate: milestoneStartDate, endDate: milestoneEndDate, reminderValue: milestoneReminderValue, reminderLength: milestoneReminderLength, completed: milestoneCompleted)
            
            self.milestoneArray.append(milestone)
            self.milestonesTableView.reloadData()
        }
        
        milestoneDB.observe(.childRemoved) { (snapshot) in
            //Check if this is current User's goal
            let keyArray = snapshot.key.components(separatedBy: ":")
            let goalID = keyArray[0] + ":" + keyArray[1]

            if goalID != self.goalData?.key {
                return
            }
            
            for (index, milestone) in self.milestoneArray.enumerated() {
                if milestone.key == snapshot.key {
                    self.milestoneArray.remove(at: index)
                    break
                }
            }
            self.milestonesTableView.reloadData()
        }
        
        milestoneDB.observe(.childChanged) { (snapshot) in
            //Check if this is current User's goal
            let keyArray = snapshot.key.components(separatedBy: ":")
            let goalID = keyArray[0] + ":" + keyArray[1]

            if goalID != self.goalData?.key {
                return
            }
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            for (i, milestone) in (self.milestoneArray).enumerated() {
                if milestone.key == snapshot.key {
                    milestone.completed = snapshotValue["completed"]! as! String
                    // check if the milestone was marked as completed
                    if milestone.completed == "true" {
                        // don't have to update milestone's fields in the view, just remove from milestones table
                        self.milestoneArray.remove(at: i)
                        break
                    }
                    milestone.name = snapshotValue["name"]! as! String
                    milestone.startDate = snapshotValue["startDate"]! as! String
                    milestone.endDate = snapshotValue["endDate"]! as! String
                    milestone.reminderValue = snapshotValue["reminderValue"]! as! String
                    milestone.reminderLength = snapshotValue["reminderLength"]! as! String
                    milestone.completed = snapshotValue["completed"]! as! String
                    break
                }
            }
            self.milestonesTableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditGoal"{
            let destVC = segue.destination as! EditGoalViewController
            destVC.goalData = goalData
        }
        else if segue.identifier == "goToCreateMilestone"{
            let destVC = segue.destination as! CreateMilestoneViewController
            destVC.goalData = goalData
        }
        else if segue.identifier == "goToEditMilestone"{
            let destVC = segue.destination as! EditMilestoneViewController
            destVC.milestoneData = milestoneArray[rowChoosen]
        }
    }
    
}
