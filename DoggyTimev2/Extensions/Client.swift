//
//  Client.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 18/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import CoreData

extension Client
{
/*
    class func getDogsOwned(in managedObjectContext: NSManagedObjectContext) throws -> [Dog]
    {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dog")

        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Add Predicate
        let predicate = NSPredicate(format: "&K = %@", "dog.owner", "client")
        fetchRequest.predicate = predicate

        do
        {
            let records = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        
            for record in records
            {
                print(record.value(forKey: "name") ?? "no name")
            }
            return records
        
        }
        catch
        {
            print(error)
        }
        
        return
    }
 */
}
