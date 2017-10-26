//
//  DogsViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 23/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit


class DogsViewController: UITableViewController
{
    //MARK:- Properties
    let dataSource: DogsDataSource?
    
    //Data to send to profile controller
    var dogData : Dog?
    
    required init?(coder aDecoder: NSCoder)
    {
        print("init DogsViewController")
        self.dataSource = DogsDataSource(dogs: SampleData.generateDogsData())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("DogsViewController viewDidLoad")
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


//MARK:- IBActions
extension DogsViewController
{
    
    
}

//MARK:- UITableViewDataSource
extension DogsViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogsCell", for: indexPath) as! DogsCell
        let dog = dataSource?.dogs[indexPath.row]
        cell.dog = dog
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let dogProfileController = segue.destination as? DogProfileViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            let selectedDog = dataSource?.dogs[indexPath.row]
            dogProfileController.dogData = selectedDog
        }
    }
    
}
