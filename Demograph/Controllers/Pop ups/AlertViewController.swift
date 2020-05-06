//
//  AlertViewController.swift
//  Demograph
//
//  Created by iMac on 6/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var alertBar: UIView!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var messageTextField: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    
    var titleString: String!
    var messageString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleTextField.text = titleString
        messageTextField.text = messageString
    }
    
    static func instantiate() -> AlertViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "alertController") as! AlertViewController
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
