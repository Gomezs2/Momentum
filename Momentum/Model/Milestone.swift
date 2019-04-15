//
//  Milestone.swift
//  Momentum
//
//  Created by Sergio Gomez on 4/14/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import Foundation

class Milestone {
    
    var key : String = ""
    var name : String = ""
    var startDate : String = ""
    var endDate: String = ""
    var reminderValue : String = ""
    var reminderLength : String = ""
    
    init(milestoneKey: String, name: String, startDate: String , endDate: String, reminderValue: String, reminderLength : String) {
        self.key = milestoneKey
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.reminderValue = reminderValue
        self.reminderLength = reminderLength
    }
}

