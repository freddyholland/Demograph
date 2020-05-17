//
//  PickerViewController.swift
//  Demograph
//
//  Created by iMac on 7/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var totalAvailable: [Platforms] = Platform.getShareablePlatforms()
    var available:[Platforms] = []
    var current: Preference!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return available.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = available[row].rawValue
        return title
    }
    
    static func instantiate() -> PickerViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerController") as! PickerViewController
    }
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var returnButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("platform picker view did load")
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        for platform in totalAvailable {
            for type in current.types {
                if platform == type {
                    continue
                }
            }
            available.append(platform)
        }
        
        pickerView.reloadAllComponents()
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        print("button pressed")
        
        if pickerView.numberOfRows(inComponent: 0) == 0 {
            print("There are no more available platforms to be added.")
        } else {
            let selectedPlatform = available[pickerView.selectedRow(inComponent: 0)]
            print("selected \(pickerView.selectedRow(inComponent: 0))")
            print("returning \(selectedPlatform)")
            
            var currentPreferences = current.types
            currentPreferences.append(selectedPlatform)
            current.types = currentPreferences
            current.savePreference(forUser: Profile.current.id)
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func returnPressed() {
        print("image has been pressed")
    }
    
}
