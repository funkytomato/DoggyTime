//
//  Map+CoreDataProperties.swift
//  DoggyTime
//
//  Created by Spaceman on 12/01/2018.
//  Copyright © 2018 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData


extension Map {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Map> {
        return NSFetchRequest<Map>(entityName: "Map")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var midLatitudeCoordinate: String?
    @NSManaged public var midLongitudeCoordinate: String?
    @NSManaged public var name: String?
    @NSManaged public var overlayBottomLeftCoordinate: String?
    @NSManaged public var overlayBottomRightCoordinate: String?
    @NSManaged public var overlayTopLeftCoordinate: String?
    @NSManaged public var overlayTopRightCoordinate: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var uuid: String?
    @NSManaged public var mapFor: Route?
    @NSManaged public var path: NSSet?
    @NSManaged public var pointsofinterest: NSSet?

}

// MARK: Generated accessors for path
extension Map {

    @objc(addPathObject:)
    @NSManaged public func addToPath(_ value: Path)

    @objc(removePathObject:)
    @NSManaged public func removeFromPath(_ value: Path)

    @objc(addPath:)
    @NSManaged public func addToPath(_ values: NSSet)

    @objc(removePath:)
    @NSManaged public func removeFromPath(_ values: NSSet)

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
