//
//  RoutesViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 29/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class RoutesViewController: UITableViewController
{
    
    //MARK:- Properties
    
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
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let profileController = segue.destination as? RouteProfileViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            let selectedRoute = routes[indexPath.row]
            profileController.routeData = selectedRoute
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
        
        //Store to CoreData
        PersistentService.saveContext()
        routes.append(route)
        self.tableView.reloadData()
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
        return routes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteCell
        let route = routes[indexPath.row]
        cell.route = route
        return cell
    }
    
    
}
