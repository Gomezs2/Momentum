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
    let progress : Int
}

class GoalsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!
    private var data = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = [Goal.init(title : "Title", progress : 50)]
        
        self.tableView.register(GoalCell.self, forCellReuseIdentifier: "custom")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! GoalCell
        cell.title = data[indexPath.row].title
        cell.progress = data[indexPath.row].progress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
}
