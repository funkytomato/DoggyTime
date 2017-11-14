//
//  RouteProfileViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 29/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import CoreData

/*
protocol AddRouteViewControllerDelegate
{
    func controller(_ controller: RouteProfileViewController, didAddRoute name: String )
}
*/


class RouteProfileViewController: UITableViewController
{
    
    //MARK:- Properties
    //var delegate: AddRouteViewControllerDelegate?
    var routeData: Route?
  
    //Picker DataSources
    var TerrainDataSource = ["Sandy","Grass","RiverSide","Hilly","Beach"]
    var TenNumbers = [0,1,2,3,4,5,6,7,8,9]
    var Qtrs = [25,50,75]
    var DistanceDataSource = ["0","1","2","3","4","5","6","7","8","9"]
    var DurationDataSource = ["0","1","2","3","4","5","6","7","8","9"]
  
    var receivedString: String = ""
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var PlaceNameField: UITextField!
    @IBOutlet weak var TerrainPicker: UIPickerView!
    @IBOutlet weak var DistancePicker: UIPickerView!
    @IBOutlet weak var DurationPicker: UIPickerView!
    
   
    //MARK:- IBActions
    @IBAction func StartBtn(_ sender: Any) {
    }
    @IBAction func FinishBtn(_ sender: Any) {
    }
    

    
    
    required init?(coder aDecoder: NSCoder)
    {
        print("RouteProfileViewController init")
        super.init(coder: aDecoder)
    }
    
    
    deinit {
        print("RouteProfileViewController deinit")
    }
    
    
    override func viewDidLoad()
    {
        print("RouteProfileViewController viewDidLoad")
        super.viewDidLoad()
        
        TerrainPicker.delegate = self
        TerrainPicker.dataSource = self
        
        DistancePicker.delegate = self
        DistancePicker.dataSource = self
        
        DurationPicker.delegate = self
        DurationPicker.dataSource = self
        
        
        
        if routeData != nil
        {
            self.PlaceNameField.text = routeData?.name
            
            //Set the terrain picker
            if let row = TerrainDataSource.index(of: (routeData?.terrain)!)
            {
                TerrainPicker.selectRow(row, inComponent:0, animated: false)
            }
            
            //Set the distance picker
            if let row = TenNumbers.index(of: Int((routeData?.distance)!))
            {
                DistancePicker.selectRow(row, inComponent:0, animated: false)
            }
            
            //Set the duration picker
            if let row = TenNumbers.index(of: Int((routeData?.duration)!))
            {
                DurationPicker.selectRow(row, inComponent:0, animated: false)
            }
            
        }
        
        //tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        print("RouteProfileViewController didRecieveMemoryWarning")
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("RouteProfileViewController prepare segue")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveRouteDetail",
            let name = PlaceNameField.text,
            let terrain = routeData?.terrain,
            let distance = routeData?.distance,
            let duration = routeData?.duration
        {
            
            //Get the latest data and pass to destinationController to be saved
            routeData?.name = name
            routeData?.terrain = terrain
            routeData?.distance = Float(distance)
            routeData?.duration = Float(duration)
        }
    }
}


//MARK:- PickerView
extension RouteProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        if pickerView == DistancePicker
        {
            return 2
        }
        else if pickerView == DurationPicker
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == TerrainPicker
        {
            return TerrainDataSource.count
        }
        else if pickerView == DistancePicker
        {
            if component == 0
            {
                return TenNumbers.count
            }
            else if component == 1
            {
                return Qtrs.count
            }
        }
        else if pickerView == DurationPicker
        {
            if component == 0
            {
                return TenNumbers.count
            }
            else if component == 1
            {
                return Qtrs.count
            }
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == TerrainPicker
        {
            return TerrainDataSource[row] as String
        }
        else if pickerView == DistancePicker
        {
            if component == 0
            {
                return String(TenNumbers[row])
            }
            else
            {
                return String(Qtrs[row])
            }
        }
        else if pickerView == DurationPicker
        {
            if component == 0
            {
                return String(TenNumbers[row])
            }
            else
            {
                return String(Qtrs[row])
            }
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == TerrainPicker
        {
            print(TerrainDataSource[row])
            
            routeData?.terrain = TerrainDataSource[row]
        }
        else if pickerView == DistancePicker
        {
            //print(DistanceDataSource[row])
            if component == 0
            {
                print("\(TenNumbers[row])")
                print("\(Qtrs[row])")
                
                let tens = TenNumbers[row].description
                let qtrs = Qtrs[row].description
                
                receivedString = tens + "." + qtrs
                routeData?.distance = Float(receivedString)!
            }
            else
            {
                print("\(TenNumbers[row])")
                print("\(Qtrs[row])")
                
                let tens = TenNumbers[row].description
                let qtrs = Qtrs[row].description
                
                receivedString = tens + "." + qtrs
                routeData?.distance = Float(receivedString)!
            }
            
            //routeData?.distance = DistanceDataSource[row]
        }
        else if pickerView == DurationPicker
        {
            //print(DurationDataSource[row])
            if component == 0
            {
                print("\(TenNumbers[row])")
            }
            else
            {
                print("\(Qtrs[row])")
            }
            
            //routeData?.duration = DurationDataSource[row]
        }
    }
    
    func pickerShouldReturn(_ pickerView: UIPickerView) -> Bool
    {
        switch pickerView
        {
        case TerrainPicker:
            DistancePicker.becomeFirstResponder()
        case DistancePicker:
            DurationPicker.resignFirstResponder()

        default:
            DurationPicker.resignFirstResponder()
        }
        
        return true
    }
}

/*
extension RouteProfileViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) ->Bool
    {
        switch textField
        {
        case PlaceNameField:
            TerrainPicker.becomeFirstResponder()

        default:
            PlaceNameField.resignFirstResponder()
            
        }
        return true
    }
}
*/



/*
//MARK:- IBActions
extension RouteProfileViewController
{
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any)
    {
        guard let name = NameField.text else { return }
        guard let terrain = TerrainField.text else {return}
        guard let distance = DistanceField.text else {return}
        guard let duartion = DurationField.text else {return }
        guard let delegate = delegate else { return }
        
        // Notify Delegate
        delegate.controller(self, didAddRoute: name)
        
        // Dismiss View Controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
}
 */
