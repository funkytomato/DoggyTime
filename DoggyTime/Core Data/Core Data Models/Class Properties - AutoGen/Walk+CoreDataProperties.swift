//
//  Walk+CoreDataProperties.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 09/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var dateofwalk: Date?
    @NSManaged public var dogid: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var locationName: String?
    @NSManaged public var longitude: Double
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var dogsonwalk: NSSet?
    @NSManaged public var routeName: Route?

}

// MARK: Generated accessors for dogsonwalk
extension Walk {

    @objc(addDogsonwalkObject:)
    @NSManaged public func addToDogsonwalk(_ value: Dog)

    @objc(removeDogsonwalkObject:)
    @NSManaged public func removeFromDogsonwalk(_ value: Dog)

    @objc(addDogsonwalk:)
    @NSManaged public func addToDogsonwalk(_ values: NSSet)

    @objc(removeDogsonwalk:)
    @NSManaged public func removeFromDogsonwalk(_ values: NSSet)

}
