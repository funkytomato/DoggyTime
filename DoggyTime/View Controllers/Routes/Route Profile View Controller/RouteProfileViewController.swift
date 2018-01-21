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



//class RouteProfileViewController: UITableViewController
class RouteProfileViewController: UIViewController
{
    
    // MARK: - Core Data Properties
    var coreDataManager: CoreDataManager!
    var coreDataManagerDelegate: CoreDataManagerDelegate!
    
    
    //CoreData Classes
    var routeData: Route?
    var mapData: Map?
    var pathData: Path?
    
    
    //MARK:- Path recording Properties
    var timer: Timer?
    var pathPoints: [CLLocation] = []
    var pathDistance = Measurement(value: 0, unit: UnitLength.meters)
    var timeTakenInSeconds = Int16(0)
    
    var previousLocation: CLLocation!
    fileprivate var isCurrentLocation: Bool = false
    fileprivate var loggingRoute: Bool = false
    
    //MARK:- Embedded MapsViewController
    fileprivate var embeddedMapsViewController: MapsViewController!
/*
    var durationHrs: Int?
    var durationMins: Int?
    var distanceMiles: Int?
    var distanceQtrs: Int?
*/
    
    //Picker DataSources
    var TerrainDataSource = ["Sandy","Grass","RiverSide","Hilly","Beach"]
    
    var numberString: String = ""
    

    
    //MARK:- IBOutlets
    @IBOutlet weak var placeNameField: UITextField!
    @IBAction func POIButton(_ sender: Any)
    {
        //addAnnotationToMap()
    }
    
    @IBAction func RecordButton(_ sender: Any)
    {
        
         guard let button = sender as? UIButton else { return }
         
         //Set loggingRoute variable
         if loggingRoute
         {
            button.setTitle("Record", for: .normal)
            button.backgroundColor = UIColor.clear
         
            loggingRoute = false
            embeddedMapsViewController.stopRecording()
         }
         else
         {
            button.setTitle("Recording", for: .normal)
            button.backgroundColor = UIColor.red
         
            loggingRoute = true
            embeddedMapsViewController.startRecording()
         }
        
    }
    
    @IBAction func LocateMeButton(_ sender: Any)
    {
        
        embeddedMapsViewController.locateMe()
        
    }
    
    @IBAction func SearchButton(_ sender: Any)
    {
        embeddedMapsViewController.searchForLocation()
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
            
            
            print("mapsEmbeddedSegue routeData mapProfile")
            print("routeData.mapProfile.midLatitudeCoordinate:\(String(describing: routeData?.mapProfile?.midLatitudeCoordinate))")
            print("routeData.mapProfile.midLongitudeCoordinate:\(String(describing: routeData?.mapProfile?.midLongitudeCoordinate))")
            print("routeData.mapProfile.overlayTopLeftCoordinate:\(String(describing: routeData?.mapProfile?.overlayTopLeftCoordinate))")
            print("routeData.mapProfile.overlayTopRightCoordinate:\(String(describing: routeData?.mapProfile?.overlayTopRightCoordinate))")
            print("routeData.mapProfile.overlayBottomLeftCoordinate:\(String(describing: routeData?.mapProfile?.overlayBottomLeftCoordinate))")
            
            
            if routeData != nil
            {
   
                guard let locationName = routeData?.placeName else { return }
                
                //Create the MapModel
                let mapModel = MapModel()
                mapModel.name = "New"
                
                //Check routeData mapProfile exists
                if routeData?.mapProfile != nil
                {
                    guard let mapProfile = routeData?.mapProfile else { return }
                    print("parseCoord:\(parseCoord(location: mapProfile.midLatitudeCoordinate.description))")
                    print("parseCoord:\(parseCoord(location: mapProfile.midLongitudeCoordinate.description))")
                    
                    let latitude = routeData?.mapProfile?.midLatitudeCoordinate as? String
                    let longitude = routeData?.mapProfile?.midLongitudeCoordinate as? String
                    
                    let midCoordinate = MapModel.createCoordinate(latitude: latitude!, longitude: longitude!)
                    print("midCoordinate: \(midCoordinate)")
                    
                    mapModel.midCoordinate = midCoordinate
                    //let pointsofinterest = Array(map?.pointsofinterest)
                }
                
                //Configure the MapsViewController
                embeddedMapsViewController.mapModel = mapModel
                
            }
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
                
                
                
                //Configure the MapsViewController
                //mapsViewController?.mapData = map
                mapsViewController?.mapModel = mapModel
            }
            

            

            

            
            //let midC = parseCoord(location: coord)
            
            //Load the boundaries into the MapModel
            /*
            mapModel.name = locationName
            
            mapModel.midCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.midCoordinate)!)
            mapModel.overlayTopLeftCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.overlayTopLeftCoordinate)!)
            mapModel.overlayTopRightCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.overlayTopRightCoordinate)!)
            mapModel.overlayBottomLeftCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.overlayBottomLeftCoordinate)!)
        
            print("mapModel.name:\(mapModel.name)")
            print("mapModel.midCoordinate:\(mapModel.midCoordinate)")
            print("mapModel.overlayTopLeftCoordinate:\(mapModel.overlayTopLeftCoordinate)")
            print("mapModel.overlayTopRightCoordinate:\(mapModel.overlayTopRightCoordinate)")
            print("mapModel.overlayBottomLeftCoordinate:\(mapModel.overlayBottomLeftCoordinate)")
            */
            
            //THINK I AM OVRCASTING, coord has too much ascii content, something wrong
            

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
            
            savePath()
            
            print("Save Route Detail")
            print("mapModel-midCoordinate:\(mapModel.midCoordinate)")
            print("mapModel.overlayTopLeftCoordinate:\(mapModel.overlayTopLeftCoordinate)")
            print("mapModel.overlayTopRightCoordinate:\(mapModel.overlayTopRightCoordinate)")
            print("mapModel.overlayBottomLeftCoordinate:\(mapModel.overlayBottomLeftCoordinate)")
            print("mapModel.overlayBottomRightCoordinate:\(mapModel.overlayBottomRightCoordinate)")
            
            
            
            //Create a CoreData Map profile
            //let map = Map(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Map object with mapModel values
            mapData?.uuid = ""
            mapData?.updatedAt = Date()
            mapData?.createdAt = Date()
            
            
            
            mapData?.name = locationName
            //map.midLatitudeCoordinate = String(describing: mapModel.midCoordinate.latitude)
            //map.midLongitudeCoordinate = String(describing: mapModel.midCoordinate.longitude)
            mapData?.midLatitudeCoordinate = mapModel.midCoordinate.latitude
            mapData?.midLongitudeCoordinate = mapModel.midCoordinate.longitude
            
            
            //map.overlayBottomLeftCoordinate = String(describing: mapModel.overlayTopLeftCoordinate)
            //map.overlayBottomRightCoordinate = String(describing: mapModel.overlayTopRightCoordinate)
            //map.overlayTopLeftCoordinate = String(describing: mapModel.overlayBottomLeftCoordinate)
            //map.overlayTopRightCoordinate = String(describing: mapModel.overlayBottomRightCoordinate)
            //map.overlayBottomLeftCoordinate = mapModel.overlayTopLeftCoordinate
            //map.overlayBottomRightCoordinate = mapModel.overlayTopRightCoordinate
            //map.overlayTopLeftCoordinate = mapModel.overlayBottomLeftCoordinate
            //map.overlayTopRightCoordinate = mapModel.overlayBottomRightCoordinate
            
            
            mapData?.mapFor = routeData
            
    
            //map.pointsofinterest = pointsOfInterest
            //map.path: NSSet?

            
            
            //Update Route
            routeData?.placeName = locationName
            routeData?.mapProfile = mapData
            
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
    

    
    func savePath()
    {
        print("savePath")
        
        
       
        //Create the CoreData classes, Map, Path and Location
        createPath()
        
        //Store to CoreData
        do
        {
            try mapData?.managedObjectContext?.save()
            
            print("RouteProfileViewController savePathDetail map:\(mapData?.description)")
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Path")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
    
    func createPath()
    {
        guard let mapModel = embeddedMapsViewController.mapModel else { return }
        
        
        //Create a CoreData Path object
        let path = Path(context: coreDataManager.mainManagedObjectContext)
        
        //Populate Path object with path data
        path.uuid = ""
        path.createdAt = Date()
        path.updatedAt = Date()
        
        //Create the Path from the MapsViewController locationList
        for pathNode in pathPoints
        {
            //Create a CoreData Location object
            let location = Location(context: coreDataManager.mainManagedObjectContext)
            
            //Populate the Location object with path data
            location.uuid = ""
            location.createdAt = Date()
            location.updatedAt = Date()
            location.latitude = pathNode.coordinate.latitude
            location.longitude = pathNode.coordinate.longitude
            
            path.addToLocations(location)
        }
        
        mapData?.addToPath(path)
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

//MARK:- IBActions - Map Controls
extension RouteProfileViewController
{
    
    //MRK:- Locate User on map
    @IBAction func locateMeButton(_ sender: UIBarButtonItem)
    {
        /*
        startLocationUpdates()
        
        if let currentLocation = locationList.last
        {
            centerMapOnLocation(location: currentLocation.coordinate)
        }
 */
    }
    
    
    // MARK: - Search for Location
    @IBAction func searchButton(_ sender: UIBarButtonItem)
    {
        /*
        if searchController == nil
        {
            searchController = UISearchController(searchResultsController: nil)
        }
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
 */
    }
    
    
    //MARK:- Create and Add a Point Of Interest at current location
    @IBAction func PointOfinterestButton(_ sender: Any)
    {
   //     addAnnotationToMap()
    }
    
    
    //MARK:- Start / Stop Logging Route
    @IBAction func recordButton(_ sender: Any)
    {
        /*
        guard let button = sender as? UIButton else { return }
        
        //Set loggingRoute variable
        if loggingRoute
        {
            button.setTitle("Record", for: .normal)
            button.backgroundColor = UIColor.clear
            
            loggingRoute = false
            stopRecording()
        }
        else
        {
            button.setTitle("Recording", for: .normal)
            button.backgroundColor = UIColor.red
            
            loggingRoute = true
            startRecording()
        }
 */
    }
}

//MARK:- CoreDataManager Protocol
extension RouteProfileViewController: CoreDataManagerDelegate
{
    
    func setCoreDataManager(coreDataManager: CoreDataManager)
    {
        self.coreDataManager = coreDataManager
    }
}
