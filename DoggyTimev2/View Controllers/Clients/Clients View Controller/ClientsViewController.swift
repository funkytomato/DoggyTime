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
    
    //Client data to send to detail
    var clients = [Client]()
    
    required init?(coder aDecoder: NSCoder)
    {
        //self.dataSource = ClientsDataSource(clients: SampleData.generateClientsData())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("ClientsViewController viewDidLoad")
        super.viewDidLoad()
   
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        
        do
        {
            let clients = try PersistentService.context.fetch(fetchRequest)
            self.clients = clients
            self.tableView.reloadData()
        }
        catch {}

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("ClientsViewController prepare segue")
        if let clientDetailsViewController = segue.destination as? ClientsDetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
            //let selectedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! Client
        {
            let selectedClient = clients[indexPath.row]
            clientDetailsViewController.clientData = selectedClient
        }
    }
}


// MARK:- IBActions
extension ClientsViewController
{
    
    @IBAction func cancelToClientsViewController(_ segue: UIStoryboardSegue) { print("Back in the ClientViewController") }
    @IBAction func saveClientDetail(_ segue: UIStoryboardSegue)
    {
        print("ClientsViewController saveClientDetail")
        print("Segue source\(segue.source)")
        guard let clientDetailsViewController = segue.source as? ClientsDetailViewController,
        let client = clientDetailsViewController.clientData else
        {
            return
        }
        
        PersistentService.saveContext()
        clients.append(client)
        self.tableView.reloadData()
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
        return clients.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell    = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientCell
        let client  = clients[indexPath.row]
        cell.client = client
        return cell
    }
}



