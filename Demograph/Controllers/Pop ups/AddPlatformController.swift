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
        // Do any additional setup after loading the view.
        
        print(Profile.current.id)
        pickerValues = Platforms.allCases
        
        self.platformPickerView.delegate = self
        self.platformPickerView.dataSource = self
        
        platformTagField.delegate = self
        nameField.delegate = self
        
    }
    
    @IBAction func addPressed(_ sender: Any) {
        let platform_type: Platforms = pickerValues[platformPickerView.selectedRow(inComponent: 0)]
        guard let userTag = platformTagField.text, !userTag.isEmpty else {
            print("The users tag field is empty")
            return
        }
        guard let userName = nameField.text, !userName.isEmpty else {
            print("The users name field is empty")
            return
        }
        
        let platform = Platform(type: platform_type, userTag: userTag, userName: userName)
        let prof = Profile.current
        let currentplats = prof.platforms
        if currentplats?.count != 0 {
            for index in 0...currentplats!.count-1 {
                if currentplats![index].type == platform.type {
                    // Original platform needs to be removed.
                    print("case of platform already exists so removed it")
                    prof.platforms?.remove(at: index)
                    break
                }
            }
        }
        
        prof.platforms?.append(platform)
        Profile.attemptSaveCurrent(completion: {
            success in
            
            if success {
                print("success! saved platform to user")
            } else {
                print("error occured! platform couldn't save")
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row].rawValue
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
