//
//  EditProfileViewController.swift
//  Momentum
//
//  Created by Sergio Gomez on 4/15/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class EditProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!

    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var reNewPasswordField: UITextField!
    
    var name : String = ""
    var email : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text! = name
        emailLabel.text! = email

    }
    
    func createAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func validateInputs(){
        let inputFields = [newPasswordField, reNewPasswordField]
        let errorMessage = ["newPassword", "reNewPassword"]
        // Check if all fields have input
        for (index, field) in inputFields.enumerated() {
            if field!.text!.count == 0 {
                createAlert(errorMessage: "Enter a " + errorMessage[index])
            }
        }
        // Check if passwords match
        if newPasswordField!.text! != reNewPasswordField!.text!{
            createAlert(errorMessage: "Passwords do not match!")
        }
    }

    @IBAction func savePressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().currentUser?.updatePassword(to: reNewPasswordField!.text!) { (error) in
            if error != nil {
                SVProgressHUD.dismiss()
                self.createAlert(errorMessage: error!.localizedDescription)
            }
            else {
                SVProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    

}
