//
//  SettingsTableView.swift
//  Demograph
//
//  Created by Frederick Holland on 26/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTableView: UITableViewController {
    
    
    let settings: [String] = ["Username", "Full Name", "Bio", "Picture", "Banner"]
    let management: [String] = ["Manage Platforms", "Manage Ads", /*"Demograph Premium"*/]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return settings.count
        } else if section == 1 {
            return management.count
        } else {
            return 0
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } catch let signoutError as NSError {
            print(signoutError)
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableCell
        // Configure the cell...
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            let setting = settings[row]
            cell.primaryText.text = setting
        } else if section == 1 {
            let manage = management[row]
            cell.primaryText.text = manage
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        if section == 0 {
            header.text = "Settings"
        } else if section == 1 {
            header.text = "Manage"
        }
        header.backgroundColor = UIColor(red: 96/255, green: 175/255, blue: 95/255, alpha: 1)
        header.textColor = UIColor.white
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The row at indexPath has been pressed.
        var row = indexPath.row
        if indexPath.section == 1 {
            row += 5
        }
        
        if row == 0 {
            // MARK:- USERNAME
            
            let alertController = UIAlertController(title: "Username:", message: "Please enter username.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: {
                (alert) in
                
                
                let nameField = alertController.textFields![0] as UITextField
                guard let name = nameField.text, !name.isEmpty else {
                    
                    return
                }
                if name.count < 4 {
                    
                    return
                }
                
                Account.userTagExists(user_tag: name, completionHandler: {
                    exists in
                    if !exists {
                        
                        Profile.current.local_tag = name
                        Profile.attemptSaveCurrent(completion: {
                            success in
                            if success {
                                
                            } else {
                                
                            }
                        })
                    } else {
                        // MARK:- TODO: close alert view and open new one
                        
                    }
                })
            }))
            
            alertController.addTextField(configurationHandler: {
                textField in
                textField.placeholder = "New username"
                textField.font = UIFont(name: "Avenir_Next", size: 17)
            })
            self.present(alertController, animated: true, completion: nil)
        } else if row == 1 {
            // MARK:- FULL NAME
            let alertController = UIAlertController(title: "Fullname:", message: "Please enter your name.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: {
                (alert) in
                
                let nameField = alertController.textFields![0] as UITextField
                guard let name = nameField.text, !name.isEmpty else {
                    
                    return
                }
                Profile.current.name = name
                Profile.attemptSaveCurrent(completion: {
                    success in
                    if success {
                        
                    }
                })
            }))
            
            alertController.addTextField(configurationHandler: {
                textField in
                textField.placeholder = "New name"
                textField.font = UIFont(name: "Avenir_Next", size: 17)
            })
            self.present(alertController, animated: true, completion: nil)
        } else if row == 2 {
            // MARK:- BIO
            let alertController = UIAlertController(title: "Enter bio:", message: "Please enter a short bio.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: {
                (alert) in
                
                let nameField = alertController.textFields![0] as UITextField
                guard let name = nameField.text, !name.isEmpty else {
                    
                    return
                }
                
                Profile.current.bio = name
                Profile.attemptSaveCurrent(completion: {
                    success in
                    if success {
                        
                    }
                })
            }))
            
            alertController.addTextField(configurationHandler: {
                textField in
                textField.placeholder = "New bio"
                textField.font = UIFont(name: "Avenir_Next", size: 17)
            })
            self.present(alertController, animated: true, completion: nil)
        } else if row == 3 {
            // MARK:- PICTURE
            let imageController = self.storyboard?.instantiateViewController(withIdentifier: "imagePicker") as! ImagePickerController
            imageController.instance = self
            imageController.id = 1
            self.present(imageController, animated: true, completion: nil)
        } else if row == 4 {
            // MARK:- BANNER
            let imageController = self.storyboard?.instantiateViewController(withIdentifier: "imagePicker") as! ImagePickerController
            imageController.instance = self
            imageController.id = 2
            self.present(imageController, animated: true, completion: nil)
        } else if row == 5 {
            // MARK:- MANAGE PLATFORMS
            let platformManager = self.storyboard?.instantiateViewController(withIdentifier: "addPlatformController") as! AddPlatformController
            self.present(platformManager, animated: true, completion: nil)
        } else if row == 6 {
            // MARK:- MANAGE ADS
            let adManager = self.storyboard?.instantiateViewController(withIdentifier: "adManagerTableView") as! AdManagerTableView
            self.present(adManager, animated: true, completion: nil)
        } else if row == 7 {
            
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
