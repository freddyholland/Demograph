//
//  SignupController.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 01/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class SignupController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        
        guard let email = emailField.text, !email.isEmpty else {
            return
        }
        guard let password = passwordField.text, !password.isEmpty else {
            return
        }
        guard let confirmedPassword = confirmPasswordField.text, !confirmedPassword.isEmpty else {
            return
        }
        guard let username = usernameField.text, !username.isEmpty else {
            return
        }
        guard let fullName = fullnameField.text, !fullName.isEmpty else {
            return
        }
        if password != confirmedPassword {
            print("Two passwords don't match")
            return
        }
        if(username.count < 4) {
            print("User tag is less than 4 chars.")
            return
        }
        Account.userTagExists(user_tag: username, completionHandler: {
            exists in
            if !exists {
                Account.create(email: email, password: password, local_tag: username, name: fullName, platforms: [], completionHandler: {
                    (result, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    if result == true {
                        print("account created")
                        //self.dismiss(animated: true, completion: nil)
                    } else {
                        print("account was not created because 'result' equaled false")
                    }
                })
            } else {
                print("The username is already in use.")
            }
        })
    }
    
}
