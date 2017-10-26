//
//  DogsCell.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 23/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class DogsCell: UITableViewCell
{
    //MARK:- IBOutlets
    @IBOutlet weak var dogname: UILabel!
    @IBOutlet weak var breed: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    
    var dog: Dog?
    {
        didSet
        {
            guard let dog = dog else {return}
            
            dogname.text = dog.dogName
            breed.text = dog.breed
            sex.text = dog.sex
            size.text = dog.size
            picture.image = dog.picture
        }
    }
    
    func image(imageName: String?) -> UIImage?
    {
        print("Dogs namr:\(imageName!)")
        return UIImage(named: imageName!)
    }
}
