//
//  Client+CoreDataClass.swift
//  DoggyTimev2
//
//  Created by Spaceman on 03/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Client)
public class Client: NSManagedObject
{

}

extension Client
{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client>
    {
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
    
}
