//
//  SignUpViewController.swift
//  Momentum
//
//  Created by Sergio Gomez on 3/19/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func validateInputs(){
        let inputFields = [emailTextField, firstNameTextField, lastNameTextField, passwordTextField, rePasswordTextField ]
        let errorMessage = ["Email", "First Name", "Last Name", "Password", "rePassword"]
        // Check if all fields have input
        for (index, field) in inputFields.enumerated() {
            if field!.text!.count == 0 {
                createAlert(errorMessage: "Enter a " + errorMessage[index])
            }
        }
        // Check if passwords match
        if passwordTextField!.text! != rePasswordTextField!.text!{
            createAlert(errorMessage: "Passwords do not match!")
        }
    }
    
    func putUsersData(userID: String, email: String, firstName: String, lastName: String){
        let usersDB = Database.database().reference().child("Users")
        
        let userData : [String : Any] = [
            "email" : email,
            "firstName" : firstName,
            "lastName" : lastName,
            "goals" : false
        ]
        // Send data to DB
        usersDB.child(userID).setValue(userData) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("Messaged sucessfully saved with id \(reference)")
            }
        }
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        validateInputs()
        SVProgressHUD.show()
        
        //Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil {
                //Save users data is users "table"
                self.putUsersData(userID: Auth.auth().currentUser!.uid, email: self.emailTextField.text!,
                                  firstName: self.firstNameTextField.text!,lastName: self.lastNameTextField.text!)
                
                SVProgressHUD.dismiss()
                
                //Go to chat view
                self.performSegue(withIdentifier: "goToGoals", sender: self)
            } else{
                SVProgressHUD.dismiss()
                self.createAlert(errorMessage: error!.localizedDescription)
            }
        }
    }
    

}
