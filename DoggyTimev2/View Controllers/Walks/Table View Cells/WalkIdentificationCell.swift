//
//  WalkIdentificationCell.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 27/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class WalkIdentificationCell: UITableViewCell
{
    //MARK:- IBOutlets
    @IBOutlet weak var walkIdLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    var walk: Walk?
    {
         didSet
         {
            guard let walk = walk else {return}
            
            self.walkIdLbl.text = walk.walkid.description
            self.timeLbl.text = walk.dateofwalk?.hourOfDay()
            self.dayLbl.text = walk.dateofwalk?.dayOfWeek()
            self.locationLbl.text = walk.locationname
            
            print(walk.dateofwalk?.dayOfWeek()! as Any)
            
         }
    }
}
