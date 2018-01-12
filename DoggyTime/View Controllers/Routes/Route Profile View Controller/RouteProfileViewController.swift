//
//  RouteProfileViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 29/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import CoreData
import MapKit



class RouteProfileViewController: UITableViewController
{
    
    // MARK: - Properties
    var coreDataManager: CoreDataManager!
    var coreDataManagerDelegate: CoreDataManagerDelegate!
    
    fileprivate var embeddedMapsViewController: MapsViewController!
    
    //MARK:- Properties
    var routeData: Route?
    var mapData: Map?
   
    
    var durationHrs: Int?
    var durationMins: Int?
    var distanceMiles: Int?
    var distanceQtrs: Int?
    
    //Picker DataSources
    var TerrainDataSource = ["Sandy","Grass","RiverSide","Hilly","Beach"]
    var TenNumbersDataSource = [0,1,2,3,4,5,6,7,8,9]
    var DurationQtrsDataSource = [0,15,30,45]
    var DistanceQtrDataSource = [0,25,50,75]
    
    //var DistanceDataSource = ["0","1","2","3","4","5","6","7","8","9"]
    //var DurationDataSource = ["0","1","2","3","4","5","6","7","8","9"]
  
    var numberString: String = ""
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var placeNameField: UITextField!
    //@IBOutlet weak var TerrainPicker: UIPickerView!
    //@IBOutlet weak var DistancePicker: UIPickerView!
    //@IBOutlet weak var DurationPicker: UIPickerView!
    
    //@IBOutlet weak var ActualDistanceField: UITextField!
    
    //@IBOutlet weak var ActualDurationField: UITextField!
    //MARK:- IBActions
    @IBOutlet weak var RouteMapView: MKMapView!
    
    
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
        
        
        if routeData != nil
        {
            self.placeNameField.text = routeData?.placeName
        }
        
        
        /*
        TerrainPicker.delegate = self
        TerrainPicker.dataSource = self
        
        DistancePicker.delegate = self
        DistancePicker.dataSource = self
        
        DurationPicker.delegate = self
        DurationPicker.dataSource = self
        
        //var distanceExpondent = routeData?.distanceMiles
        //var distanceSignificand = routeData?.distanceQtrs
        
        if routeData != nil
        {
            self.PlaceNameField.text = routeData?.placeName
            
            //Set the terrain picker
            if let row = TerrainDataSource.index(of: (routeData?.terrain)!)
            {
                TerrainPicker.selectRow(row, inComponent:0, animated: false)
            }
            
            //Set the distance picker
            if let row = TenNumbersDataSource.index(of: Int((routeData?.distanceMiles)!))
            {
                print("Hrs:\(String(describing: routeData?.distanceMiles))")
                DistancePicker.selectRow(row, inComponent:0, animated: false)
            }
            
            if let row = DistanceQtrDataSource.index(of: Int((routeData?.distanceQtrs)!))
            {
                print("Qtrs:\(String(describing: routeData?.distanceQtrs))")
                DistancePicker.selectRow(row, inComponent:1, animated: false)
            }
            
            //Set the duration picker
            if let row = TenNumbersDataSource.index(of: Int((routeData?.durationHrs)!))
            {
                print("Hrs:\(String(describing: routeData?.durationHrs))")
                DurationPicker.selectRow(row, inComponent:0, animated: false)
            }
            
            if let row = DurationQtrsDataSource.index(of: Int((routeData?.durationMins)!))
            {
                print("Hrs:\(String(describing: routeData?.durationMins))")
                DurationPicker.selectRow(row, inComponent:1, animated: false)
            }
        }
 */
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
        print("RouteProfileViewController prepare segue identifier:\(String(describing: segue.identifier))")
        print("RouteProfileViewController prepare segue source:\(segue.source)")
        print("RouteProfileViewController prepare segue destination:\(segue.destination)")
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        
        if segue.identifier == "mapsEmbeddedSegue",
            let navController = segue.destination as? UINavigationController
        {
            let mapsViewController = navController.topViewController as? MapsViewController
            embeddedMapsViewController = mapsViewController
            
            
            guard let locationName = routeData?.placeName else { return }
            guard let coord = routeData?.mapProfile?.midCoordinate else { return }
            //guard var coord = map.midCoordinate else { return }
            //let pointsofinterest = Array(map?.pointsofinterest)
            
            
            //Create the MapModel
            let mapModel = MapModel()
            
            let midC = parseCoord(location: coord)
            
            //Load the boundaries into the MapModel
            mapModel.name = locationName
            mapModel.midCoordinate = midC
            mapModel.overlayTopLeftCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.overlayTopLeftCoordinate)!)
            mapModel.overlayTopRightCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.overlayTopRightCoordinate)!)
            mapModel.overlayBottomLeftCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.overlayBottomLeftCoordinate)!)
            
            print("mapModel.midCoordinate:\(mapModel.midCoordinate)")
            print("mapModel.overlayTopLeftCoordinate:\(mapModel.overlayTopLeftCoordinate)")
            print("mapModel.overlayTopRightCoordinate:\(mapModel.overlayTopRightCoordinate)")
            print("mapModel.overlayBottomLeftCoordinate:\(mapModel.overlayBottomLeftCoordinate)")
            
            
            //THINK I AM OVRCASTING, coord has too much ascii content, something wrong
            
            /*
            //Create a new map if none exists
            if routeData?.mapProfile == nil
            {
            
                //Create a new Map profile
                let map = Map(context: coreDataManager.mainManagedObjectContext)
                
                //Populate Map
                map.uuid = ""
                map.createdAt = Date()
                map.updatedAt = Date()
                map.name = routeData?.placeName
                map.midCoordinate = ""
                map.overlayBottomLeftCoordinate = ""
                map.overlayBottomRightCoordinate = ""
                map.overlayTopLeftCoordinate = ""
                map.overlayTopRightCoordinate = ""
            }
            else
            {
                //Load existing map profile
                map.midCoordinate = String(describing: mapModel.midCoordinate)
                map.overlayBottomLeftCoordinate = String(describing: mapModel.overlayBottomLeftCoordinate)
                map.overlayBottomRightCoordinate = String(describing: mapModel.overlayBottomRightCoordinate)
                map.overlayTopLeftCoordinate = String(describing: mapModel.overlayTopLeftCoordinate)
                map.overlayTopRightCoordinate = String(describing: mapModel.overlayTopRightCoordinate)
            }
 
            
            //Create a relationship between route and map
            map.mapFor = routeData
            map.pointsofinterest = nil
            map.path = nil
 */
 
            //let map = routeData?.mapProfile
            //routeData?.mapProfile = map
            
            

            
            

            
            
            
            
            //Load the points of interest
            /*
            let pointsofinterest = map?.pointsofinterest
            guard let validpointsofinterest = Array(pointsofinterest) as? [PointOfInterest] else { return }
            if validpointsofinterest.count > 0
            {
                //guard let dogname = pets[0].dogName else { return }
                //dogNameLabel.text = dogname
                mapsViewController.pointsOfInterest = validpointsofinterest
            }
            */
            
            //Load the path coordinates
            /*
            let path = Array(map?.path)
            guard let validPath = Array(path?) as? [Path] else { return }
            if path?.count > 0
            {
                mapsViewController.path = path
            }
            */
            
            
            //Configure the MapsViewController
            //mapsViewController?.mapData = map
            mapsViewController?.mapModel = mapModel
        

        }
        

        if segue.identifier == "SaveRouteDetail" /*,
             let placeName = PlaceNameField.text,
             let terrain = routeData?.terrain,
             let actualDistance = routeData?.actualDistance,
             let distanceMiles = routeData?.distanceMiles,
             let distanceQtrs = routeData?.distanceQtrs,
             let actualDuration = routeData?.actualDuration,
             let durationHrs = routeData?.durationHrs,
             let durationMins = routeData?.durationMins
             */
        {
            
            
            //Get the latest data and pass to destinationController to be saved
            guard let locationName = placeNameField.text else { return }
            guard let mapModel = embeddedMapsViewController?.mapModel else { return }
            
            
            print("Save Route Detail")
            print("mapModel-midCoordinate:\(mapModel.midCoordinate)")
            print("mapModel.overlayTopLeftCoordinate:\(mapModel.overlayTopLeftCoordinate)")
            print("mapModel.overlayTopRightCoordinate:\(mapModel.overlayTopRightCoordinate)")
            print("mapModel.overlayBottomLeftCoordinate:\(mapModel.overlayBottomLeftCoordinate)")
            print("mapModel.overlayBottomRightCoordinate:\(mapModel.overlayBottomRightCoordinate)")
            
            //Create a CoreData Map profile
            let map = Map(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Map object with mapModel values
            map.uuid = ""
            map.updatedAt = Date()
            map.createdAt = Date()
            
            map.name = locationName
            map.midCoordinate = String(describing: mapModel.midCoordinate)
            map.overlayBottomLeftCoordinate = String(describing: mapModel.overlayTopLeftCoordinate)
            map.overlayBottomRightCoordinate = String(describing: mapModel.overlayTopRightCoordinate)
            map.overlayTopLeftCoordinate = String(describing: mapModel.overlayBottomLeftCoordinate)
            map.overlayTopRightCoordinate = String(describing: mapModel.overlayBottomRightCoordinate)
            
            map.mapFor = routeData
            
            //map.pointsofinterest = pointsOfInterest
            //map.path: NSSet?
            
            
            
            
            //Update Route
            routeData?.placeName = locationName
            routeData?.mapProfile = map
            
            /*
             routeData?.terrain = terrain
             routeData?.actualDistance = Float(actualDistance)
             routeData?.distanceMiles = Int16(distanceMiles)
             routeData?.distanceQtrs = Int16(distanceQtrs)
             routeData?.actualDuration = Float(actualDuration)
             routeData?.durationHrs = Int16(durationHrs)
             routeData?.durationMins = Int16(durationMins)
             routeData?.profilePicture = nil
             */
        }


    }
    
    func parseCoord(location: String) -> CLLocationCoordinate2D
    {
        if let coord = location as? String
        {
            let point = CGPointFromString(coord)
            return CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
        }
        
        return CLLocationCoordinate2D()
    }
 
}


//MARK:- PickerView
extension RouteProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
 /*       if pickerView == DistancePicker
        {
            return 2
        }
        else if pickerView == DurationPicker
        {
            return 2
        }
*/
        return 1

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
 /*       if pickerView == TerrainPicker
        {
            return TerrainDataSource.count
        }
        else if pickerView == DistancePicker
        {
            if component == 0
            {
                return TenNumbersDataSource.count
            }
            else if component == 1
            {
                return DistanceQtrDataSource.count
            }
        }
        else if pickerView == DurationPicker
        {
            if component == 0
            {
                return TenNumbersDataSource.count
            }
            else if component == 1
            {
                return DurationQtrsDataSource.count
            }
        }
   */
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
/*        if pickerView == TerrainPicker
        {
            return TerrainDataSource[row] as String
        }
        else if pickerView == DistancePicker
        {
            if component == 0
            {
                return String(TenNumbersDataSource[row])
            }
            else
            {
                return String(DistanceQtrDataSource[row])
            }
        }
        else if pickerView == DurationPicker
        {
            if component == 0
            {
                return String(TenNumbersDataSource[row])
            }
            else
            {
                return String(DurationQtrsDataSource[row])
            }
        }
  */
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        /*
        if pickerView == TerrainPicker
        {
            print(TerrainDataSource[row])
            
            routeData?.terrain = TerrainDataSource[row]
        }
        else if pickerView == DistancePicker
        {
            var tens: String = "0"
            var qtrs: String = "0"
            
            if component == 0
            {
                print("\(TenNumbersDataSource[row])")
                //print("\(Qtrs[row])")
                
                tens = TenNumbersDataSource[row].description
                //let qtrs = Qtrs[row].description
                routeData?.distanceMiles = Int16(tens)!
            }
            else
            {
               // print("\(TenNumbers[row])")
                print("\(DistanceQtrDataSource[row])")
                
               // let tens = TenNumbers[row].description
                qtrs = DistanceQtrDataSource[row].description
                
                routeData?.distanceQtrs = Int16(qtrs)!
            }
            
            //numberString = tens + "." + qtrs
            //routeData?.distance = Float(numberString)!
        }
        else if pickerView == DurationPicker
        {
            var tens: String = "0"
            var qtrs: String = "0"
            
            if component == 0
            {
                print("\(TenNumbersDataSource[row])")
                //print("\(Qtrs[row])")
                
                tens = TenNumbersDataSource[row].description
                //let qtrs = Qtrs[row].description
                
                routeData?.durationHrs = Int16(tens)!
            }
            else
            {
                // print("\(TenNumbers[row])")
                print("\(DurationQtrsDataSource[row])")
                
                // let tens = TenNumbers[row].description
                qtrs = DurationQtrsDataSource[row].description
                
                routeData?.durationMins = Int16(qtrs)!
            }
            
            //numberString = tens + "." + qtrs
            //routeData?.duration = Float(numberString)!

        }
 */
    }
    
    func pickerShouldReturn(_ pickerView: UIPickerView) -> Bool
    {
        /*
        switch pickerView
        {
        case TerrainPicker:
            DistancePicker.becomeFirstResponder()
        case DistancePicker:
            DurationPicker.resignFirstResponder()

        default:
            DurationPicker.resignFirstResponder()
        }
        */
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


//MARK:- CoreDataManager Protocol
extension RouteProfileViewController: CoreDataManagerDelegate
{
    
    func setCoreDataManager(coreDataManager: CoreDataManager)
    {
        self.coreDataManager = coreDataManager
    }
}
