//
//  LocationManager.swift
//  DoggyTime
//
//  Created by Spaceman on 17/01/2018.
//  Copyright © 2018 Jason Fry. All rights reserved.
//

import CoreLocation

class LocationManager
{
    static let shared = CLLocationManager()
    
    private init()
    {
        print("Location Manager init")
        
        
        LocationManager.shared.desiredAccuracy = kCLLocationAccuracyBest
        //LocationManager.shared.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

        LocationManager.shared.activityType = .fitness
        LocationManager.shared.distanceFilter = 10
        LocationManager.shared.startUpdatingLocation()
        LocationManager.shared.startUpdatingHeading()
    }
}
