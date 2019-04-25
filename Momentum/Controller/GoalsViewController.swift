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
    
    
    // Init cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customGoalCell", for: indexPath) as! GoalsTableViewCell
        
        cell.daysRemain.text = calculateDaysRemain(goal: goalArray[indexPath.row])
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
            
            let snapshotValue = snapshot.value as! Dictionary<String,Any>
            let goalName = snapshotValue["name"]! as! String
            let goalCategory = snapshotValue["category"]! as! String
            let goalStartDate = snapshotValue["startDate"]! as! String
            let goalEndDate = snapshotValue["endDate"]! as! String
            let goalRepeatOption = snapshotValue["goalRepeatOption"]! as! String
            
            let goal = Goal(goalKey: snapshot.key, name: goalName , category: goalCategory, startDate: goalStartDate, endDate: goalEndDate, repeatOption: goalRepeatOption)

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
            
            let snapshotValue = snapshot.value as! Dictionary<String, Any>
            for goal in self.goalArray {
                if goal.key == snapshot.key {
                    goal.name = snapshotValue["name"]! as! String
                    goal.category = snapshotValue["category"]! as! String
                    goal.startDate = snapshotValue["startDate"]! as! String
                    goal.endDate = snapshotValue["endDate"]! as! String
                    goal.repeatOption = snapshotValue["goalRepeatOption"]! as! String
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
        else if segue.identifier == "goToProfile"{
            let destVC = segue.destination as! ProfileViewController
            destVC.goalArray = goalArray
        }
    }
    
    func calculateDaysRemain(goal: Goal) -> String {
        let today = Date()
        let userCalendar = Calendar.current
        
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]
        
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: today)
        
        print(today)
        print(goal.endDate)
        
        let endDateArray = goal.endDate.components(separatedBy: "/")
        
        let endYear = "20" + endDateArray[2]
        
        if Int(endYear) != dateTimeComponents.year {
            let endYear: Int = Int(endYear)!
            let currentYear: Int = dateTimeComponents.year!
            let remain: String = String(endYear - currentYear)
            
            if remain == "1" {
                return remain + "year left"
            } else {
                return remain + " years left"
            }
            
        } else if Int(endDateArray[0]) != dateTimeComponents.month {
            let endMonth: Int = Int(endDateArray[0])!
            let currentMonth: Int = dateTimeComponents.month!
            let remain: String = String(endMonth - currentMonth)
            
            if remain == "1" {
                return remain + " month left"
            } else {
                return remain + " months left"
            }
            
        } else if Int(endDateArray[1]) != dateTimeComponents.day{
            let endDay: Int = Int(endDateArray[1])!
            let currentDay: Int = dateTimeComponents.day!
            let remain: String = String(endDay - currentDay)
            
            if remain == "1" {
                return remain + " day left"
            } else {
                return remain + " days left"
            }
            
        } else {
            return "Due Today!"
        }
    }
}
