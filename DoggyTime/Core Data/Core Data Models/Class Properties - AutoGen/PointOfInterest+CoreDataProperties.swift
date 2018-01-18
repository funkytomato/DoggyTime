//
//  PointOfInterest+CoreDataProperties.swift
//  
//
//  Created by Spaceman on 18/01/2018.
//
//

import Foundation
import CoreData


extension PointOfInterest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PointOfInterest> {
        return NSFetchRequest<PointOfInterest>(entityName: "PointOfInterest")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var type: Int16
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: String?
    @NSManaged public var locatedAt: Location?
    @NSManaged public var onMap: Map?

}
