//
//  CreateMilestone.swift
//  Momentum
//
//  Created by Paul Lim on 4/1/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class CreateMilestoneViewController: UIViewController {
    @IBOutlet weak var milestoneNameField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var remindTimeField: UITextField!
    @IBOutlet weak var reminderPicker: UIPickerView!
    var reminderOptions = ["Minutes", "Hours", "Days"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
