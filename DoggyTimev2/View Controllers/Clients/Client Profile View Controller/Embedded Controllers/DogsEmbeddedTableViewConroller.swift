//
//  DogsEmbeddedTableViewConroller.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 17/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class DogsEmbeddedTableViewConroller: UITableViewController
{
    
    @IBOutlet var dogListView: UITableView!
    
    //MARK:- Properties
    //let dataSource: WalkingDogsDataSource?
    
    //Data to send dogs on walk controller
    var dogs: [Dog]? = []
    
    
    required init?(coder aDecoder: NSCoder)
    {
        //self.dataSource = WalkingDogsDataSource(dogsOnWalk: SampleData.generateWalkingDogsData())
        print("dogs =\(dogs)")
        //self.dataSource = WalkingDogsDataSource(dogsOnWalk: dogs!)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("DogsEmbeddedTableViewConroller viewDidLoad")
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- UITableViewDataSource
extension DogsEmbeddedTableViewConroller
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {      
        print("DogsEmbeddedTableView Controller cellForRowAt")
        let cell = dogListView.dequeueReusableCell(withIdentifier: "DogNameCell", for: indexPath) as! DogNameCell
        let dog  = dogs![indexPath.row]
        cell.dogname = dog.dogName
        return cell
    }
}
