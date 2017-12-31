//
//  ClientDogCell.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 17/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit


class ClientDogCell: UITableViewCell
{
    //MARK:- IBOutlets
    @IBOutlet weak var DogImageView : UIImageView!
    

    @IBOutlet weak var DogNameLabel: UILabel!
    
    
    var dog: Dog?
    {
        didSet
        {
            guard let dog = dog else {return}
            
            DogNameLabel.text = dog.dogName
            
            //var data : Data = UIImagePNGRepresentation(image)
            //DogImageView = dog.profilePicture
            //DogImageView.image = image(imageName: dog.profilePicture)
        }
    }
    
    func image(imageName: String?) -> UIImage?
    {
        print("Dogs name:\(imageName!)")
        return UIImage(named: imageName!)
    }
    
}

