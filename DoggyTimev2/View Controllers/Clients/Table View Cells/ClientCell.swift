//
//  ClientCell.swift
//  DoggyTime
//
//  Created by Spaceman on 19/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

class ClientCell: UITableViewCell
{
    //MARK:- IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var dogImageView : UIImageView!

    /*
    var client: Client?
    {
        didSet
        {
            guard let client = client else {return}
            
            nameLabel.text = client.forename
            addressLabel.text = client.street
            dogNameLabel.text = client.dogname
            dogImageView.image = image(imageName: client.dogname)
        }
    }
 */
 
    func image(imageName: String?) -> UIImage?
    {
        print("Dogs name:\(imageName!)")
        return UIImage(named: imageName!)
    }
    
}
