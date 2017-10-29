//
//  Route.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 29/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class Route
{
    //MARK:-Properties
    var routeId: Int
    var name: String
    var terrain: String
    var distance: Float
    var duration: Float
    var picture: UIImage?
    
    //MARK:- Initialisation
    init?(routeId: Int, name: String, terrain: String, distance: Float, duration: Float)
    {
        //MARK:- Initialise Properties
        self.routeId = routeId
        self.name = name
        self.terrain = terrain
        self.distance = distance
        self.duration = duration
        //self.picture = picture
    }
}
