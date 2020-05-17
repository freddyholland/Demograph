//
//  TagSearchController.swift
//  Demograph
//
//  Created by iMac on 29/4/20.
//  Copyright © 2020 Frederick Holland. All rights reserved.
//

import UIKit

class TagSearchController: UITableViewController {
    
    var selected: [String]! = []
    var toDisplay: [String] = []
    var tags: [String]! = ["United States", "Canada", "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and/or Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Cook Islands", "Costa Rica", "Croatia (Hrvatska)", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecudaor", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France, Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard and Mc Donald Islands", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Israel", "Italy", "Ivory Coast", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kosovo", "Kuwait", "Kyrgyzstan", "Lao People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of", "Monaco", "Mongolia", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfork Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia South Sandwich Islands", "South Sudan", "Spain", "Sri Lanka", "St. Helena", "St. Pierre and Miquelon", "Sudan", "Suriname", "Svalbarn and Jan Mayen Islands", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States minor outlying islands", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City State", "Venezuela", "Vietnam", "Virigan Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zaire", "Zambia", "Zimbabwe"]
    
    var loadSuggestions: Bool = false
    var presentingController: TagSearchDelegate!
    
    var delegate: TagSearchDelegate?
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.returnKeyType = .continue
        searchbar.delegate = self
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if loadSuggestions {
            return toDisplay.count
        } else {
            return selected.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check if there are results loaded from the search bar.
        // If not, then no data will be displayed.
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCell
        
        var tag: String!
        if loadSuggestions {
            tag = toDisplay[indexPath.row]
        } else {
            tag = selected[indexPath.row]
        }
            
        cell.tagNameField.text = tag
            
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get the tag that has been selected
        var selectedTag: String
        if loadSuggestions
        {
            selectedTag = toDisplay[indexPath.row].lowercased()
        } else
        {
            selectedTag = selected[indexPath.row].lowercased()
        }
        
        selectTag(tag: selectedTag)
    }
    
    func selectTag(tag: String)
    {
        // Attempt to add the tag to the selected array.
        if selected.contains(tag)
        {
            // If the array already contains the tag then remove any instances of it.
            selected = selected.filter({ $0.lowercased() != tag.lowercased() })
            print("The selected tag was already in SELECTED array, removed it.")
        } else
        {
            // If the array doesn't contain the tag then add it.
            selected.append(tag)
            print("Added the selected tag to SELECTED array.")
        }
        
        searchbar.text = ""
        tableView.reloadData()
    }
    
    // MARK: - Search view controller

}

extension TagSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        // Called when the entered text changes.
        
        // Get the current string value of the search bar.
        // = searchText
        
        // Read the current text and filter all tags based on this.
        // Note: It might be worth only downloading relevant tags after 3-4 characters are entered in the field.
        
        if searchText.count < 3
        {
            // There are less than 3 characters in the field
            // Therefore; show pre-exising tags
            loadSuggestions = false
        } else
        {
            // There are 3 or more characters in the field
            // Therefore; show suggestions
            loadSuggestions = true
            toDisplay = tags.filter({ $0.prefix(searchText.count) == searchText })
        }
        
        // Display the newly added data.
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        // Check if the string in the searchbar is valid.
        guard let tag = searchBar.text?.lowercased(), !tag.isEmpty else
        {
            // If its not then return.
            return
        }
        
        // Otherwise add the tag and reset the searchbar.
        selectTag(tag: tag)
        searchBar.text = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        
        // The cancel button has been pressed on the searchbar.
        // Using the delegate; return the data in the table.
        delegate?.onCompleteDataInput(data: selected)
        
        // Then dismiss the controller.
        self.dismiss(animated: true, completion: nil)
        
    }
}
