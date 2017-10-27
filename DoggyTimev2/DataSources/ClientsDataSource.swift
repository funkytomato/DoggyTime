//
//  ClientsDataSource.swift
//  DoggyTime
//
//  Created by Spaceman on 20/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

class ClientsDataSource: NSObject
{
    var clients: [Client]
    
    init(clients: [Client])
    {
        self.clients = clients
    }
}

extension ClientsDataSource: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("ClientsDataSource numberOfRowsInSection")
        return self.clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("ClientsDataSource cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ClientCell.self)) as! ClientCell
        let client = clients[indexPath.row]
        cell.client = client
        return cell
    }
}
