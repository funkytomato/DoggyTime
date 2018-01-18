//
//  Dog+CoreDataProperties.swift
//  
//
//  Created by Spaceman on 18/01/2018.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var breed: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var dogName: String?
    @NSManaged public var gender: String?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var size: String?
    @NSManaged public var temperament: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: String?
    @NSManaged public var walkCount: Int16
    @NSManaged public var owner: Client?
    @NSManaged public var walking: Walk?

}
