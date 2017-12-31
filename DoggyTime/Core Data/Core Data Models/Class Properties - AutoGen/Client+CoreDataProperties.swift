//
//  Client+CoreDataProperties.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 09/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData


extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var eMail: String?
    @NSManaged public var foreName: String?
    @NSManaged public var mobile: String?
    @NSManaged public var postCode: String?
    @NSManaged public var street: String?
    @NSManaged public var surName: String?
    @NSManaged public var town: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var profilePicture: Data?
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
