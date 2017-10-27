//
//  WalksDataSource.swift
//  DoggyTime
//
//  Created by Spaceman on 26/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

class WalksDataSource: NSObject
{
    var walks: [Walk]
    
    init(walks: [Walk])
    {
        self.walks = walks
    }
}

extension WalksDataSource: UITableViewDataSource
{
    func tableView(_ tableView: UITableView,  numberOfRowsInSection section: Int) -> Int
    {
        print("WalksDataSource numberOfRowsInSection")
        return self.walks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("WalksDataSource cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WalkCell.self)) as! WalkCell
        let walk = walks[indexPath.row]
        cell.walk = walk
        return cell
    }
}
