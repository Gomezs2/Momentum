//
//  WelcomeBackViewController.swift
//  Momentum
//
//  Created by Paul Lim on 3/25/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit

class WelcomeBackViewController: UIViewController {
    var timer:Timer?
    var welcomeTime:Int = 2
    
    @objc func timerTick() {
        welcomeTime -= 1
        if (welcomeTime <= 0) {
            timer!.invalidate()
            timer = nil
            self.performSegue(withIdentifier: "goToGoals", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

