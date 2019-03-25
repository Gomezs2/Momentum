//
//  Goal.swift
//  Momentum
//
//  Created by Sergio Gomez on 3/23/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

class Goal {
    
    var key : String = ""
    var name : String = ""
    var category : String = ""
    var startDate : String = ""
    var endDate: String = ""
    var repeatOption : String = ""
    
    init(goalKey: String, name: String, category: String, startDate: String , endDate: String, repeatOption: String) {
        self.key = goalKey
        self.name = name
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        self.repeatOption = repeatOption
    }
    
   
    
}
