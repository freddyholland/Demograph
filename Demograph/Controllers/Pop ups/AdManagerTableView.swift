//
//  AdManagerTableView.swift
//  Demograph
//
//  Created by iMac on 13/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AdManagerTableView: UITableViewController, InputAlertDelegate {
    
    var ads: [Clip] = []
    var selected_index: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Profile.current.clips?.count == 0 {
            print("The current profile does not have any registered clips.")
            return
        }
        
        reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ads.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipInfoCell", for: indexPath) as! ClipInfoCell
        let ad = ads[indexPath.row]
        
        cell.id = ad.id
        
        cell.clipTitleLabel.text = ad.title
        cell.clipInfoLabel.text = "\(ad.date)"
        cell.platformIconImageView.image = UIImage(named: "\(ad.platform.rawValue.lowercased())")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ad = ads[indexPath.row]
        print("selected \(ad.platform) ad, titled: \(ad.title)")
        
        selected_index = indexPath
        let selection_controller = SelectionViewController.instantiate()
        selection_controller.delegate = self
        selection_controller.headingString = "Manage Ad"
        selection_controller.messageString = "Do you want to delete this clip?"
        
        DGAlert.present(controller: selection_controller, on: self)
    }
    
    func onBooleanInput(result: Bool) {
        let cell = tableView.cellForRow(at: selected_index) as! ClipInfoCell
        let id = cell.id!
        
        // Remove the clip from /clips/{id} reference.
        Profile.current.removeClip(withID: id)
        { (result) in
            if result == false {
                DGAlert.errorAlert(with: 207, controller: self)
            } else {
                DGAlert.alert(withTitle: "Success!", message: "You successfully deleted a clip.", controller: self)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func reloadData() {
        Firestore.firestore().collection("clips").whereField("id", in: Profile.current.clips!).limit(to: 20).getDocuments
            { (snapshot, error) in
            
                if let error = error {
                    print("An error occurred!")
                    print(error)
                    return
                }
                
                for document in snapshot!.documents {
                    let returnedClip = Clip.getClip(from: document.data())
                    self.ads.append(returnedClip)
                }
                
                self.tableView.reloadData()
        }
    }

}
