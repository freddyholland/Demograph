//
//  AdManagerTableView.swift
//  Demograph
//
//  Created by iMac on 13/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AdManagerTableView: UITableViewController {
    
    var ads: [Clip] = []

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
        
        cell.clipTitleLabel.text = ad.title
        cell.clipTitleLabel.text = ad.url
        cell.platformIconImageView.image = UIImage(named: "\(ad.platform.rawValue.lowercased())")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ad = ads[indexPath.row]
        print("selected \(ad.platform) ad, titled: \(ad.title)")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func reloadData() {
        Firestore.firestore().collection("clips").whereField("id", in: Profile.current.clips!).getDocuments
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
