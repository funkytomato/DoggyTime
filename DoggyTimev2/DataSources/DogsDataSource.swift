//
//  DogsDataSource.swift
//  DoggyTime
//
//  Created by Spaceman on 18/10/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

class DogsDataSource: NSObject
{
    var dogs: [Dog]
    
    init(dogs:[Dog])
    {
        self.dogs = dogs
    }
}


extension DogsDataSource: UITableViewDataSource
{
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        print("DogsDataSource sections")
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        print("DogsDataSource heightForRowAt")
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("DogsDataSource numberOfRowsInSection \(self.dogs.count)")
        return self.dogs.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("DogsDataSource cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ClientDogCell.self)) as! ClientDogCell
        let dog = dogs[indexPath.row]
        cell.dog = dog
        return cell
    }
}
