//
//  Dog+CoreDataClass.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 04/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dog)
public class Dog: NSManagedObject
{

}

extension Dog
{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog>
    {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }
    
    @NSManaged public var dogname: String?
    @NSManaged public var gender: String?
    @NSManaged public var size: String?
    @NSManaged public var breed: String?
    @NSManaged public var dogpicture: NSData?
    @NSManaged public var walkcount: Int16
    
}
