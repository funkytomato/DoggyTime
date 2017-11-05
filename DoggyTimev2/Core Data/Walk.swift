//
//  Walk+CoreDataClass.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 04/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Walk)
public class Walk: NSManagedObject
{

}

extension Walk
{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk>
    {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }
    
    @NSManaged public var walkid:Int16
    @NSManaged public var dateofwalk: Date?
    @NSManaged public var locationname: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    
}
