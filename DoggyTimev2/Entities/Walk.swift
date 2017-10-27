//
//  Walk.swift
//  DoggyTime
//
//  Created by Spaceman on 26/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import Foundation


class Walk
{
    // MARK:- Properties
    var walkNo : Int
    var date : Date
    var locationName: String
    var latitude: Double
    var longitude: Double
    var dogs: [String]

    // MARK:- Initialisation
    init?(walkNo: Int, /*date: Date, */locationName: String, latitude: Double, longitude: Double, dogs: [String])
    {
        // MARK:- Initialise Properties
        self.walkNo = walkNo
        self.date = Date.init()
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.dogs = dogs
    }
}
