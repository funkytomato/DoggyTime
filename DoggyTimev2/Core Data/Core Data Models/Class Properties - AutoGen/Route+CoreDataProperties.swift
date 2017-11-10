//
//  Route+CoreDataProperties.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 09/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var distance: Float
    @NSManaged public var duration: Float
    @NSManaged public var name: String?
    @NSManaged public var terrain: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var profilePicture: NSData?
    @NSManaged public var walks: Walk?

}
