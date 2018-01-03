//
//  Path+CoreDataProperties.swift
//  DoggyTime
//
//  Created by Spaceman on 03/01/2018.
//  Copyright © 2018 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData


extension Path {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Path> {
        return NSFetchRequest<Path>(entityName: "Path")
    }

    @NSManaged public var pathpoint: String?
    @NSManaged public var pathFor: Map?

}
