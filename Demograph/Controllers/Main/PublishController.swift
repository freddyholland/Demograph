//
//  PublishController.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 24/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class PublishController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleField.delegate = self
        urlField.delegate = self
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        guard let title = titleField.text, !title.isEmpty else {
            // The title field is EMPTY
            return
        }
        
        guard let url = urlField.text, !url.isEmpty else {
            // The url field is EMPTY
            return
        }
        
        if !url.starts(with: "https://") {
            // The set url doesn't begin with 'https://'
            return
        }
        
        let platform = Platform.determinePlatformFrom(url_string: url)
        /*
         URL: url
         TITLE: title
         DATE: get date from system
         TIME: get time from system
         PLATFORM: platform
         PLATFORMTAG: -
         ID: find next available id
         TAGS: -
         VOTES: N/A
         */
        let clip = Clip(url: url, title: title, date: "", time: "", platform: platform, platformTag: "", id: 0, thumbnail: "", tags: [], votes: [])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
