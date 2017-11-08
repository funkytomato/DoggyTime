//
//  Dog+CoreDataProperties.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 08/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var breed: String?
    @NSManaged public var dogname: String?
    @NSManaged public var dogpicture: NSData?
    @NSManaged public var gender: String?
    @NSManaged public var size: String?
    @NSManaged public var walkcount: Int16
    @NSManaged public var owner: Client?
    @NSManaged public var walking: Walk?

}
