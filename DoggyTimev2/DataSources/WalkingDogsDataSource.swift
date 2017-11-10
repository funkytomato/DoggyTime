//
//  WalkingDogsDataSource.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 23/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class WalkingDogsDataSource: NSObject
{
    
    var dogsOnWalk: [Dog]
    
    init(dogsOnWalk:[Dog])
    {
        self.dogsOnWalk = dogsOnWalk
    }
}

extension WalkingDogsDataSource: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("WalkingDogsDataSource numberOfRowsInSection")
        return self.dogsOnWalk.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("WalkingDogsDataSource cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DogNameCell.self)) as! DogNameCell
        let dog = dogsOnWalk[indexPath.row]
        cell.dogname = dog.dogName
        return cell
    }
}
