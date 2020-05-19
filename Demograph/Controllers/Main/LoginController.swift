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
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard let email = emailField.text, !email.isEmpty else {
            
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        
        activityIndicator.startAnimating()
        
        Account.attemptLogin(email: email, password: password, completionHandler: {
            (success, error) in
            self.activityIndicator.stopAnimating()
            if success {
                
                self.segueToMainView()
            } else {
                DGAlert.errorAlert(with: 201, controller: self)
                
            }
        })
    }
    
    func segueToMainView() {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "mainTabController") as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        
        Profile.attemptLoadCurrent(completion: {
            success in
            
            if success {
                
            } else {
                DGAlert.errorAlert(with: 202, controller: self)
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
