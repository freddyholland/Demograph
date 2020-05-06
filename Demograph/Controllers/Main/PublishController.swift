//
//  PublishController.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 24/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class PublishController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Return the users platforms.
        //return (Profile.current.platforms?.count)!
        let platformCount = userAccount.getShareablePlatforms().count
        if platformCount == 0 {
            return 1
        }
        return platformCount;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return Profile.current.platforms![pickerView.selectedRow(inComponent: 1)-1].type.rawValue
        if userAccount.getShareablePlatforms().count == 0 {
            return "You have no advertisable platforms."
        }
        
        return userAccount.getShareablePlatforms()[row].type.rawValue
    }
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    
    var userAccount = Placeholders.userAccount
    var allowModification: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        urlField.delegate = self
        titleField.delegate = self
        
        if Profile.current.id.isEmpty {
            print("Current ID is empty")
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: {
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
        
        self.pickerView.reloadAllComponents()
        allowModification = true
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        
        if !allowModification {
            // Cannot create modifications while data is loading.
            return
        }
        
        if userAccount.getShareablePlatforms().count == 0 {
            print("You do not have any shareable platforms.")
            return
        }
        
        guard let url = urlField.text, !url.isEmpty else {
            // The url field is EMPTY
            return
        }
        
        guard let title = titleField.text, !title.isEmpty else {
            // The title field is EMPTY
            return
        }
        
        print("attempting to get platform type to download data")
        print(pickerView.selectedRow(inComponent: 0))
        print(userAccount.getShareablePlatforms().count)
        
        let platform: Platform = userAccount.getShareablePlatforms()[pickerView.selectedRow(inComponent: 0)]
        
        switch platform.type {
        case .Instagram:
            // API Supported - Publish clip
            API.getInstagramClip(id: url, publisher: platform) {
                (clip) in
                // Add 'clip' to users [Clip] array.
                clip.title = title
                clip.publisher = Profile.current.id
                clip.date = DGTime.getDate()
                var currentClips = Profile.current.clips
                currentClips?.append(clip.id)
                Profile.current.clips = currentClips
                clip.save()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                        }
                })
            }
        case .Soundcloud:
            // API NOT Supported - Continue
            API.getSoundcloudClip(id: url, publisher: platform) {
                (clip) in
                // Add 'clip' to users [Clip] array.
                clip.title = title
                clip.publisher = Profile.current.id
                clip.date = DGTime.getDate()
                var currentClips = Profile.current.clips
                currentClips?.append(clip.id)
                Profile.current.clips = currentClips
                clip.save()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                        }
                })
            }
        case .Spotify:
            // API Supported - Publish Clip
            API.getSpotifyClip(id: url, publisher: platform) {
                (clip) in
                // Add 'clip' to users [Clip] array.
                clip.title = title
                clip.publisher = Profile.current.id
                clip.date = DGTime.getDate()
                var currentClips = Profile.current.clips
                currentClips?.append(clip.id)
                Profile.current.clips = currentClips
                clip.save()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                        }
                })
            }
        case .Twitch:
            // API Supported - Publish Clip
            API.getTwitchClip(id: url) {
                (clip) in
                // Add 'clip' to users [Clip] array.
                clip.title = title
                clip.publisher = Profile.current.id
                clip.date = DGTime.getDate()
                var currentClips = Profile.current.clips
                currentClips?.append(clip.id)
                Profile.current.clips = currentClips
                clip.save()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                        }
                })
            }
        case .Youtube:
            //
            API.getYoutubeClip(id: url, publisher: platform) {
                (clip) in
                
                clip.title = title
                clip.publisher = Profile.current.id
                clip.date = DGTime.getDate()
                var currentClips = Profile.current.clips
                currentClips?.append(clip.id)
                Profile.current.clips = currentClips
                clip.save()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                        }
                })
            }
        default:
            print("This platform is not configured to share content.")
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
