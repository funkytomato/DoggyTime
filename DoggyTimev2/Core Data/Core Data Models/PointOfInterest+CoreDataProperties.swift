//
//  PointOfInterest+CoreDataProperties.swift
//  
//
//  Created by Jason Fry on 30/12/2017.
//
//

import Foundation
import CoreData


extension PointOfInterest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PointOfInterest> {
        return NSFetchRequest<PointOfInterest>(entityName: "PointOfInterest")
    }

    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var type: Int16
    @NSManaged public var locatedAt: Map?

}
