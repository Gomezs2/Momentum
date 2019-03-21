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
    
    private var data = [Goal]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1")
        self.title = "GoalsTableView"
        
        data = [Goal.init(title : "Title", progress : 50),
                Goal.init(title : "Go to Gym", progress : 30),
                Goal.init(title : "Momentum Project", progress: 10)]
        
        tableView.delegate = self
        tableView.dataSource = self
        print("2")
        
        let nibName = UINib(nibName: "GoalsTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "GoalsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalsTableViewCell", for: indexPath) as! GoalsTableViewCell
        
        cell.commonInit(name: data[indexPath.item].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
}
