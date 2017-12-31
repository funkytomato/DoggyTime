//
//  DogNameCell.swift
//  DoggyTime
//
//  Created by Spaceman on 16/10/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

class DogNameCell : UITableViewCell
{
    
    @IBOutlet weak var dognameLabel: UITextField!
    
    
    var dogname: String?
    {
        didSet
        {
            guard let dogname = dogname else {return}
            dognameLabel.text = dogname
        }
    }
}
