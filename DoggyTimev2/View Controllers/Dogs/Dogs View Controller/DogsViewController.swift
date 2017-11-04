//
//  DogsViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 23/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import CoreData


class DogsViewController: UITableViewController
{
    //MARK:- Properties
    
    //Data to send to profile controller
    var dogs = [Dog]()
    
    required init?(coder aDecoder: NSCoder)
    {
        print("init DogsViewController")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("DogsViewController viewDidLoad")
        super.viewDidLoad()
        
        //Fetch dogs from CoreData
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        
        do
        {
            let dogs = try PersistentService.context.fetch(fetchRequest)
            self.dogs = dogs
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.reloadData()
        }
        catch {}
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("DogsViewController prepare segue")
        if let dogProfileController = segue.destination as? DogProfileViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            let selectedDog = dogs[indexPath.row]
            dogProfileController.dogData = selectedDog
        }
    }
}


//MARK:- IBActions
extension DogsViewController
{
    @IBAction func cancelToDogsViewController(_ segue: UIStoryboardSegue) { print("Back in the DogsViewController")}
    
    @IBAction func saveDogDetail(_ segue: UIStoryboardSegue)
    {
        print("DogsViewController saveDogDetail")
        guard let profileViewController = segue.source as? DogProfileViewController,
            let dog = profileViewController.dogData else
        {
            return
        }
        
        //Store to CoreData
        PersistentService.saveContext()
        clients.append(client)
        self.tableView.reloadData()
    }
    
}

//MARK:- UITableViewDataSource
extension DogsViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("DogsViewController cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogsCell", for: indexPath) as! DogsCell
        let dog = dogs[indexPath.row]
        cell.dog = dog
        return cell
    }
}
