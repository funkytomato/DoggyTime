//
//  Boundary+CoreDataProperties.swift
//  
//
//  Created by Jason Fry on 30/12/2017.
//
//

import Foundation
import CoreData


extension Boundary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Boundary> {
        return NSFetchRequest<Boundary>(entityName: "Boundary")
    }

    @NSManaged public var midCoord: String?
    @NSManaged public var overlayBottomLeftCoord: String?
    @NSManaged public var overlayTopLeftCoord: String?
    @NSManaged public var overlayTopRightCoord: String?
    @NSManaged public var boundaryFor: Map?

}
