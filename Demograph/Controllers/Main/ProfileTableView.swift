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
    var allowModification: Bool = false
    private let reload = UIRefreshControl()
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let platform: Platform = userAccount.platforms![indexPath.row]
        
        if !allowModification {
            return
        }
        
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        platformTableView.delegate = self
        platformTableView.dataSource = self
        
        self.platformTableView.refreshControl = reload
        reload.addTarget(self, action: #selector(self.reloadFullPage), for: .valueChanged)
        
        if Profile.current.id.isEmpty {
            print("Current ID is empty")
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: {
                timer in
                print("checking if value changed")
                if !Profile.current.id.isEmpty {
                    print("value changed!")
                    self.userAccount = Profile.current
                    self.reloadData()
                    timer.invalidate()
                }
            })
        } else {
            print("Data is loaded: reloading controller")
            self.userAccount = Profile.current
            reloadData()
        }
        
    }
    
    @objc func reloadFullPage() {
        loadAllContent()
        reload.endRefreshing()
    }
    
    func loadAllContent() {
        print("Reloading all content on profile.")
        allowModification = false
        Profile.attemptLoadCurrent(completion: {
            success in
            print("Attempting to load current")
            if success {
                print("great success")
                self.userAccount = Profile.current
                
                self.reloadData()
                
                print("### Loaded all profile data. \(Profile.current.local_tag)")
            } else {
                self.allowModification = true
                print("### An error occurred retrieving profile information")
            }
        })
        
    }
    
    func reloadData() {
        
        self.userTag.text = self.userAccount.local_tag
        self.userFullname.text = self.userAccount.name
        self.userBio.text = self.userAccount.bio
        self.userPicture.image = self.userAccount.picture
        self.userBanner.image = self.userAccount.banner
        
        self.platformTableView.reloadData()
        allowModification = true
    }
}
