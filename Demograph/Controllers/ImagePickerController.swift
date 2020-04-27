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
        imageView.image = image
    }
    
    var selected: Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: ImagePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func selectPressed(_ sender: UIButton) {
        imagePicker.present(from: sender)
        selected = true
        while !selected {
            // wait for 
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
