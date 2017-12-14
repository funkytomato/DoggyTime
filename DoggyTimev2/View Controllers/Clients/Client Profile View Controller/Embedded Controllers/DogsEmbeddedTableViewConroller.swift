//
//  DogsEmbeddedTableViewConroller.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 17/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import CoreData


class DogsEmbeddedTableViewConroller: UITableViewController
{
   
    
    @IBOutlet var dogListView: UITableView!
    
    /*
    @IBOutlet var dogListView: UITableView!
    {
        didSet
        {
            dogListView.dataSource = self
        }
    }
 */
 
    //MARK:- Properties
    //var dogs: [Dog]?
    var dogs = [Dog]()
    var coreDataManager: CoreDataManager!
    var coreDataManagerDelegate: CoreDataManagerDelegate!
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Dog> =
    {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        print("fetchRequest:\(fetchRequest.description)")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        print("fetchedResultsCOntroller\(fetchedResultsController.description)")
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    fileprivate var hasDogs: Bool
    {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return false }
        return fetchedObjects.count > 0
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        print("DogsEmbeddedTableViewController init dogs =\(dogs)")
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad()
    {
        print("DogsEmbeddedTableViewConroller viewDidLoad")
        super.viewDidLoad()
        
        //Fetch dogs from CoreData
        do
        {
            try fetchedResultsController.performFetch()
        }
        catch
        {
            let fetchError = error as NSError
            print("Unable to get Dogs")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        
        dogListView.estimatedRowHeight = 40
        dogListView.rowHeight = UITableViewAutomaticDimension
        dogListView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}


extension DogsEmbeddedTableViewConroller: NSFetchedResultsControllerDelegate
{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        dogListView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        dogListView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type)
        {
        case .insert:
            if let indexPath = newIndexPath
            {
                dogListView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath
            {
                dogListView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = dogListView.cellForRow(at: indexPath) as? DogNameCell
            {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath
            {
                dogListView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath
            {
                dogListView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
}


//MARK:- UITableViewDataSource
extension DogsEmbeddedTableViewConroller
{
    
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("DogsEmbeddedTableViewConroller numberOfRowsInSection")
        //return self.dogs!.count
        
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {      
        print("DogsEmbeddedTableView Controller cellForRowAt")
        /*
        let cell = dogListView.dequeueReusableCell(withIdentifier: "DogNameCell", for: indexPath) as! DogNameCell
        let dog  = dogs![indexPath.row]
        cell.dogname = dog.dogName
        return cell
        */
        
        // Fetch Dog
        let dog = fetchedResultsController.object(at: indexPath)
        
        let cell    = dogListView.dequeueReusableCell(withIdentifier: "DogNameCell", for: indexPath) as! DogNameCell
        cell.dogname = dog.dogName
        //configureCell(cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Fetch Dog
        let dog = fetchedResultsController.object(at: indexPath)
        
        // Delete Dog
        fetchedResultsController.managedObjectContext.delete(dog)
    }
    
    
    func configureCell(_ cell: DogNameCell, at indexPath: IndexPath)
    {
        // Fetch Dog
        let dog = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.dogname = dog.dogName
    }
}

//MARK:- CoreDataManager Protocol
extension DogsEmbeddedTableViewConroller: CoreDataManagerDelegate
{
    
    func setCoreDataManager(coreDataManager: CoreDataManager)
    {
        self.coreDataManager = coreDataManager
    }
}
