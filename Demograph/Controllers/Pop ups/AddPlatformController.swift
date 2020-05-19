//
//  AddPlatformController.swift
//  Demograph
//
//  Created by iMac on 29/4/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class AddPlatformController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var platformPickerView: UIPickerView!
    @IBOutlet weak var platformTagField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    var pickerValues: [Platforms]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all platforms that aren't .Advertisement
        var availablePlatforms = Platforms.allCases.filter( { $0 == Platforms.Advertisement } )
        
        // Cycle through the users platforms and filter out of available array if an instance of it already exists.
        for platform in Profile.current.platforms! {
            availablePlatforms = availablePlatforms.filter( { $0 == platform.type } )
        }
        
        // Set the picker values to the filtered available platforms.
        pickerValues = availablePlatforms
        
        // Setup the picker view.
        self.platformPickerView.delegate = self
        self.platformPickerView.dataSource = self
        
        // Setup the text fields.
        platformTagField.delegate = self
        nameField.delegate = self
        
    }
    
    @IBAction func addPressed(_ sender: Any) {
        
        // Get the platform that's currently selected in the picker view.
        let platform_type: Platforms = pickerValues[platformPickerView.selectedRow(inComponent: 0)]
        
        // Check that userTag is not empty.
        guard let userTag = platformTagField.text, !userTag.isEmpty else {
            print("The users tag field is empty")
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        
        // Check that userName is not empty.
        guard let userName = nameField.text, !userName.isEmpty else {
            print("The users name field is empty")
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        
        // Convert the given information into a platform.
        let platform = Platform(type: platform_type, userTag: userTag, userName: userName)
        let prof = Profile.current
        
        // Add the newly selected platform to an array of existing platforms and re-upload to the database.
        prof.platforms?.append(platform)
        Profile.attemptSaveCurrent(completion: {
            success in
            
            if success {
                print("Successfully saved the added platform to the user.")
            } else {
                print("An error occurred saving the added platform.")
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Picker view setup.
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row].rawValue
    }
    
    // Managing text field protocols.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
