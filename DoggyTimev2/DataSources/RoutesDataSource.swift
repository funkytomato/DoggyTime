//
//  WalkingRoutesDataSource.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 29/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class RoutesDataSource: NSObject
{
    
    var routes: [Route]
    
    init(routes: [Route])
    {
        self.routes = routes
    }
}

extension RoutesDataSource: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("RoutesDataSource numberOfRowsInSection")
        return self.routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("DogsDataSource cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteCell
        let route = routes[indexPath.row]
        cell.route = route
        return cell
    }
}
