//
//  Map+CoreDataProperties.swift
//  
//
//  Created by Spaceman on 26/01/2018.
//
//

import Foundation
import CoreData


extension Map {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Map> {
        return NSFetchRequest<Map>(entityName: "Map")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var midLatitudeCoordinate: Double
    @NSManaged public var midLongitudeCoordinate: Double
    @NSManaged public var name: String?
    @NSManaged public var overlayBottomLeftCoordinate: Double
    @NSManaged public var overlayBottomRightCoordinate: Double
    @NSManaged public var overlayTopLeftCoordinate: Double
    @NSManaged public var overlayTopRightCoordinate: Double
    @NSManaged public var regionRadius: Double
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: String?
    @NSManaged public var mapFor: Route?
    @NSManaged public var paths: NSSet?
    @NSManaged public var pointsofinterest: NSSet?

}

// MARK: Generated accessors for paths
extension Map {

    @objc(addPathsObject:)
    @NSManaged public func addToPaths(_ value: Path)

    @objc(removePathsObject:)
    @NSManaged public func removeFromPaths(_ value: Path)

    @objc(addPaths:)
    @NSManaged public func addToPaths(_ values: NSSet)

    @objc(removePaths:)
    @NSManaged public func removeFromPaths(_ values: NSSet)

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
