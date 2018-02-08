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
    weak var routeData: Route?
    weak var mapData: Map?
    weak var pathData: Path?
    
    
    //MARK:- Path recording Properties
    var timer: Timer?
    var savedPaths: [PathRoute] = []
    var pathPoints: [CLLocation] = []
    var pathDistance = Measurement(value: 0, unit: UnitLength.meters)
    var timeTakenInSeconds = Int16(0)
    
    var previousLocation: CLLocation!
    fileprivate var isCurrentLocation: Bool = false
    fileprivate var loggingRoute: Bool = false
    
    //MARK:- Embedded MapsViewController
    fileprivate var embeddedMapsViewController: MapsViewController!

    
    //Points of Interest
    var pointsOfInterest: [MKAnnotation] = []
    
    
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
            let alertController = UIAlertController(title: "End walk?",
                                                    message: "Do you wish to end your walk?",
                                                    preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.embeddedMapsViewController.stopRecording()
                self.embeddedMapsViewController.populateMapModel()
                self.performSegue(withIdentifier: "saveRouteDetail", sender: nil)
                self.saveCoreData()
                
            })
            
            alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
                self.embeddedMapsViewController.stopRecording()
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            
            present(alertController, animated: true)
            
            
            button.setTitle("Record", for: .normal)
            button.backgroundColor = UIColor.clear
         
            loggingRoute = false
            
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
        ////print("RouteProfileViewController init")
        
        super.init(coder: aDecoder)
    }
    
    
    deinit
    {
        ////print("RouteProfileViewController deinit")
    }
    
    
    override func viewDidLoad()
    {
        ////print("RouteProfileViewController viewDidLoad")
        super.viewDidLoad()
         
        
        if routeData != nil
        {
            guard let placeName = routeData?.placeName else { return }
            self.placeNameField.text = placeName
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        ////print("RouteProfileViewController didRecieveMemoryWarning")
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
}

extension RouteProfileViewController
{

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        ////print("RouteProfileViewController prepare segue identifier:\(String(describing: segue.identifier))")
        ////print("RouteProfileViewController prepare segue source:\(segue.source)")
        ////print("RouteProfileViewController prepare segue destination:\(segue.destination)")
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "mapsEmbeddedSegue",
            let navController = segue.destination as? UINavigationController
        {
            let mapsViewController = navController.topViewController as? MapsViewController
            self.embeddedMapsViewController = mapsViewController
            
            
            ////print("mapsEmbeddedSegue routeData mapProfile")
            ////print("routeData.mapProfile.midLatitudeCoordinate:\(String(describing: routeData?.mapProfile?.midLatitudeCoordinate))")
            ////print("routeData.mapProfile.midLongitudeCoordinate:\(String(describing: routeData?.mapProfile?.midLongitudeCoordinate))")
            ////print("routeData.mapProfile.overlayTopLeftCoordinate:\(String(describing: routeData?.mapProfile?.overlayTopLeftCoordinate))")
            ////print("routeData.mapProfile.overlayTopRightCoordinate:\(String(describing: routeData?.mapProfile?.overlayTopRightCoordinate))")
            ////print("routeData.mapProfile.overlayBottomLeftCoordinate:\(String(describing: routeData?.mapProfile?.overlayBottomLeftCoordinate))")
            
           /*
            //Fetch possible map data
            let mapData = (routeData?.mapProfile)!
            self.mapData = mapData
            
            //Fetch possible path data
            let pathPoints = self.mapData?.path
            
            //Fetch possible points of interest
            //let pointsOfInterest = (self.mapData?.pointsofinterest)!
            
            
            //Create and populate the MapModel
            let mapModel = MapModel()
            mapModel.name = routeData?.placeName
            
            let latitude = routeData?.mapProfile?.midLatitudeCoordinate
            let longitude = routeData?.mapProfile?.midLongitudeCoordinate
            let midCoordinate = MapModel.mapCoordinate(latitude: latitude!, longitude: longitude!)
            mapModel.midCoordinate = midCoordinate
            
            ////print("midCoordinate: \(midCoordinate)")
          */
      
            //Create and populate the MapModel
            let mapModel = MapModel()
            
            if routeData != nil
            {
   
                guard let locationName = routeData?.placeName else { return }
                
                
                //Check routeData mapProfile exists
                //var map = Map(context: coreDataManager.mainManagedObjectContext)
                guard let mapData = routeData?.mapProfile else { return }
                
                if mapData != nil
                {
                    mapModel.name = locationName
                    
                    //Get the Latitude and Longitude from the associated Map CoreData
                    let latitude = mapData.midLatitudeCoordinate
                    let longitude = mapData.midLongitudeCoordinate
                    
                    
                    print("mapsEmbeddedSegue prepare latitude:\(latitude)")
                    print("mapsEmbeddedSegue prepare longitude:\(longitude)")
                    
                    
                    //Create the centre coordinate and set the mapModel midCoordinate
                    let midCoordinate = MapModel.mapCoordinate(latitude: latitude, longitude: longitude)
                    mapModel.midCoordinate = midCoordinate
                    print("midCoordinate: \(midCoordinate)")
                    
                    let mapWidth = mapData.mapWidth
                    mapModel.mapWidth = mapWidth
                    
                    let mapHeight = mapData.mapHeight
                    mapModel.mapHeight = mapHeight
                    
                    let span = mapData.regionRadius
                    mapModel.regionRadius = span
                    print("mapModel regionRadius\(mapModel.regionRadius)")
                    print("mapData regionRadius\(mapData.regionRadius)")
                    
                    
                    //Get any Points of Interest associated to this map
                    //let pointsofinterest = Array(map?.pointsofinterest)
                    //Load the points of interest
                    
                    
                    //var pointsOfInterest: [] = []
                    let pointsofinterest = Array(mapData.pointsofinterest!)
                    guard let validpointsofinterest = Array(pointsofinterest) as? [PointOfInterest] else { return }
                    if validpointsofinterest.count > 0
                    {
                        for poi in validpointsofinterest
                        {
                            //let validPOI = MKAnnotation()
                        }
                        
                        //self.pointsOfInterest = validpointsofinterest
                    }
                    
              
                    //Get the Path data associated to this map
                    guard let pathData = mapData.paths else { return }
                    ////print("pathData:\(pathData.description)")
                    
                    
                    //Create an array of PathRoutes from Path CoreData
                    //Get the
                    var paths = Array(mapData.paths!)
                    guard let validPaths = Array(paths) as? [Path] else { return }
                    
                    if validPaths.count > 0
                    {
                        ////print("validPaths:\(validPaths)")
                        
        
                        for path in validPaths
                        {
                            ////print("path:\(path)")
                            var pathRoute : PathRoute
                            
                            guard let validPoints = path.locations else { return }
                            let newPoints = Array(validPoints) as? [Location]
                            
                            var pathPoints : [CLLocation] = []
                            for point in newPoints!
                            {
                                let pathPoint = CLLocation(latitude: CLLocationDegrees(point.latitude), longitude: CLLocationDegrees(point.longitude))
                                pathPoints.append(pathPoint)
                            }
                            
                            pathRoute = PathRoute(pathName: "newPath",points: pathPoints)
                            savedPaths.append(pathRoute)
                            
                            //Legacy
                            self.pathPoints = pathPoints
                        }
                        
                        print("savedPaths\(self.savedPaths)")
                        
                        embeddedMapsViewController.path = pathPoints
                    }
                }
                
                //Configure the MapsViewController
                embeddedMapsViewController.mapModel = mapModel
                embeddedMapsViewController.path = pathPoints
                embeddedMapsViewController.paths = savedPaths
                //embeddedMapsViewController.pointsOfInterest = pointsOfInterest
            }

            
            
            //Load the boundaries into the MapModel
            /*
            mapModel.name = locationName
            
            mapModel.midCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.midCoordinate)!)
            mapModel.overlayTopLeftCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.overlayTopLeftCoordinate)!)
            mapModel.overlayTopRightCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.overlayTopRightCoordinate)!)
            mapModel.overlayBottomLeftCoordinate = MapModel.parseCoord(location: (routeData?.mapProfile?.overlayBottomLeftCoordinate)!)
        
            ////print("mapModel.name:\(mapModel.name)")
            ////print("mapModel.midCoordinate:\(mapModel.midCoordinate)")
            ////print("mapModel.overlayTopLeftCoordinate:\(mapModel.overlayTopLeftCoordinate)")
            ////print("mapModel.overlayTopRightCoordinate:\(mapModel.overlayTopRightCoordinate)")
            ////print("mapModel.overlayBottomLeftCoordinate:\(mapModel.overlayBottomLeftCoordinate)")
            */
        }
        
        
        if segue.identifier == "saveRouteDetail"
        {
            
            //Need to set the MapModel within the MapsViewCOontroller before calling prepare
            embeddedMapsViewController?.populateMapModel()
            
            //Get the latest data and pass to destinationController to be saved
            guard let locationName = placeNameField.text else { return }
            guard let mapModel = embeddedMapsViewController?.mapModel else { return }
            guard let pathPoints = embeddedMapsViewController?.path else { return }
            self.pathPoints = pathPoints
            
            
            //savePath()
            
            ////print("Save Route Detail")
            
            
            //Create the CoreData classes, Map, Path and Location
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
            
            mapData?.addToPaths(path)
            mapData?.updatedAt = Date()
            
            
            
            //Create a CoreData Map profile
            //let map = Map(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Map object with mapModel values
            mapData?.uuid = "uuid"
            mapData?.updatedAt = Date()
            mapData?.createdAt = Date()
            mapData?.name = locationName
            mapData?.midLatitudeCoordinate = mapModel.midCoordinate.latitude
            mapData?.midLongitudeCoordinate = mapModel.midCoordinate.longitude
            mapData?.latitudeDelta = mapModel.spanLatitudeDelta
            mapData?.longitudeDelta = mapModel.spanLongitudeDelta
            mapData?.regionRadius = mapModel.regionRadius
            mapData?.mapWidth = mapModel.mapWidth
            mapData?.mapHeight = mapModel.mapHeight

            mapData?.mapFor = routeData
            
            
            print("regionRadius\(mapData?.regionRadius)")
            print("regionRadius\(mapModel.regionRadius)")
            print("mapWidth:\(mapData?.mapWidth)")
            print("mapHeight:\(mapData?.mapHeight)")
            
            //Update Route
            routeData?.placeName = locationName
            routeData?.mapProfile = mapData
            routeData?.updatedAt = Date()
            
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
            
            self.pathData = path
            
            print ("routeData\(routeData?.mapProfile?.description)")
        }
    }
    

    
    func saveCoreData()
    {
        //Store to CoreData
        do
        {
            try routeData?.managedObjectContext?.save()
            try mapData?.managedObjectContext?.save()
            try pathData?.managedObjectContext?.save()
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Path")
            print("\(saveError), \(saveError.localizedDescription)")
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
            ////print(TerrainDataSource[row])
            
            routeData?.terrain = TerrainDataSource[row]
        }
        else if pickerView == DistancePicker
        {
            var tens: String = "0"
            var qtrs: String = "0"
            
            if component == 0
            {
                ////print("\(TenNumbersDataSource[row])")
                //////print("\(Qtrs[row])")
                
                tens = TenNumbersDataSource[row].description
                //let qtrs = Qtrs[row].description
                routeData?.distanceMiles = Int16(tens)!
            }
            else
            {
               // ////print("\(TenNumbers[row])")
                ////print("\(DistanceQtrDataSource[row])")
                
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
                ////print("\(TenNumbersDataSource[row])")
                //////print("\(Qtrs[row])")
                
                tens = TenNumbersDataSource[row].description
                //let qtrs = Qtrs[row].description
                
                routeData?.durationHrs = Int16(tens)!
            }
            else
            {
                // ////print("\(TenNumbers[row])")
                ////print("\(DurationQtrsDataSource[row])")
                
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
