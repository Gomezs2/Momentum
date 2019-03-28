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
    
    @IBOutlet weak var goalDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = goalData?.name
        goalsData(goal: goalData!)
    }
    // Testing function
    func goalsData(goal: Goal) {
        goalDate.text = goal.startDate
        print(goal.name)
        print(goal.category)
        print(goal.startDate)
        print(goal.endDate)
        print(goal.repeatOption)
    }
    
    
}
