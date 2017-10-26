//
//  WalkProfileViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 16/10/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit
import MapKit



class WalkProfileViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{

    //MARK:- IBOutlets
    @IBOutlet weak var walkIdField: UITextField!
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dogList: UITableView!
    
    //MARK:- Properties
    let dataSource: WalkingDogsDataSource?
    
    var walkData: Walk?
    
    
    required init?(coder aDecoder: NSCoder)
    {
        print("init WalkProfileViewController")
        //dogs = []
        self.dataSource = WalkingDogsDataSource(dogsOnWalk: SampleData.generateWalkingDogsData())
        //self.dataSource = walkData?.dogs
        super.init(coder: aDecoder)
    }
    
    
    deinit
    {
        print("deinit WalkProfileViewController")
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        walkIdField.text = walkData?.walkNo.description
        locationNameField.text = walkData?.locationName.description
        latitudeField.text = walkData?.latitude.description
        longitudeField.text = walkData?.longitude.description

        
        dogList.estimatedRowHeight = 60
        dogList.rowHeight = UITableViewAutomaticDimension
        dogList.dataSource = dataSource
        dogList.reloadData()
        
    }
   
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        NSLog("sections")
        return 1
    }
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        NSLog("rows")
        return (walkData?.dogs.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = dogList.dequeueReusableCell(withIdentifier: "DogNameCell", for: indexPath) as! DogNameCell
        let dog  = walkData?.dogs[indexPath.row]
        cell.dogname = dog
        return cell
    }
}
