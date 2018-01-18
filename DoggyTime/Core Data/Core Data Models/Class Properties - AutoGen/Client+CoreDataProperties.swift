//
//  Client+CoreDataProperties.swift
//  
//
//  Created by Spaceman on 18/01/2018.
//
//

import Foundation
import CoreData


extension Client {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var eMail: String?
    @NSManaged public var foreName: String?
    @NSManaged public var mobile: String?
    @NSManaged public var postCode: String?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var street: String?
    @NSManaged public var surName: String?
    @NSManaged public var town: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var uuid: String?
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
