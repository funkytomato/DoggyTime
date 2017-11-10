//
//  RoutesViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 29/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import CoreData

class RoutesViewController: UITableViewController
{
    
    //MARK:- Properties
    
    var coreDataManager: CoreDataManager!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Route> =
    {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Route> = Route.fetchRequest()
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    //Data to send to profile controller
    var routes = [Route]()
    
    required init?(coder aDecoder: NSCoder)
    {
        print("init RoutesViewController")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("RoutesViewController viewDidLoad")
        super.viewDidLoad()
        
        //Fetch clients from CoreData
        do
        {
            try fetchedResultsController.performFetch()
        }
        catch
        {
            let fetchError = error as NSError
            print("Unable to Save Route")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        /*
        
        let fetchRequest: NSFetchRequest<Route> = Route.fetchRequest()
        
        do
        {
            let routes = try PersistentService.context.fetch(fetchRequest)
            self.routes = routes
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.reloadData()
        }
        catch {}
 */
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let profileViewController = segue.destination as? RouteProfileViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            //Load an existing Route profile
            // Fetch Route
            let selectedRoute = fetchedResultsController.object(at: indexPath)
            
            //let selectedRoute = routes[indexPath.row]
            profileViewController.routeData = selectedRoute
        }
        else if let profileViewController = segue.destination as? RouteProfileViewController
        {
            //Create a new Route profile
            //Create a new Client profile
            let route = Route(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Route
            //let route = Route(context: PersistentService.context)
            route.name = "Enter route name"
            route.terrain = "Unknown"
            route.distance = 0.0
            route.duration = 0.0
            
            profileViewController.routeData = route
        }
    }
}

// MARK:- IBActions
extension RoutesViewController
{
    
    @IBAction func cancelToRoutesViewController(_ segue: UIStoryboardSegue) { print("Back in the RoutesViewController") }
    @IBAction func saveRouteDetail(_ segue: UIStoryboardSegue)
    {
        print("RoutesViewController saveRouteDetail")
        guard let profileViewController = segue.source as? RouteProfileViewController,
            let route = profileViewController.routeData else
        {
            return
        }
        
        do
        {
            try route.managedObjectContext?.save()
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Client")
            print("\(saveError), \(saveError.localizedDescription)")
        }
        /*
        //Store to CoreData
        PersistentService.saveContext()
        routes.append(route)
        self.tableView.reloadData()
 */
    }
}

extension RoutesViewController: NSFetchedResultsControllerDelegate
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? RouteCell
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

//MARK:- UITableViewDataSource
extension RoutesViewController
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
        // Fetch Route
        let route = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteCell
        //let route = routes[indexPath.row]
        cell.route = route
        //configureCell(cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // Fetch Route
        let route = fetchedResultsController.object(at: indexPath)
        
        // Delete Route
        fetchedResultsController.managedObjectContext.delete(route)
    }
    
    
    func configureCell(_ cell: RouteCell, at indexPath: IndexPath)
    {
        // Fetch Route
        let route = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.route = route
    }
}


extension RoutesViewController: AddRouteViewControllerDelegate
{
    
    func controller(_ controller: RouteProfileViewController, didAddRoute name: String)
    {
        
        // Create Route
        let route = Route(context: coreDataManager.mainManagedObjectContext)
        
        // Populate Route
        route.name = ""
        route.terrain = ""
        route.duration = 0.0
        route.distance = 0.0
        route.profilePicture = nil
        route.walks = nil

        route.updatedAt = NSDate()
        route.createdAt = NSDate()
        
        do
        {
            try route.managedObjectContext?.save()
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Route")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
}
