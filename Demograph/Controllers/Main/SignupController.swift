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
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        guard let password = passwordField.text, !password.isEmpty else {
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        guard let confirmedPassword = confirmPasswordField.text, !confirmedPassword.isEmpty else {
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        guard let username = usernameField.text, !username.isEmpty else {
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        guard let fullName = fullnameField.text, !fullName.isEmpty else {
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        if password != confirmedPassword {
            print("Two passwords don't match")
            DGAlert.errorAlert(with: 102, controller: self)
            return
        }
        if(username.count < 4) {
            print("User tag is less than 4 chars.")
            DGAlert.errorAlert(with: 104, controller: self)
            return
        }
        let validCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321_.")
        if (username.rangeOfCharacter(from: validCharacters.inverted) != nil) {
            DGAlert.errorAlert(with: 105, controller: self)
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
                        DGAlert.errorAlert(with: 203, controller: self)
                    }
                })
            } else {
                print("The username is already in use.")
                DGAlert.errorAlert(with: 103, controller: self)
            }
        })
    }
    
}
