//
//  ClientCell.swift
//  DoggyTime
//
//  Created by Spaceman on 19/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

struct ClientCellData
{
    var name: String!
    var address: String!
    var dogsnames: String!
    var thumbnail: Data!
}


class ClientCell: UITableViewCell
{
    //MARK:- IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var dogImageView : UIImageView!

    var client: Client?
    {
        didSet
        {
            guard let client = client else {return}
            
            nameLabel.text = client.foreName
            addressLabel.text = client.street
            
            //Fetch the list of client dogs
            let dogsOwned = (client.dogsOwned)!
            guard let pets = Array(dogsOwned) as? [Dog] else { return }
            if pets.count > 0
            {
                guard let dogname = pets[0].dogName else { return }
                dogNameLabel.text = dogname
            }
                
            //dogNameLabel.text = pets![0].dogName
            //dogNameLabel.text = client.dogsnames
            //dogImageView.image = client.thumbnail
            //dogImageView.image = image(imageName: client.dogName)
        }
    }
 
    func image(imageName: String?) -> UIImage?
    {
        print("Dogs name:\(imageName!)")
        return UIImage(named: imageName!)
    }
    
}
