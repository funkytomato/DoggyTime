//
//  Route+CoreDataProperties.swift
//  DoggyTimev2
//
//  Created by Spaceman on 15/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var actualDuration: Float
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var actualDistance: Float
    @NSManaged public var durationHrs: Int16
    @NSManaged public var durationMins: Int16
    @NSManaged public var placeName: String?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var terrain: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var distanceMiles: Int16
    @NSManaged public var distanceQtrs: Int16
    @NSManaged public var walks: Walk?

}
