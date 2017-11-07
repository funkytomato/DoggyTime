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
    @IBOutlet weak var WalkIdField: UITextField!
    @IBOutlet weak var DateTimePicker: UIDatePicker!
    //@IBOutlet weak var TimeField: UITextField!
    @IBOutlet weak var DayOfWeekField: UITextField!
    @IBOutlet weak var LocationNameField: UITextField!
    @IBOutlet weak var LatitudeField: UITextField!
    @IBOutlet weak var LongitudeField: UITextField!
    @IBOutlet weak var MapView: MKMapView!
    
    @IBOutlet weak var LocationPicker: UIPickerView!
    
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
   
        LocationPicker.delegate = self
        LocationPicker.dataSource = self
        
        DateTimePicker.addTarget(self, action: #selector(dateTimePickerValueChanged), for: .valueChanged)
        //locationPicker.addTarget(self, action: #selector(locationNamePickerValueChanged), for: .valueChanged)
    
        if walkData != nil
        {
//            guard let row = locationDataSource.index(of: (walkData?.locationname)!) else {return}
//            locationPicker.selectRow(row, inComponent: 0, animated: false)
            
            
            WalkIdField.text = walkData?.walkid.description
            //locationNameField.text = walkData?.locationname
            
            print("date \(String(describing: walkData?.dateofwalk))")
            DateTimePicker.setDate((walkData?.dateofwalk)! as Date, animated: true)
            
            //timeField.text = walkData?.dateofwalk?.hourOfDay()
            //dayOfWeekField.text = walkData?.dateofwalk?.dayOfWeek()
            

            LatitudeField.text = walkData?.latitude.description
            LongitudeField.text = walkData?.longitude.description
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
            let walkid = Int16(WalkIdField.text!),
            let locationname = LocationNameField.text,
            let latitude = LatitudeField.text,
            let longitude = LongitudeField.text
        {
    
            let dateofwalk = DateTimePicker.date
            
            let walk = Walk(context: PersistentService.context)
            walk.walkid = walkid
            walk.dateofwalk = dateofwalk
            walk.locationname = locationname
            
            guard let latitude = Double(latitude) else {return}
            print("latitude\(latitude)")
            walk.latitude = latitude
            
            guard let longitude = Double(longitude) else {return}
            print("longitude\(longitude)")
            walk.longitude = longitude
            
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
        if pickerView == LocationPicker
        {
            return locationDataSource.count
        }
    
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == LocationPicker
        {
            return locationDataSource[row] as String
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == LocationPicker
        {
            print(locationDataSource[row])
            //breedpictureView.image = UIImage(named: breedDataSource[row])
        }
    }
    /*
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil
        {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Arial", size: 17)
            pickerLabel?.textAlignment = .left
        }
        pickerLabel?.text = <Data Array>[row]
        //pickerLabel?.textColor = UIColor.blue
        
        return pickerLabel!
    }
 */
 
    @objc func dateTimePickerValueChanged(sender: UIDatePicker)
    {
        //Function will be called everytime picker changes it's value
        walkData?.dateofwalk = sender.date as Date
        print("WalkProfileTableViewController dateTimePickerValueChanged \(sender.date.description)")
    }
    
    @objc func locationNamePickerValueChanged(sender: UIPickerView)
    {
        //Function will be called everytime picker changes it's value
        //walkData?.locationname = sender.selectedRow(inComponent: 1)
        //print("WalkProfileTableViewController nameLocationPickerValueChanged \(sender.date.description)")
    }
}

extension WalkProfileTableViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) ->Bool
    {
        switch textField
        {
        case WalkIdField:
            DateTimePicker.becomeFirstResponder()
        case DateTimePicker:
            LocationPicker.becomeFirstResponder()
        case LocationPicker:
            LatitudeField.becomeFirstResponder()
        case LatitudeField:
            LongitudeField.becomeFirstResponder()
        case LongitudeField:
            MapView.resignFirstResponder()
        default:
            MapView.resignFirstResponder()
            
        }
        return true
    }
}

