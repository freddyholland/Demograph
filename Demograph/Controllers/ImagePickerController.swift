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
            profile.picture = image
            print("ID'd as case 1 - modification successful, attempting to save profile")
            Account.savePicture(profile: profile)
        case 2:
            // Change banner picture.
            let profile = Profile.current
            profile.banner = image
            Account.saveBanner(profile: profile)
        default:
            print("No value")
        }
        imageView.image = image
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
