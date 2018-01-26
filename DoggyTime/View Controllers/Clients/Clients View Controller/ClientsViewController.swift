//
//  ClientsViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 15/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit
import CoreData


class ClientsViewController: UITableViewController
{
    
    
    //MARK:- Properties
    var coreDataManager: CoreDataManager!
    var coreDataManagerDelegate: CoreDataManagerDelegate!
    var clients = [Client]()
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Client> =
    {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        //print("fetchRequest:\(fetchRequest.description)")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        //print("fetchedResultsCOntroller\(fetchedResultsController.description)")
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad()
    {
        //print("ClientsViewController viewDidLoad")
        super.viewDidLoad()
   
        //Fetch clients from CoreData
        do
        {
            try fetchedResultsController.performFetch()
        }
        catch
        {
            let fetchError = error as NSError
            print("Unable to Save Client")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //print("ClientsViewController prepare segue")
        
        //Create a new Client Profile
        if segue.identifier == "AddClientSegue",
            let profileViewController = segue.destination as? ClientProfileViewController
        {
            //Create a new Client profile
            let client = Client(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Client
            client.foreName = "Bob"
            client.surName = "Marley"
            client.street = "16 The Green"
            client.town = "Pagham"
            client.postCode = "PO21 4WR"
            client.mobile = "07967441749"
            client.eMail = "bob@gmail.com"
            client.createdAt = Date()
            client.updatedAt = Date()
            
            //Configure View Controller
            profileViewController.setCoreDataManager(coreDataManager: coreDataManager)
            profileViewController.clientData = client
        }
        //Load an existing Client Profile
        else if segue.identifier == "ShowClientProfile",
            let profileViewController = segue.destination as? ClientProfileViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {

            // Fetch Client
            let client = fetchedResultsController.object(at: indexPath)
            
            //print("ClientsViewController prepare for client profile: \(client.dogsOwned)")
            
            // Configure View Controller
            profileViewController.setCoreDataManager(coreDataManager: coreDataManager)
            profileViewController.clientData = client
        }
    }
}


// MARK:- IBActions
extension ClientsViewController
{
    
    
    @IBAction func cancelToClientsViewController(_ segue: UIStoryboardSegue)
    {
        //print("Back in the ClientViewController")
        
    }
    
    
    @IBAction func saveClientDetail(_ segue: UIStoryboardSegue)
    {
        //print("ClientsViewController saveClientDetail")
        //print("Segue source\(segue.source)")
        guard let profileViewController = segue.source as? ClientProfileViewController,
            let client = profileViewController.clientData else
        {
            return
        }
        
        //print("\(client.dogsOwned)")
        
        //Store to CoreData
        do
        {
            try client.managedObjectContext?.save()
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Client")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
}


extension ClientsViewController: NSFetchedResultsControllerDelegate
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ClientCell
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


// MARK:- UITableViewDataSource
extension ClientsViewController
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

    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Fetch Client
        let client = fetchedResultsController.object(at: indexPath)
        
        let cell    = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientCell
        cell.client = client
        //configureCell(cell, at: indexPath)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Fetch Client
        let client = fetchedResultsController.object(at: indexPath)
        
        // Delete Client
        fetchedResultsController.managedObjectContext.delete(client)
    }
    
    
    func configureCell(_ cell: ClientCell, at indexPath: IndexPath)
    {
        // Fetch Client
        let client = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.client = client
    }
}

 
//MARK:- CoreDataManager Protocol
extension ClientsViewController: CoreDataManagerDelegate
{
    
    func setCoreDataManager(coreDataManager: CoreDataManager)
    {
        self.coreDataManager = coreDataManager
    }
}


/*
 extension ClientsViewController: AddClientViewControllerDelegate
 {
 
 func controller(_ controller: ClientsDetailViewController, didAddClient forename: String, surname: String)
 {
 
 // Create Client
 let client = Client(context: coreDataManager.managedObjectContext)
 
 // Populate Note
 client.foreName = ""
 client.surName = ""
 client.street = ""
 client.updatedAt = NSDate()
 client.createdAt = NSDate()
 
 do
 {
 try client.managedObjectContext?.save()
 }
 catch
 {
 let saveError = error as NSError
 print("Unable to Save Client")
 print("\(saveError), \(saveError.localizedDescription)")
 }
 }
 }
 */
