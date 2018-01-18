//
//  Walk+CoreDataProperties.swift
//  
//
//  Created by Spaceman on 18/01/2018.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var dateofwalk: Date?
    @NSManaged public var locationName: String?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: String?
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
