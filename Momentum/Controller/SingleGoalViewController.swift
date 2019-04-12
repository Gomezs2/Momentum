//
//  SingleGoalViewController.swift
//  Momentum
//
//  Created by Sergio Gomez on 3/23/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit

class SingleGoalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var milestonesTableView: UITableView!
    // Goal data passed in by segue
    var goalData: Goal?
    var milestoneArray = ["milestone1","milestone2", "milestone3"]
    
    @IBOutlet weak var goalDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = goalData?.name
        goalsData(goal: goalData!)
        
        // Table View
        milestonesTableView.delegate = self
        milestonesTableView.dataSource = self
        
    milestonesTableView.register(UINib(nibName:"MilestoneCell", bundle: nil), forCellReuseIdentifier: "customMilestoneCell")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMilestoneCell", for: indexPath) as! MilestonesTableViewCell
        
        cell.title.text = "Title"
        cell.startDate.text = "Start Date"
        cell.endDate.text = "End Date"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milestoneArray.count
    }
    
    // Testing function
    func goalsData(goal: Goal) {
        goalDate.text = goal.startDate
        print(goal.key)
        print(goal.name)
        print(goal.category)
        print(goal.startDate)
        print(goal.endDate)
        print(goal.repeatOption)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditGoal"{
            let destVC = segue.destination as! EditGoalViewController
            destVC.goalData = goalData
        }
    }
    
    
}
