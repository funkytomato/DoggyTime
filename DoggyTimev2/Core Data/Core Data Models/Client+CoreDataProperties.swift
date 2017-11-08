//
//  Client+CoreDataProperties.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 08/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData


extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var dogname: String?
    @NSManaged public var email: String?
    @NSManaged public var forename: String?
    @NSManaged public var mobile: String?
    @NSManaged public var postcode: String?
    @NSManaged public var street: String?
    @NSManaged public var surname: String?
    @NSManaged public var town: String?
    @NSManaged public var dogsOwned: NSSet?

}

// MARK: Generated accessors for dogsOwned
extension Client {

    @objc(addDogsOwnedObject:)
    @NSManaged public func addToDogsOwned(_ value: Dog)

    @objc(removeDogsOwnedObject:)
    @NSManaged public func removeFromDogsOwned(_ value: Dog)

    @objc(addDogsOwned:)
    @NSManaged public func addToDogsOwned(_ values: NSSet)

    @objc(removeDogsOwned:)
    @NSManaged public func removeFromDogsOwned(_ values: NSSet)

}
