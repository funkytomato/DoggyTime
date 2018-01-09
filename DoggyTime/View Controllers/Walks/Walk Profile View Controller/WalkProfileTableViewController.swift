//
//  WalkProfileTableViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 27/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import MapKit

/*
protocol AddWalkViewControllerDelegate
{
    func controller(_ controller: WalkProfileTableViewController, didAddWalk name: String)
}
*/


class WalkProfileTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    
    //MARK:- Properties
    //var delegate: AddWalkViewControllerDelegate?
    weak var walkData: Walk?
    
    
    //Show/Hide PickerViews
    let dateTimePicker = UIDatePicker()
    let locationPicker = UIPickerView()
    
    //MARK:- IBOutlets
    @IBOutlet weak var dateTimeField: UITextField!
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var locationDataSource = ["Pagham", "Chichester", "Selsey", "Elmer", "Summer Lane"]
    

    
    
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
        
        //dateTimePicker.delegate = self
        //dateTimePicker.dataSource = self
        
        dateTimePicker.addTarget(self, action: #selector(dateTimePickerValueChanged), for: .valueChanged)
        //locationPicker.addTarget(self, action: #selector(locationNamePickerValueChanged), for: .valueChanged)
    
        if walkData != nil
        {
//            guard let row = locationDataSource.index(of: (walkData?.locationname)!) else {return}
//            locationPicker.selectRow(row, inComponent: 0, animated: false)
            
            //locationNameField.text = walkData?.locationname
            
            print("date \(String(describing: walkData?.dateofwalk))")
            dateTimePicker.setDate((walkData?.dateofwalk)! as Date, animated: true)
            
            //timeField.text = walkData?.dateofwalk?.hourOfDay()
            //dayOfWeekField.text = walkData?.dateofwalk?.dayOfWeek()
            
            var dayOfWeek = walkData?.dateofwalk?.dayOfWeek()
            var time = walkData?.dateofwalk?.hourOfDay()
            
            //str = str + "\(variable)"
            
            var dateTimeString = dayOfWeek
            dateTimeString = dateTimeString! + "\(time)"
            
            self.dateTimeField.text = dateTimeString
            dateTimeField.inputView = dateTimePicker
            
            self.locationNameField.text = walkData?.locationName?.description
            locationNameField.inputView = locationPicker
            

            latitudeField.text = walkData?.latitude.description
            longitudeField.text = walkData?.longitude.description
        }
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
        //else if let _ = segue.destination as? WalksViewController,
        else if segue.identifier == "SaveWalkDetail",
            //let locationname = LocationNameField.text,
            let latitude = latitudeField.text,
            let longitude = longitudeField.text
        {
    
            let dateofwalk = dateTimePicker.date
            
            //let walk = Walk(context: PersistentService.context)
            
            //Update Walk
            walkData?.dateofwalk = dateofwalk
            //walkData?.locationName = locationname
            
            guard let latitude = Double(latitude) else {return}
            print("latitude\(latitude)")
            walkData?.latitude = latitude
            
            guard let longitude = Double(longitude) else {return}
            print("longitude\(longitude)")
            walkData?.longitude = longitude
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
            
            
            //THIS IS WHERE THE DATA RECORD IS FETCHED FOR LOCATION FROM LOCATIONS IN COREDATA
            walkData?.locationName = locationDataSource[row]
            locationNameField.text = locationDataSource[row]
            
            //latitudeField.text = new value
            //longitudeField.text = new value
            
        }
        else if pickerView == dateTimePicker
        {
            print("dateTimePicker")
            
            walkData?.dateofwalk = dateTimePicker.date
           // dateTimeField.text = dateTimePicker.date.description
            
            
            var dayOfWeek = walkData?.dateofwalk?.dayOfWeek()
            var time = walkData?.dateofwalk?.hourOfDay()
            
            //str = str + "\(variable)"
            
            var dateTimeString = dayOfWeek
            dateTimeString = dateTimeString! + "\(time)"
            
            self.dateTimeField.text = dateTimeString
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    
 
    @objc func dateTimePickerValueChanged(sender: UIDatePicker)
    {
        //Function will be called everytime picker changes it's value
        walkData?.dateofwalk = sender.date as Date
        self.dateTimeField.text = walkData?.dateofwalk?.dayOfWeek()?.description
        print("WalkProfileTableViewController dateTimePickerValueChanged \(sender.date.description)")
    }
    
    @objc func locationNamePickerValueChanged(sender: UIPickerView)
    {
        //Function will be called everytime picker changes it's value
        //walkData?.locationName = sender.selectedRow(inComponent: 0) as String
        //print("WalkProfileTableViewController nameLocationPickerValueChanged \(sender.date.description)")
    }
}

extension WalkProfileTableViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) ->Bool
    {
        switch textField
        {
        case dateTimePicker:
            locationPicker.becomeFirstResponder()
        case locationPicker:
            latitudeField.becomeFirstResponder()
        case latitudeField:
            longitudeField.becomeFirstResponder()
        case longitudeField:
            mapView.resignFirstResponder()
        default:
            mapView.resignFirstResponder()
            
        }
        return true
    }
}

/*
//MARK:- IBActions
extension WalkProfileTableViewController
{
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        //guard let dateofwalk = DateTimePicker.date else { return }
        //guard let location = LocationPicker. else {return}
        guard let latitude = LatitudeField.text else {return}
        guard let longitude = LongitudeField.text else {return}
        guard let delegate = delegate else { return }
        
        let name = "test"
        
        // Notify Delegate
        delegate.controller(self, didAddWalk: name)
        
        // Dismiss View Controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
*/
