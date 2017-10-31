//
//  ClientsViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 15/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit


class ClientsViewController: UITableViewController
{
 //   @IBOutlet weak var tableView: UITableView
    
    // MARK:- Properties
    let dataSource: ClientsDataSource?
    
    //Client data to send to detail
    var clientData : Client?
    

    required init?(coder aDecoder: NSCoder)
    {
        self.dataSource = ClientsDataSource(clients: SampleData.generateClientsData())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("ClientsViewController viewDidLoad")
        super.viewDidLoad()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}


// MARK:- IBActions
extension ClientsViewController
{
    
    @IBAction func cancelToClientsViewController(_ segue: UIStoryboardSegue) { print("Back in the ClientViewController") }
    @IBAction func saveClientDetail(_ segue: UIStoryboardSegue)
    {
        print("ClientsViewController saveCXlientDetail")
        guard let clientDetailsViewController = segue.source as? ClientsDetailViewController,
            let client = clientDetailsViewController.clientData else
        {
            return
        }
        
        // Add the new client to the clients array
        dataSource?.clients.append(client)
        
        //Update the tableView
        let indexPath = IndexPath(row: (dataSource?.clients.count)!-1, section:0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
}



// MARK:- UITableViewDataSource
extension ClientsViewController
{

/*    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int)->Int
    {
        return dataSource.clients.count
    }
  */

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell    = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientCell
        let client  = dataSource?.clients[indexPath.row]
        cell.client = client
        return cell
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("ClientsViewController prepare segue")
        if let clientDetailsViewController = segue.destination as? ClientsDetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            let selectedClient = dataSource?.clients[indexPath.row]
            clientDetailsViewController.clientData = selectedClient
        }

    }
}



