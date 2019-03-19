//
//  GoalsViewController.swift
//  Momentum
//
//  Created by Kevin Kim on 3/19/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let goals_list = ["Goal1", "Goal2", "Goal3", "Goal4", "Goal5"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (goals_list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        return(cell)
    }   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
