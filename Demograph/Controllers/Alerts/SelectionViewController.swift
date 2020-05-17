//
//  SelectionViewController.swift
//  Demograph
//
//  Created by iMac on 13/5/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    
    
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    
    var delegate: InputAlertDelegate!
    var headingString: String!
    var messageString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headingLabel.text = headingString
        self.messageLabel.text = messageString
    }
    
    public static func instantiate() -> SelectionViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "inputAlertView") as! SelectionViewController
    }
    
    @IBAction func falsePressed(_ sender: Any) {
        delegate.onBooleanInput(result: false)
    }
    
    @IBAction func truePressed(_ sender: Any) {
        delegate.onBooleanInput(result: true)
    }
    
}
