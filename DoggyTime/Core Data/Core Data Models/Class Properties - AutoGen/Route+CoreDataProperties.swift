//
//  Route+CoreDataProperties.swift
//  
//
//  Created by Spaceman on 18/01/2018.
//
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var placeName: String?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var terrain: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: String?
    @NSManaged public var mapProfile: Map?
    @NSManaged public var walks: Walk?

}
