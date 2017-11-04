//
//  Route+CoreDataClass.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 04/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Route)
public class Route: NSManagedObject
{

}

extension Route
{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route>
    {
        return NSFetchRequest<Route>(entityName: "Route")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var terrain: String?
    @NSManaged public var distance: Float
    @NSManaged public var duration: Float
    
}
