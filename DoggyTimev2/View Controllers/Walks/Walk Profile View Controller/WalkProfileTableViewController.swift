//
//  WalkProfileTableViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 27/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import MapKit


class WalkProfileTableViewController: UITableViewController
{
    
    @IBOutlet weak var walkIdField: UITextField!
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let dataSource: WalksDataSource
    var walkData: Walk?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.dataSource = WalksDataSource(walks: SampleData.generateWalksData())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        print("WalkProfileTableViewController viewDidLoad")
        super.viewDidLoad()
   
        walkIdField.text = walkData?.walkNo.description
        locationNameField.text = walkData?.locationName.description
        latitudeField.text = walkData?.latitude.description
        longitudeField.text = walkData?.longitude.description
        
    /*
        dogListView.estimatedRowHeight = 60
        dogListView.rowHeight = UITableViewAutomaticDimension
        dogListView.dataSource = dataSource
        dogListView.reloadData()
     */
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("WalkProfileTableViewController prepare segue")
        //if (segue.identifier == "embeddedDogsOnWalkController"), let indexPath = self.tableView.indexPathForSelectedRow
        if (segue.identifier == "embeddedDogsOnWalkController")
        {
            print("WalkProfileTableViewController prepare got DogsOnWalkTableViewController")
            let childViewController = segue.destination as! DogsOnWalkTableViewController
            
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
            //let selectedWalk = dataSource.walks[indexPath.row]
            childViewController.walkData = walkData
        }
        
        /*
        if let dogsOnWalkController = segue.destination as? DogsOnWalkTableViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            let selectedWalk = dataSource.walks[indexPath.row]
            dogsOnWalkController.walkData = selectedWalk
        }
 */
    }
}
