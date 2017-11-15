//
//  DogsViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 23/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import CoreData


class DogsViewController: UITableViewController
{
    //MARK:- Properties
    var coreDataManager: CoreDataManager!
    var coreDataManagerDelegate: CoreDataManagerDelegate!
    var dogs = [Dog]()
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Dog> =
    {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    required init?(coder aDecoder: NSCoder)
    {
        print("init DogsViewController")
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad()
    {
        print("DogsViewController viewDidLoad")
        super.viewDidLoad()
        
        //Fetch dogs from CoreData
        do
        {
            try fetchedResultsController.performFetch()
        }
        catch
        {
            let fetchError = error as NSError
            print("Unable to Save Dog")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        //tableView.estimatedRowHeight = 80
        //tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("DogsViewController prepare segue")
        if let profileViewController = segue.destination as? DogProfileViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            //Load an existing dog profile

            // Fetch Client
            let selectedDog = fetchedResultsController.object(at: indexPath)
            
            //Configure View Controller
            profileViewController.dogData = selectedDog
        }
        else if let profileViewController = segue.destination as? DogProfileViewController
        {
            //Create a new Dog profile
            let dog = Dog(context: coreDataManager.mainManagedObjectContext)
            
            dog.dogName = ""
            dog.gender = ""
            dog.breed = ""
            dog.size = ""
            dog.profilePicture = nil
            //dog.gender = "Male"
            //dog.breed = "Unknown"
            //dog.size = "Medium"
            
            profileViewController.dogData = dog
        }
    }
}


//MARK:- IBActions
extension DogsViewController
{
    @IBAction func cancelToDogsViewController(_ segue: UIStoryboardSegue) { print("Back in the DogsViewController")}
    
    @IBAction func saveDogDetail(_ segue: UIStoryboardSegue)
    {
        print("DogsViewController saveDogDetail")
        guard let profileViewController = segue.source as? DogProfileViewController,
            let dog = profileViewController.dogData else
        {
            return
        }
        
        //Store to CoreData
        do
        {
            try dog.managedObjectContext?.save()
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Dog")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
}

extension DogsViewController: NSFetchedResultsControllerDelegate
{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type)
        {
        case .insert:
            if let indexPath = newIndexPath
            {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? DogsCell
            {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath
            {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
}


//MARK:- UITableViewDataSource
extension DogsViewController
{
    
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("DogsViewController cellForRowAt")
        
        // Fetch Dog
        let dog = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogsCell", for: indexPath) as! DogsCell
        
        //Configure Cell
        cell.dog = dog
        //configureCell(cell, at: indexPath)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        guard editingStyle == .delete else { return }
        
        // Fetch Dog
        let dog = fetchedResultsController.object(at: indexPath)
        
        // Delete Dog
        fetchedResultsController.managedObjectContext.delete(dog)
    }
    
    
    func configureCell(_ cell: DogsCell, at indexPath: IndexPath)
    {
        // Fetch Dog
        let dog = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.dog = dog
    }
}


//MARK:- CoreDataManager Protocol
extension DogsViewController: CoreDataManagerDelegate
{
    
    func setCoreDataManager(coreDataManager: CoreDataManager)
    {
        self.coreDataManager = coreDataManager
    }
}


/*
extension DogsViewController: AddDogViewControllerDelegate
{
    
    func controller(_ controller: DogProfileViewController, didAddDog dogname: String)
    {
        
        // Create Dog
        let dog = Dog(context: coreDataManager.mainManagedObjectContext)
        
        // Populate Dog
        dog.dogName = ""
        dog.breed = ""
        dog.size = ""
        dog.gender = ""
        dog.profilePicture = nil
        dog.updatedAt = NSDate()
        dog.createdAt = NSDate()
        
        do
        {
            try dog.managedObjectContext?.save()
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Dog")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
}
 */
