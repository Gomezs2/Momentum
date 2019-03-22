//
//  GoalsTableViewCell.swift
//  Momentum
//
//  Created by Kevin Kim on 3/20/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit

class GoalsTableViewCell: UITableViewCell {    
    
    @IBOutlet weak var title: UILabel!
    func commonInit(name: String) {
        title.text = name
    }
}
