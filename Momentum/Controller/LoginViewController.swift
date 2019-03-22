//
//  LoginViewController.swift
//  Momentum
//
//  Created by Sergio Gomez on 3/19/19.
//  Copyright © 2019 Triceratops. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func createAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    @IBAction func loginPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        // Log in the user
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            if error == nil {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToGoals", sender: self)
            }
            else{
                SVProgressHUD.dismiss()
                self.createAlert(errorMessage: error!.localizedDescription)
            }
        }
    }
}
