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
    let dataSource: RoutesDataSource?
    
    //Data to send to profile controller
    var routeData: Route?
    
    required init?(coder aDecoder: NSCoder)
    {
        print("init RoutesViewController")
        self.dataSource = RoutesDataSource(routes: SampleData.generateRoutesData())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("RoutesViewController viewDidLoad")
        super.viewDidLoad()
        
        //Do additional setup
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
}

//MARK:- UITableViewDataSource
extension RoutesViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteCell
        let route = dataSource?.routes[indexPath.row]
        cell.route = route
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let profileController = segue.destination as? RouteProfileViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            let selectedRoute = dataSource?.routes[indexPath.row]
            profileController.routeData = selectedRoute
        }
    }
}
