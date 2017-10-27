//
//  DogsOnWalkTableViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 27/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class DogsOnWalkTableViewController: UITableViewController
{
    
    @IBOutlet var dogListView: UITableView!
    
    //MARK:- Properties
    let dataSource: WalkingDogsDataSource?
    
    //Data to send dogs on walk controller
    var walkData: Walk?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.dataSource = WalkingDogsDataSource(dogsOnWalk: SampleData.generateWalkingDogsData())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("DogsOnWalkTableViewController viewDidLoad")
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- UITableViewDataSource
extension DogsOnWalkTableViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("DogsOnWalkTableView Controller cellForRowAt")
        let cell = dogListView.dequeueReusableCell(withIdentifier: "DogNameCell", for: indexPath) as! DogNameCell
        let dog  = walkData?.dogs[indexPath.row]
        cell.dogname = dog
        return cell
    }
}
