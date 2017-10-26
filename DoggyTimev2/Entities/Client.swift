//
//  Client.swift
//  DoggyTime
//
//  Created by Spaceman on 18/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

class Client
{
    // MARK: - Properties
    var forename: String
    var surname: String
    
    var street: String
    var town: String
    var postcode: String
    
    var mobile: String
    var eMail: String
    
    var dogname: String
    var dogpicture: UIImage?
    
    //MARK: Initialisation
    init?(forename: String, surname: String, street: String, town: String, postcode: String, mobile: String, eMail: String, dogname: String, dogpicture: UIImage?)
    {
        //Initilisation should fail if there is no name or properties are empty
 /*      guard forename.isEmpty || surname.isEmpty || street.isEmpty || town.isEmpty || postcode.isEmpty || mobile.isEmpty || eMail.isEmpty || dogname.isEmpty else
           {
            print("Client initialisation failed because not all properties are valid")
            return nil
        }
   */     
        
        //Initialise stored properties
        self.forename = forename
        self.surname = surname
        self.street = street
        self.town = town
        self.postcode = postcode
        self.mobile = mobile
        self.eMail = eMail
        self.dogname = dogname
        self.dogpicture = dogpicture
    }
    

}
