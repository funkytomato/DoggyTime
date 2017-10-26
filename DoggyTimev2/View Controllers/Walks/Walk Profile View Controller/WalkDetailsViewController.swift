//
//  WalkDetailsViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 26/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit
import MapKit

class WalkDetailsViewController: UITableViewController
{
    
    //Set visible area for map
    //var region: MKCoordinateRegion
    
    let regionRadius: CLLocationDistance = 1000
    func centreMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK:- Properties
    var walkData: Walk?
    var dogs : [String]
  

    @IBOutlet weak var walkIdField: UILabel!
    @IBOutlet weak var locationNameField: UILabel!
    @IBOutlet weak var longitudeField: UILabel!
    @IBOutlet weak var latitudeField: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dognameField: DogNameCell!

    
    // MARK:- Initialisers
    required init?(coder aDecoder: NSCoder)
    {
        print("init WalkDetailsViewController")
        dogs = ["empty"]
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        print("deinit WalkDetailsViewController")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dogs = (walkData?.dogs)!
        
        walkIdField.text = walkData?.walkNo.description
        locationNameField.text = walkData?.locationName
        latitudeField.text = walkData?.latitude.description
        longitudeField.text = walkData?.longitude.description
        //dognameField.text = walkData?.dogs[0]
        
        //Set location in honolulu
        let initialLocation = CLLocation(latitude: (walkData?.latitude)!, longitude: (walkData?.longitude)!)
        centreMapOnLocation(location: initialLocation)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
