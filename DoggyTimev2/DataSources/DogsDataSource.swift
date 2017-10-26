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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dogs.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DogsCell.self)) as! DogsCell
        let dog = dogs[indexPath.row]
        cell.dog = dog
        return cell
    }
}
