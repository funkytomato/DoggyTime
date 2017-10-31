//
//  SecondViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 15/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit


class WalksViewController: UITableViewController
{

    //MARK:- Properties
    let dataSource: WalksDataSource?
    
    //Data to send to detail controller
    var walkData : Walk?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.dataSource = WalksDataSource(walks: SampleData.generateWalksData())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("WalksViewController viewDidLoad")
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = dataSource
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        print("WalksViewController didRecieveMemoryWarning")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        // Add the new walk to the walks array
        dataSource?.walks.append(walk)
        
        //Update the tableView
        let indexPath = IndexPath(row: (dataSource?.walks.count)!-1, section:0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}


// MARK:- UITableViewDataSource
extension WalksViewController
{
    /*
     ORIGINAL
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("WalksViewController cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalkCell", for: indexPath) as! WalkCell
        let walk = dataSource?.walks[indexPath.row]
        cell.walk = walk
        return cell
    }
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("WalksViewController cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalkIdentificationCell", for: indexPath) as! WalkIdentificationCell
        let walk = dataSource?.walks[indexPath.row]
        cell.walk = walk
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("WalksViewController prepare segue")
        if let walkProfileController = segue.destination as? WalkProfileTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            let selectedWalk = dataSource?.walks[indexPath.row]
            walkProfileController.walkData = selectedWalk
        }
    }
    
}

