//
//  Map+CoreDataProperties.swift
//  
//
//  Created by Jason Fry on 30/12/2017.
//
//

import Foundation
import CoreData


extension Map {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Map> {
        return NSFetchRequest<Map>(entityName: "Map")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var uuid: String?
    @NSManaged public var boundary: Boundary?
    @NSManaged public var pointsofinterest: NSSet?

}

// MARK: Generated accessors for pointsofinterest
extension Map {

    @objc(addPointsofinterestObject:)
    @NSManaged public func addToPointsofinterest(_ value: PointOfInterest)

    @objc(removePointsofinterestObject:)
    @NSManaged public func removeFromPointsofinterest(_ value: PointOfInterest)

    @objc(addPointsofinterest:)
    @NSManaged public func addToPointsofinterest(_ values: NSSet)

    @objc(removePointsofinterest:)
    @NSManaged public func removeFromPointsofinterest(_ values: NSSet)

}
