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
    
    /*
    @IBOutlet var dogListView: UITableView!
    {
        didSet
        {
            dogListView.dataSource = self
        }
    }
 */
 
    //MARK:- Properties
    //let dataSource: WalkingDogsDataSource?
    //var dataSource: UITableViewDataSource?
    
    //Data to send dogs on walk controller
    //var dogs: [Dog]? = []
    var dogs: [Dog]?
    
    
    required init?(coder aDecoder: NSCoder)
    {
        //self.dataSource = WalkingDogsDataSource(dogsOnWalk: SampleData.generateWalkingDogsData())
        print("DogsEmbeddedTableViewController init dogs =\(dogs)")
        //self.dataSource = WalkingDogsDataSource(dogsOnWalk: dogs!)
        //dataSource = self
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("DogsEmbeddedTableViewConroller viewDidLoad")
        super.viewDidLoad()
        
        
        
        dogListView.estimatedRowHeight = 40
        dogListView.rowHeight = UITableViewAutomaticDimension
        //tableView.dataSource = WalkingDogsDataSource(dogsOnWalk: dogs!)
        //dogListView.dataSource = self
        //dogListView.delegate = self
        //dogListView.register(DogNameCell.self, forCellReuseIdentifier: "cell")
        dogListView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- UITableViewDataSource
extension DogsEmbeddedTableViewConroller
{
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("DogsEmbeddedTableViewConroller numberOfRowsInSection")
        return self.dogs!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {      
        print("DogsEmbeddedTableView Controller cellForRowAt")
        let cell = dogListView.dequeueReusableCell(withIdentifier: "DogNameCell", for: indexPath) as! DogNameCell
        let dog  = dogs![indexPath.row]
        cell.dogname = dog.dogName
        return cell
    }
}
