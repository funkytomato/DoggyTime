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
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("ClientsViewController viewDidLoad")
        super.viewDidLoad()
   
        //Fetch clients from CoreData
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        
        do
        {
            let clients = try PersistentService.context.fetch(fetchRequest)
            self.clients = clients
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.reloadData()
        }
        catch {}

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("ClientsViewController prepare segue")
        if let clientDetailsViewController = segue.destination as? ClientsDetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
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
        
        //Store to CoreData
        PersistentService.saveContext()
        clients.append(client)
        self.tableView.reloadData()
    }
}



// MARK:- UITableViewDataSource
extension ClientsViewController
{


    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell    = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientCell
        let client  = clients[indexPath.row]
        cell.client = client
        return cell
    }
}



