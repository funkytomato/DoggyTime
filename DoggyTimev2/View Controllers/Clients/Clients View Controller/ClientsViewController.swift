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
    // MARK:- Properties
    /*
    fileprivate let coreDataManager = CoreDataManager(modelName: "DoggyTimev2")
*/
    
    var coreDataManager: CoreDataManager!
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Client> =
    {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    
    //List of all clients
    var clients = [Client]()
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("ClientsViewController viewDidLoad")
        super.viewDidLoad()
   
        
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
        
        //self.clients = fetchedResultsController.
        //tableView.estimatedRowHeight = 80
        //tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
        
        
        /*
        //Fetch clients from CoreData
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        
        do
        {
            let clients = try PersistentService.context.fetch(fetchRequest)
            self.clients = clients
            //tableView.estimatedRowHeight = 80
            //tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.reloadData()
        }
        catch {}
*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("ClientsViewController prepare segue")
        if let profileViewController = segue.destination as? ClientsDetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            //Load an existing Client profile
            
            // Fetch Client
            let client = fetchedResultsController.object(at: indexPath)
            
            // Configure View Controller
            profileViewController.clientData = client
            
            //let selectedClient = clients[indexPath.row]
            //profileViewController.clientData = selectedClient
        }
        else if let profileViewController = segue.destination as? ClientsDetailViewController
        {
            //Create a new Client profile
            let client = Client(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Client
            client.foreName = ""
            client.surName = ""
            client.street = ""
            client.town = ""
            client.postCode = ""
            client.mobile = ""
            client.eMail = ""
            //client.dogame = ""
            
            profileViewController.clientData = client
        }
    }
}


// MARK:- IBActions
extension ClientsViewController
{
    
    @IBAction func cancelToClientsViewController(_ segue: UIStoryboardSegue)
    {
        print("Back in the ClientViewController")
        
    }
    
    @IBAction func saveClientDetail(_ segue: UIStoryboardSegue)
    {
        print("ClientsViewController saveClientDetail")
        print("Segue source\(segue.source)")
        guard let profileViewController = segue.source as? ClientsDetailViewController,
            let client = profileViewController.clientData else
        {
            return
        }
        
        //Store to CoreData
        //let client =  Client(context: coreDataManager.mainManagedObjectContext)
        
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
        
        /*
        PersistentService.saveContext()
        clients.append(client)
        self.tableView.reloadData()
        */
    }
}

extension ClientsViewController: NSFetchedResultsControllerDelegate
{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
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
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
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
        //let client  = clients[indexPath.row]
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

/*
extension ClientsViewController: UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
 */

extension ClientsViewController: AddClientViewControllerDelegate
{
    
    func controller(_ controller: ClientsDetailViewController, didAddClient forename: String, surname: String)
    {

        // Create Client
        let client = Client(context: coreDataManager.mainManagedObjectContext)
        
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

