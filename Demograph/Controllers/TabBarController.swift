//
//  TabBarController.swift
//  Demograph
//
//  Created by iMac on 27/4/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for item in tabBar.items! {
            item.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
