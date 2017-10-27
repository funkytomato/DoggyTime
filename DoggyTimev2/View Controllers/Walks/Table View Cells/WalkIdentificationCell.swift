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
            
            self.walkIdLbl.text = walk.walkNo.description
            
            self.timeLbl.text = walk.date.hourOfDay()
            
            
            self.dayLbl.text = walk.date.dayOfWeek()
            print(walk.date.dayOfWeek()!)
            

            self.locationLbl.text = walk.locationName
         }
    }
}

extension Date
{
    func dayOfWeek() -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func hourOfDay() -> String?
    {
        //let hour = Calendar.current.component(.hour, from: self)
        
        let hourformatter = DateFormatter()
        hourformatter.dateFormat = "h a"
        hourformatter.amSymbol = "AM"
        hourformatter.pmSymbol = "PM"
        return hourformatter.string(from: self)
    }
}
