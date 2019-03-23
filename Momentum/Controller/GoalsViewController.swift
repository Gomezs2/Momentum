//
//  GoalsViewController.swift
//  Momentum
//
//  Created by Kevin Kim on 3/19/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit

struct Goal {
    let title : String
    let progress : Float
}

class GoalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var goalsTableView: UITableView!
    
    
//    private var data = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        
        // Register .xib file
        goalsTableView.register(UINib(nibName: "GoalCell", bundle: nil), forCellReuseIdentifier: "customGoalCell")
        

//        self.title = "GoalsTableView"
//
//        data = [Goal.init(title : "Title", progress : 50),
//                Goal.init(title : "Go to Gym", progress : 30),
//                Goal.init(title : "Momentum Project", progress: 10)]
        
    }
    
    // Init cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customGoalCell", for: indexPath) as! GoalsTableViewCell
        cell.title.text = "G1"
        return cell
        
//        cell.commonInit(name: data[indexPath.item].title)
//        return cell
    }
    
//    Declare number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
}
