//
//  PublishController.swift
//  Demograph-Prototype
//
//  Created by Frederick Holland on 24/04/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class PublishController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TagSearchDelegate {
    
    func onCompleteDataInput(data: [String]) {
        createdClip.tags = data
        createdClip.save()
        
        DGAlert.alert(withTitle: "Success!", message: "Sucessfully created ad.", controller: self)
        urlField.text = ""
        titleField.text = ""
    }
    
    
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
    
    var createdClip: Clip = Placeholders.emptyClip
    
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
                DGAlert.errorAlert(with: 202, controller: self)
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
            DGAlert.errorAlert(with: 301, controller: self)
            return
        }
        
        guard let url = urlField.text, !url.isEmpty else {
            // The url field is EMPTY
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        
        guard let title = titleField.text, !title.isEmpty else {
            // The title field is EMPTY
            DGAlert.errorAlert(with: 101, controller: self)
            return
        }
        
        if Profile.current.clips?.count == 5 {
            DGAlert.errorAlert(with: 501, controller: self)
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
                (clip, success) in
                
                if !success {
                    DGAlert.errorAlert(with: 107, controller: self)
                    return
                }
                
                // Add 'clip' to users [Clip] array.
                clip.title = title
                clip.publisher = Profile.current.id
                clip.date = DGTime.getDate()
                //var currentClips = Profile.current.clips
                //currentClips?.append(clip.id)
                //Profile.current.clips = currentClips
                clip.save()
                self.createdClip = clip
                self.openClipTagSelection()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                            DGAlert.errorAlert(with: 204, controller: self)
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
                self.createdClip = clip
                self.openClipTagSelection()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                            DGAlert.errorAlert(with: 204, controller: self)
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
                self.createdClip = clip
                self.openClipTagSelection()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                            DGAlert.errorAlert(with: 204, controller: self)
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
                self.createdClip = clip
                self.openClipTagSelection()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                            DGAlert.errorAlert(with: 204, controller: self)
                        }
                })
            }
        case .Youtube:
            //
            API.getYoutubeClip(id: url, publisher: platform) {
                (clip, success) in
                
                if !success {
                    DGAlert.errorAlert(with: 107, controller: self)
                    return
                }
                
                clip.title = title
                clip.publisher = Profile.current.id
                clip.date = DGTime.getDate()
                var currentClips = Profile.current.clips
                currentClips?.append(clip.id)
                Profile.current.clips = currentClips
                clip.save()
                self.createdClip = clip
                self.openClipTagSelection()
                
                Profile.attemptSaveCurrent(completion:
                    { (success) in
                    
                        if success {
                            print("Successfully uploaded post.")
                        } else {
                            print("Error uploading post.")
                            DGAlert.errorAlert(with: 204, controller: self)
                        }
                })
            }
        default:
            print("This platform is not configured to share content.")
            return
        }
    }
    
    @IBAction func helpPressed(_ sender: Any) {
        DGAlert.alert(withTitle: "What's a Media ID?", message: "A media ID is the unique string that follows the URL. For example: The post www.instagram.com/p/B_SWjMrFllU/ has a media ID of B_SWjMrFllU", controller: self)
    }
    
    func openClipTagSelection() {
        let search = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tagSearchController") as! TagSearchController
        search.delegate = self
        search.selected = []
        
        self.present(search, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
