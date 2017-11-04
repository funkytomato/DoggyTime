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
        if let walkProfileController = segue.destination as? WalkProfileTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            let selectedWalk = walks[indexPath.row]
            walkProfileController.walkData = selectedWalk
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
        
        //Store to CoreData
        PersistentService.saveContext()
        walks.append(walk)
        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalkIdentificationCell", for: indexPath) as! WalkIdentificationCell
        let walk = walks[indexPath.row]
        cell.walk = walk
        return cell
    }
    


    
}

