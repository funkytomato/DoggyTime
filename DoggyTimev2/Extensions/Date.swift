//
//  Date.swift
//  DoggyTimev2
//
//  Created by Spaceman on 06/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import Foundation

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
        
        let hourformatter = DateFormatter()
        hourformatter.dateFormat = "h a"
        hourformatter.amSymbol = "AM"
        hourformatter.pmSymbol = "PM"
        return hourformatter.string(from: self)
    }
}

/*
 
 let date = Date()
 let calendar = Calendar.current
 let components = calendar.dateComponents([.year, .month, .day], from: date)
 
 let year =  components.year
 let month = components.month
 let day = components.day
 
 */
