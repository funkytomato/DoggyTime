//
//  WalkProfileTableViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 27/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import MapKit


class WalkProfileTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    //MARK:- IBOutlets
    @IBOutlet weak var walkIdField: UITextField!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var dayOfWeekField: UITextField!
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var locationPicker: UIPickerView!
    
    var locationDataSource = ["Pagham", "Chichester", "Selsey", "Elmer", "Summer Lane"]
    
    weak var walkData: Walk?
    
    required init?(coder aDecoder: NSCoder)
    {
        print("init WalkProfileTableViewController")
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        print("deinit WalkProfileTableViewController")
    }
    
    override func viewDidLoad()
    {
        print("WalkProfileTableViewController viewDidLoad")
        super.viewDidLoad()
   
        locationPicker.delegate = self
        locationPicker.dataSource = self
        
        dateTimePicker.addTarget(self, action: #selector(dateTimePickerValueChanged), for: .valueChanged)
        //locationPicker.addTarget(self, action: #selector(locationNamePickerValueChanged), for .valueChanged)
        if let row = locationDataSource.index(of: (walkData?.locationname)!)
        {
            locationPicker.selectRow(row, inComponent: 0, animated: false)
        }
        
        
//        walkIdField.text = walkData?.walkNo.description
        dateTimePicker.setDate((walkData?.dateofwalk)! as Date, animated: true)
        //timeField.text = walkData?.dateofwalk?.description(with: <#T##Any?#>)
        //dayOfWeekField.text = walkData?.dayOfWeek.description
        locationNameField.text = walkData?.locationname
        latitudeField.text = walkData?.latitude.description
        longitudeField.text = walkData?.longitude.description
        
    }
    
    override func didReceiveMemoryWarning()
    {
        print("WalkProfileTableViewController didReceiveMemoryWarning")
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
        else if let destinationViewController = segue.destination as? WalksViewController,
//let dateofwalk = dateTimePicker.date,
            let time = timeField.text,
            let dayofweek = dayOfWeekField.text,
            let locationname = locationNameField.text,
            let latitude = latitudeField.text,
            let longitude = longitudeField.text
        {
            let walk = Walk(context: PersistentService.context)
            //walk.dateofwalk = dateofwalk
            walk.locationname = locationname
            walk.latitude = Double(latitude)!
            walk.longitude = Double(longitude)!
            self.walkData = walk
        }
    }
}

//MARK:- PickerView
extension WalkProfileTableViewController
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == locationPicker
        {
            return locationDataSource.count
        }
    
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == locationPicker
        {
            return locationDataSource[row] as String
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == locationPicker
        {
            print(locationDataSource[row])
            //breedpictureView.image = UIImage(named: breedDataSource[row])
        }
    }
    
    @objc func dateTimePickerValueChanged(sender: UIDatePicker)
    {
        //Function will be called everytime picker changes it's value
        walkData?.date = sender.date
        print("WalkProfileTableViewController dateTimePickerValueChanged \(sender.date.description)")
    }
    
    @objc func locationNamePickerValueChanged(sender: UIPickerView)
    {
        //Function will be called everytime picker changes it's value
        //walkData?.locationName = sender.
        //print("WalkProfileTableViewController nameLocationPickerValueChanged \(sender.date.description)")
    }
}
