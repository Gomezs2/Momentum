//
//  ProfileViewController.swift
//  Momentum
//
//  Created by Sergio Gomez on 4/14/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var totalGoalsLabel: UILabel!
    @IBOutlet weak var totalMilestonesLabel: UILabel!
    
    var goalArray : [Goal] = [Goal]()
    var milestoneCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        totalGoalsLabel.text = String(goalArray.count)
        getMilestoneData()
    }
    
    func getUserData(){
        let userID = Auth.auth().currentUser?.uid
        let userDB =  Database.database().reference().child("Users").child(userID!)
        
        userDB.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get users Data
            let snapshotValue = snapshot.value as! NSDictionary
            let firstName = snapshotValue["firstName"] as? String
            let lastName = snapshotValue["lastName"] as? String
            self.nameLabel.text = firstName! + " " + lastName!
            self.emailLabel.text = snapshotValue["email"] as? String
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getMilestoneData(){
        for goalID in goalArray {
            let goalsDB =
                Database.database().reference().child("Goals").child(goalID.key)
            goalsDB.observeSingleEvent(of: .value, with: { (snapshot) in
                // Format Data
                let snapshotValue = snapshot.value as! NSDictionary
                
                // Check if goal has a milestone
                if snapshotValue["milestones"] is Bool{
                    self.milestoneCount += 0
                }
                else{
                    self.milestoneCount += (snapshotValue["milestones"] as! NSDictionary).count
                    self.totalMilestonesLabel.text = String(self.milestoneCount)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            //Pop all views and return to root vc
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error: there was a problem signing out")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditProfile"{
            let destVC = segue.destination as! EditProfileViewController
            print(self.nameLabel.text!)
            print(self.emailLabel.text!)
            destVC.name = self.nameLabel.text!
            destVC.email = self.emailLabel.text!
        }
    }
}
