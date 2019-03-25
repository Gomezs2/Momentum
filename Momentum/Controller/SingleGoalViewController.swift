//
//  SingleGoalViewController.swift
//  Momentum
//
//  Created by Sergio Gomez on 3/23/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit

class SingleGoalViewController: UIViewController{
    // Goal data passed in by segue
    var goalData: Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = goalData?.name
        goalsData(goal: goalData!)
    }
    // Testing function
    func goalsData(goal: Goal) {
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
