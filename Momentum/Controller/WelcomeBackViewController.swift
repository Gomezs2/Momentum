//
//  WelcomeBackViewController.swift
//  Momentum
//
//  Created by Paul Lim on 3/25/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class WelcomeBackViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    var timer:Timer?
    var welcomeTime:Int = 2
    
    @objc func timerTick() {
        welcomeTime -= 1
        if (welcomeTime <= 0) {
            timer!.invalidate()
            timer = nil
            self.performSegue(withIdentifier: "GoToGoals", sender: self)
        }
    }
    
    func setUserName() {
        let currUID = Auth.auth().currentUser!.uid
        let userData =  Database.database().reference().child("Users").child(currUID)
        // get all of the user's data
        userData.observe(.value, with: {snapshot in
            if let dataDict = snapshot.value as? [String:Any],
                let userFirstName = dataDict["firstName"] as? String {
                self.userNameLabel.text! = userFirstName + "!"
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserName()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
