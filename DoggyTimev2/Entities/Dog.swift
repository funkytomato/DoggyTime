//
//  Dog.swift
//  DoggyTime
//
//  Created by Spaceman on 17/10/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

class Dog
{
    //MARK:- Properties
    var dogName : String
    var breed : String
    var sex: String
    var size : String
    var picture : UIImage?
    
    //MARK:- Initialisation
    init?(dogname: String, breed: String, sex: String, size: String, picture: UIImage?)
    {
        //MARK:- Initialisation Properties
        self.dogName = dogname
        self.breed = breed
        self.sex = sex
        self.size = size
        self.picture = picture
    }
}
