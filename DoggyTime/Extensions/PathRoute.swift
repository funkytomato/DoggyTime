//
//  PathRoute.swift
//  DoggyTime
//
//  Created by Spaceman on 26/01/2018.
//  Copyright © 2018 Jason Fry. All rights reserved.
//

import CoreLocation

struct PathRoute
{
    var name: String
    var pathPoints : [CLLocation] = []
    
    //Initialise the struct
    init(pathName: String, points: [CLLocation])
    {
        self.name = pathName
        self.pathPoints = points
    }
}
