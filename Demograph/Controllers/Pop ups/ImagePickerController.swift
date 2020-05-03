//
//  ImagePickerController.swift
//  Demograph
//
//  Created by Frederick Holland on 27/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class ImagePickerController: UIViewController, ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        // Image has been selected.
        switch id {
        case 1:
            // Change profile picture.
            let profile = Profile.current
            print("### Supposed ID: " + profile.id)
            profile.picture = image
            print("ID'd as case 1 - modification successful, attempting to save picture")
            Bucket.saveUserPicture(profile: profile)
        case 2:
            // Change banner picture.
            let profile = Profile.current
            print("Attempting to save banner to " + profile.id)
            profile.banner = image
            print("ID'd as case 2 - modification successful, attempting to save banner")
            Bucket.saveUserBanner(profile: profile)
        default:
            print("No value")
        }
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    var id: Int = 0
    var instance: SettingsTableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func selectPressed(_ sender: UIButton) {
        imagePicker.present(from: sender)
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
