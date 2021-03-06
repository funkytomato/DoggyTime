//
//  Path+CoreDataProperties.swift
//  
//
//  Created by Spaceman on 26/01/2018.
//
//

import Foundation
import CoreData


extension Path {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Path> {
        return NSFetchRequest<Path>(entityName: "Path")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var distance: Double
    @NSManaged public var duration: Int16
    @NSManaged public var pathPoint: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: String?
    @NSManaged public var locations: NSSet?
    @NSManaged public var pathFor: Map?

}

// MARK: Generated accessors for locations
extension Path {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
