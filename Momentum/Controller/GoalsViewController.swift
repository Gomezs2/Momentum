//
//  GoalsViewController.swift
//  Momentum
//
//  Created by Kevin Kim on 3/19/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class GoalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var goalsTableView: UITableView!
    
    var goalArray : [Goal] = [Goal]()
    var rowChoosen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        
        // Register .xib file
        goalsTableView.register(UINib(nibName: "GoalCell", bundle: nil), forCellReuseIdentifier: "customGoalCell")
        
        retrieveGoals()
        goalsTableView.separatorStyle = .none
    }
    
    func designCell(cell: GoalsTableViewCell) {
        cell.progress.transform = CGAffineTransform(scaleX: 1, y: 8)
    }
    
    // Init cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customGoalCell", for: indexPath) as! GoalsTableViewCell
        
        designCell(cell:cell)
        
        cell.title.text = goalArray[indexPath.row].name
        return cell
    }
    
    // Declare number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowChoosen = indexPath.row
        performSegue(withIdentifier: "goToSingleGoal", sender: self)
    }
    
    func retrieveGoals() {
        let goalsDB = Database.database().reference().child("Goals")
        //message will run whenever a new message is added to the messages database
        goalsDB.observe(.childAdded) { (snapshot) in
            //Check if this is currentUser's goal
            let keyArray = snapshot.key.split(separator: ":")
            let userID = String(keyArray.first!)
    
            if userID != Auth.auth().currentUser?.uid {
                return
            }
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let goalName = snapshotValue["name"]!
            let goalCategory = snapshotValue["category"]!
            let goalStartDate = snapshotValue["startDate"]!
            let goalEndDate = snapshotValue["endDate"]!
            let goalRepeatOption = snapshotValue["goalRepeatOption"]!
            
            let goal = Goal(goalKey: snapshot.key, name: goalName, category: goalCategory, startDate: goalStartDate, endDate: goalEndDate, repeatOption: goalRepeatOption)

            self.goalArray.append(goal)
            self.goalsTableView.reloadData()
        }
        
        goalsDB.observe(.childRemoved) { (snapshot) in
            //Check if this is currentUser's goal
            let keyArray = snapshot.key.split(separator: ":")
            let userID = String(keyArray.first!)
            
            if userID != Auth.auth().currentUser?.uid {
                return
            }
            
            for (index, goal) in self.goalArray.enumerated() {
                if goal.key == snapshot.key {
                    self.goalArray.remove(at: index)
                    break
                }
            }
            self.goalsTableView.reloadData()
        }
        
        goalsDB.observe(.childChanged) { (snapshot) in
            //Check if this is currentUser's goal
            let keyArray = snapshot.key.split(separator: ":")
            let userID = String(keyArray.first!)
            
            if userID != Auth.auth().currentUser?.uid {
                return
            }
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            for goal in self.goalArray {
                if goal.key == snapshot.key {
                    goal.name = snapshotValue["name"]!
                    goal.category = snapshotValue["category"]!
                    goal.startDate = snapshotValue["startDate"]!
                    goal.endDate = snapshotValue["endDate"]!
                    goal.repeatOption = snapshotValue["goalRepeatOption"]!
                    break
                }
            }
            self.goalsTableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSingleGoal"{
            let destVC = segue.destination as! SingleGoalViewController
            destVC.goalData = goalArray[rowChoosen]
        }
    }
    
}
