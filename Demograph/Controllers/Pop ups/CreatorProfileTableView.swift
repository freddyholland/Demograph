//
//  CreatorProfileTableView.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 05/05/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreatorProfileTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullnameTextField: UILabel!
    @IBOutlet weak var localtagTextField: UILabel!
    @IBOutlet weak var biographyTextField: UILabel!
    @IBOutlet weak var userPlatformsTableView: UITableView!
    
    
    var userAccount: Profile = Placeholders.userAccount
    var userID: String!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let platformCount = userAccount.platforms!.count
        if platformCount == 0 {
            return 1
        }
        return userAccount.platforms!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "platformCell", for: indexPath) as! PlatformTableCell

        if userAccount.platforms?.count == 0 {
            cell.userLink.textColor = UIColor.gray
            cell.userLink.text = "There are no platforms to display."
            cell.userFullname.text = ""
            cell.userInfo.text = ""
            cell.platformIcon.image = UIImage()
            return cell
        }
        
        // Configure the cell...
        let platform: Platform = userAccount.platforms![indexPath.row]
        
        cell.platformIcon.image = UIImage(named: platform.type.rawValue.lowercased())
        cell.userLink.text = platform.userTag
        cell.userFullname.text = platform.userName
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let platform: Platform = userAccount.platforms![indexPath.row]
        
        print("did select row")
        let alertView = UIAlertController(title: "Platform Options", message: "", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Back", style: .default, handler: {
            (alert) in
        }))
        
        alertView.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
            (alert) in
            Profile.current.platforms?.remove(at: indexPath.row)
            self.allowModification = false
            Profile.attemptSaveCurrent(completion: {
                success in
                if success {
                    print("successfully deleted requested platform")
                    self.loadAllContent()
                } else {
                    print("platform couldnt be deleted")
                    self.allowModification = true
                }
            })
        }))
        
        self.present(alertView, animated: true, completion: nil)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userPlatformsTableView.delegate = self
        userPlatformsTableView.dataSource = self
        
        // Downloads user's profile content.
        
        if userID == nil {
            print("userID = nil")
            return
        }
        
        Account.getProfile(userID: userID)
        { (profile) in
            print("Creator profile successfully loaded.")
            self.userAccount = profile
            self.reloadData()
        }
    }
    
    func reloadData() {
        
        self.localtagTextField.text = self.userAccount.local_tag
        self.fullnameTextField.text = self.userAccount.name
        self.biographyTextField.text = self.userAccount.bio
        self.profileImageView.image = self.userAccount.picture
        self.bannerImageView.image = self.userAccount.banner
        
        self.userPlatformsTableView.reloadData()
    }
    
}
