//
//  LoginController.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 01/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailField.delegate = self
        passwordField.delegate = self
        
        // Check if user is signed in
        
        Auth.auth().addStateDidChangeListener({
            (auth, user) in
            if user != nil {
                self.segueToMainView()
            }
        })
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailField.text, !email.isEmpty else {
            print("Email field is not filled in")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            print("Password field is not filled in")
            return
        }
        
        activityIndicator.startAnimating()
        
        Account.attemptLogin(email: email, password: password, completionHandler: {
            (success, error) in
            self.activityIndicator.stopAnimating()
            if success {
                print("logged in")
                self.segueToMainView()
            } else {
                print(error!)
            }
        })
    }
    
    func segueToMainView() {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "mainTabController") as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        
        Profile.attemptLoadCurrent(completion: {
            success in
            
            if success {
                print("Successfully loaded current controller.")
            }
        })
        
        self.present(mainView, animated: true, completion: {
            
            self.emailField.text = ""
            self.passwordField.text = ""
            
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
