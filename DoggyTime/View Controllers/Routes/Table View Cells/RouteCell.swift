//
//  RouteCell.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 29/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell
{
    //MARK:- IBOutlets
    @IBOutlet weak var routeNameLbl: UILabel!
    //@IBOutlet weak var terrainLbl: UILabel!
    //@IBOutlet weak var durationLbl: UILabel!
    //@IBOutlet weak var distanceLbl: UILabel!
    
    var route: Route?
    {
        didSet
        {
            guard let route = route else {return}
            
            routeNameLbl.text = route.placeName
            //routeNameLbl.text = "something"
            //terrainLbl.text = route.map
            //terrainLbl.text = route.terrain
            //distanceLbl.text = route.distanceMiles.description + " miles " + route.distanceQtrs.description
            //durationLbl.text = route.durationHrs.description + " hrs" + route.durationMins.description
           // route.picture = route.picture
        }
    }
    
    func image(imageName: String?) -> UIImage?
    {
        return UIImage(named: imageName!)
    }
}
