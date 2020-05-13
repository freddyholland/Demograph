//
//  PreferenceManagerController.swift
//  Demograph
//
//  Created by iMac on 7/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import EzPopup

class PreferenceManagerController: UIViewController, UITableViewDelegate, UITableViewDataSource, TagSearchDelegate {
    
    func onCompleteDataInput(data: [String]) {
        // This function is called when the Tag controller is updated.
        preference.tags = data
        preference.savePreference(forUser: Profile.current.id)
        
        tagTableView.reloadData()
    }
    
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var platformTableView: UITableView!
    
    var preference: Preference = Preference(types: [], tags: [])
    
    var loaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagTableView.delegate = self
        tagTableView.dataSource = self
        
        platformTableView.delegate = self
        platformTableView.dataSource = self
        
        loadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == tagTableView {
            
            return preference.tags.count
            
        } else if tableView == platformTableView {
            
            return preference.types.count
            
        } else {
            
            return 0
            
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        if tableView == tagTableView {
            
            let tag = preference.tags[indexPath.row]
            // Load relevant data for tags.
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagIdentifier", for: indexPath) as! PreferenceTagCell
            cell.tagLabel.text = tag
            return cell
            
        } else if tableView == platformTableView {
            
            let platform = preference.types[indexPath.row]
            // Load relevant data for platforms.
            let cell = tableView.dequeueReusableCell(withIdentifier: "platformIdentifier", for: indexPath) as! PreferencePlatformCell
            cell.platformImage.image = UIImage(named: "\(platform.rawValue.lowercased())")
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tagTableView {
            return 64
        } else if tableView == platformTableView {
            return 95
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !loaded {
            return
        }
        
        if tableView == tagTableView {
            
            let tag = preference.tags[indexPath.row]
            DGAlert.alert(withTitle: "Manage Tag", message: "Do you want to delete this tag?", controller: self)
            
        } else if tableView == platformTableView {
            
            let platform = preference.types[indexPath.row]
            DGAlert.alert(withTitle: "Manage Platform", message: "Do you want to delete this platform?", controller: self)
            // Get response to delete or dismiss.
            
        }
    }
    
    func loadData() {
        
        print("attempting to download tag & platform data")
        
        loaded = false
        
        Preference.getSavedPreference(forUser: Profile.current.id)
        { (pref) in
            
            print("downloaded preference")
            self.preference = pref
            print("\(pref.types) + \(pref.tags)")
            
            self.loaded = true
            
            self.tagTableView.reloadData()
            self.platformTableView.reloadData()
            
        }
    }
    
    @IBAction func addTagPress(_ sender: Any) {
        
        let search = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tagSearchController") as! TagSearchController
        search.delegate = self
        search.selected = preference.tags
        
        self.present(search, animated: true, completion: nil)
        
    }
    
    @IBAction func addPlatformPress(_ sender: Any) {
        
        if !loaded {
            print("currently not loaded all platforms")
            return
        }
        
        let picker = PickerViewController.instantiate()
        picker.current = preference
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
}