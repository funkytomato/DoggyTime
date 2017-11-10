//
//  SecondViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 15/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit
import CoreData


class WalksViewController: UITableViewController
{

    //MARK:- Properties
    
    var coreDataManager: CoreDataManager!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Walk> =
    {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Walk> = Walk.fetchRequest()
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    //Data to send to detail controller
    var walks = [Walk]()
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("WalksViewController viewDidLoad")
        super.viewDidLoad()
        
        
        do
        {
            try fetchedResultsController.performFetch()
        }
        catch
        {
            let fetchError = error as NSError
            print("Unable to Save Walk")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
  /*
        // Do any additional setup after loading the view, typically from a nib.
        let fetchRequest: NSFetchRequest<Walk> = Walk.fetchRequest()
        
        do
        {
            let walks = try PersistentService.context.fetch(fetchRequest)
            self.walks = walks
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.reloadData()
        }
        catch {}
*/
    }

    override func didReceiveMemoryWarning()
    {
        print("WalksViewController didRecieveMemoryWarning")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("WalksViewController prepare segue")
        if let profileViewController = segue.destination as? WalkProfileTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            //Load an existing Walk profile
            
            let selectedWalk = walks[indexPath.row]
            profileViewController.walkData = selectedWalk
        }
        else if let profileViewController = segue.destination as? WalkProfileTableViewController
        {
            //Create a new Walk profile
        
            let walk = Walk(context: coreDataManager.mainManagedObjectContext)
            //walk.locationName = "Enter location name"
            
            //Populate Walk
            
            //Set the current date and time
            let date = Date()
            walk.dateofwalk = date
            
            walk.latitude = 0.0
            walk.longitude = 0.0
            
            profileViewController.walkData = walk
            
        }
    }
}

// MARK:- IBActions
extension WalksViewController
{
    @IBAction func cancelToWalksViewController(_ segue: UIStoryboardSegue) { print("Back in the WalksViewController")}
    
    @IBAction func saveWalkDetail(_ segue: UIStoryboardSegue)
    {
        print("WalksViewController saveToWalkDetail")
        guard let profileViewController = segue.source as? WalkProfileTableViewController,
            let walk = profileViewController.walkData else
        {
            return
        }
        
        do
        {
            try walk.managedObjectContext?.save()
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Walk")
            print("\(saveError), \(saveError.localizedDescription)")
        }
        
        /*
        //Store to CoreData
        PersistentService.saveContext()
        walks.append(walk)
        self.tableView.reloadData()
 */
    }
}

extension WalksViewController: NSFetchedResultsControllerDelegate
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? WalkCell
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
extension WalksViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return walks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("WalksViewController cellForRowAt")
        // Fetch Walk
        let walk = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalkIdentificationCell", for: indexPath) as! WalkIdentificationCell
        //let walk = walks[indexPath.row]
        cell.walk = walk
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Fetch Walk
        let walk = fetchedResultsController.object(at: indexPath)
        
        // Delete Walk
        fetchedResultsController.managedObjectContext.delete(walk)
    }
    
    func configureCell(_ cell: WalkCell, at indexPath: IndexPath)
    {
        // Fetch Walk
        let walk = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.walk = walk
    }
}

extension WalksViewController: AddWalkViewControllerDelegate
{
    
    func controller(_ controller: WalkProfileTableViewController, didAddWalk name: String)
    {
        
        // Create Client
        let walk = Walk(context: coreDataManager.mainManagedObjectContext)
        
        // Populate Note
        //client.foreName = ""
        //client.surName = ""
        //client.street = ""
        //client.updatedAt = NSDate()
        //client.createdAt = NSDate()
        
        do
        {
            try walk.managedObjectContext?.save()
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Client")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
    
}

