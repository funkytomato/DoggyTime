//
//  WalkCell.swift
//  DoggyTime
//
//  Created by Spaceman on 26/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

class WalkCell: UITableViewCell
{
    //MARK:- IBOutlets
    @IBOutlet weak var walkNoLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dogsOnWalkLabel: UILabel!
    
    var walk: Walk?
    {
        didSet
        {
            guard let walk = walk else {return}
            
            //walkNoLabel.text = walk.walkNo.description
            locationLabel.text = walk.locationName
            //dogsOnWalkLabel.text = walk.dogs.description
        }
    }
}
