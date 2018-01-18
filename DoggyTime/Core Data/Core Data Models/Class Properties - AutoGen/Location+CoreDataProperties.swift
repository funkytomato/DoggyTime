//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Spaceman on 18/01/2018.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timeStamp: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: String?
    @NSManaged public var path: Path?

}
