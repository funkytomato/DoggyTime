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
    var coreDataManagerDelegate: CoreDataManagerDelegate!
    var coreDataManager: CoreDataManager!
    var routes = [Route]()
    
    
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

    
    required init?(coder aDecoder: NSCoder)
    {
        print("init RoutesViewController")
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad()
    {
        print("RoutesViewController viewDidLoad")
        super.viewDidLoad()
        
        //Fetch Routes from CoreData
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
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("prepare segue\(segue.identifier)")
        
        
        //Create a new Route profile
        if segue.identifier == "newRoute",
            let profileViewController = segue.destination as? RouteProfileViewController
        {
            //Create a new Route profile
            let route = Route(context: coreDataManager.mainManagedObjectContext)
            let map = Map(context: coreDataManager.mainManagedObjectContext)
            let path = Path(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Route
            route.placeName = ""
            route.terrain = ""
            
            //Populate Map
            map.uuid = ""
            map.createdAt = Date()
            
            //Populate Path
            path.uuid = ""
            path.createdAt = Date()
            
            // Configure View Controller
            profileViewController.setCoreDataManager(coreDataManager: coreDataManager)
            profileViewController.routeData = route
            profileViewController.mapData = map
            profileViewController.pathData = path
        }
        
        //Load an existing Route profile
        else if segue.identifier == "showRoute",
            let profileViewController = segue.destination as? RouteProfileViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {

            // Fetch Route
            let selectedRoute = fetchedResultsController.object(at: indexPath)
            
            // Configure View Controller
            profileViewController.setCoreDataManager(coreDataManager: coreDataManager)
            profileViewController.routeData = selectedRoute
            profileViewController.mapData = selectedRoute.mapProfile
            //profileViewController.pathData = selectedRoute.mapProfile?.path
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
            let route = profileViewController.routeData,
            let map = profileViewController.mapData,
            let path = profileViewController.pathData else
//            let map = profileViewController.routeData?.mapProfile else
        {
            return
        }
        
        //Store to CoreData
        do
        {
            try route.managedObjectContext?.save()
            try map.managedObjectContext?.save()
            try path.managedObjectContext?.save()
            
            print("RoutesViewController saveRouteDetail route:\(route)")
            print("RoutesViewController saveRouteDetail map:\(map)")
            print("RoutesViewController saveRouteDetail path:\(path)")
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Route")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
}

extension RoutesViewController: NSFetchedResultsControllerDelegate
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? RouteCell
            {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath
            {
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


//MARK:- CoreDataManager Protocol
extension RoutesViewController: CoreDataManagerDelegate
{
    
    func setCoreDataManager(coreDataManager: CoreDataManager)
    {
        self.coreDataManager = coreDataManager
    }
}

/*
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
 */
