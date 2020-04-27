//
//  ProfileTableViewViewController.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 31/03/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var userBanner: UIImageView!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userTag: UILabel!
    @IBOutlet weak var userFullname: UILabel!
    @IBOutlet weak var userBio: UILabel!
    
    @IBOutlet weak var platformTableView: UITableView!
    
    var userAccount = Placeholders.userAccount
    
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
            cell.userLink.text = "You do not have any platforms."
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllContent()
        
        //self.platformTableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 49, right: 0.0)

        platformTableView.delegate = self
        platformTableView.dataSource = self
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func reloadPressed(_ sender: Any) {
        loadAllContent()
    }
    
    func loadAllContent() {
        print("Reloading all content on profile.")
        Profile.attemptLoadCurrent(completion: {
            success in
            if success {
                self.userAccount = Profile.current
                
                self.userTag.text = self.userAccount.local_tag
                self.userFullname.text = self.userAccount.name
                self.userBio.text = self.userAccount.bio
                
                self.platformTableView.reloadData()
                print("### Loaded all profile data. \(Profile.current.local_tag)")
            } else {
                print("### An error occurred retrieving profile information")
            }
        })
        
    }
}
