//
//  MapsViewController.swift
//  DoggyTime
//
//  Created by Jason Fry on 27/12/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData



class MapsViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate
{

    
    //MARK:- Properties
    //Prepare Segue Map Properties
    var mapModel : MapModel? //just this one!
    //var map = MapModel(filename: "MagicMountain")
    //var pointsOfInterest: [PointOfInterest]?  pulled from the mapModel
    var paths: [PathRoute] = []

    

    

    //MARK:- Maps and Overlays Options
    var mapOverlay: MapOverlay!
    var selectedOptions : [MapOptionsType] = []
    fileprivate var annotation: MKAnnotation!
    
    
    //MARK:- The Location Manager
    private let locationManager = LocationManager.shared
    var previousLocation: CLLocation!
    
    
    //MARK:- Path location mapping and timing temporary properties
    //The Saved Recorded Route
    var path: [CLLocation] = []
    var pathDistance = Measurement(value: 0, unit: UnitLength.meters)
    var timeTakenInSeconds = Int16(0)
    
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []

    
    //MARK:- Search for Place Properties
    fileprivate var searchController: UISearchController!
    fileprivate var localSearchRequest: MKLocalSearchRequest!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var localSearchResponse: MKLocalSearchResponse!
    
    
    //MARK:- Activity Indication
    fileprivate var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK:- Outlets
    @IBOutlet weak var mapView: MKMapView!

    
    //
    //MARK:- UIViewController's methods
    //
    required init?(coder aDecoder: NSCoder)
    {
        mapModel = MapModel()
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        print("mapModel:\(String(describing: mapModel))")
        print("pathPoints:\(path.description)")
        
        //Load coordinates from CoreData
        //mapOverlay = MapOverlay(map: mapModel)
        
        //If mapModel is nil load the user's current location
        if mapModel?.name == "New"
        //if mapModel?.midCoordinate == coordinate
        {
            //mapModel?.midCoordinate = (locationManager.location?.coordinate)!
        }
        
        
        configureMapView()
        centerMapOnLocation(location: (mapModel?.midCoordinate)!)
        
        
        //Config the activity monitor
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        activityIndicator.center = self.view.center
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("MapsViewController prepare segue")
        print("segue identifer \(String(describing: segue.identifier))")
        print("segue destination \(String(describing: segue.destination))")
        
        //Prepare the Maps Options View Controller
        if segue.identifier == "segueOptions",
            let optionsController = segue.destination as? MapOptionsViewController
        {
            optionsController.selectedOptions = selectedOptions
        }
    }
    
    func eachSecond()
    {
        timeTakenInSeconds += 1
        updateDisplay()
    }
    
    private func updateDisplay()
    {
        
    }
    
    private func startLocationUpdates()
    {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
    }
    
    func startRecording()
    {
        timeTakenInSeconds = 0
        pathDistance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        {
            _ in self.eachSecond()
        }
        startLocationUpdates()
    }
    
    func stopRecording()
    {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        
        saveRoute()
    }
    
    private func saveRoute()
    {
        path = locationList
        pathDistance = distance
        timeTakenInSeconds = Int16(timeTakenInSeconds)
    }
    
    func locateMe()
    {
        startLocationUpdates()
        
        if let currentLocation = locationList.last
        {
            centerMapOnLocation(location: currentLocation.coordinate)
        }
    }
    
    func searchForLocation()
    {
        
         if searchController == nil
         {
            searchController = UISearchController(searchResultsController: nil)
         }
        
         searchController.hidesNavigationBarDuringPresentation = false
         self.searchController.searchBar.delegate = self
         present(searchController, animated: true, completion: nil)
        
    }
    
}


//MARK:- Map Options View Controller IBActions
extension MapsViewController
{
    
    //MARK:- Close the Maps Options Controller
    @IBAction func closeOptions(_ exitSegue: UIStoryboardSegue)
    {
        guard let vc = exitSegue.source as? MapOptionsViewController else { return }
        selectedOptions = vc.selectedOptions
        loadSelectedOptions()
    }
    
    
    //MARK:- Change the Map Type
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl)
    {
        mapView.mapType = MKMapType.init(rawValue: UInt(sender.selectedSegmentIndex)) ?? .standard
    }
}


//MARK:- Visible Map Region Methods
extension MapsViewController
{

    //MARK:- Configure the UIMapView to show maps
    func configureMapView()
    {
        // For User Tracking
        //Config the mapview to show the user location
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
    
    //Mark:- Calculate the visible Map Region
    func getMapBoundary()
    {
        let mRect: MKMapRect = self.mapView.visibleMapRect
        let eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect))
        let westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect))
        let currentDistWideInMeters = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint)
        let milesWide = currentDistWideInMeters / 1609.34 // number of meters in a mile
        
        //Capture the height and width of the visible map in metres
        let mapWidth = MKMapRectGetWidth(mRect) / 10;
        let mapHeight = MKMapRectGetHeight(mRect) / 10;
        
        print("milesWide: \(milesWide)")
        print("mapWidth:\(mapWidth)")
        print("mapHeight:\(mapHeight)")
        
        //mapModel.midCoordinate = mapView.centerCoordinate
        //mapModel.overlayTopLeftCoordinate = mapView
        //mapModel.overlayTopRightCoordinate = mapView
        //mapModel.overlayBottomLeftCoordinate = mapView
        //mapModel.overlayBottomRightCoordinate = mapView
        
        
    }
    
    
    //NOT CURRENTLY USED BECAUSE THE OVERLAY COORDINATES ARE NOT BEING SET AS OF YET
    //MARK:- Configure the visible Map Region
    func configureVisibleRegion()
    {
        //Config the size/region of the mapview
        let latDelta = (mapModel?.overlayTopLeftCoordinate.latitude)! - (mapModel?.overlayBottomRightCoordinate.latitude)!
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        let region = MKCoordinateRegionMake((mapModel?.midCoordinate)!, span)
        
        mapView.region = region
        
        
        //let regionRadius: CLLocationDistance = 1000
        //guard let regionRadius = mapModel?.regionRadius else { return }
        //let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, regionRadius, regionRadius)
    }
    
    
    //MARK:- Center the Map on the User's Current Location
    func centerMapOnLocation(location: CLLocationCoordinate2D)
    {
        mapModel?.midCoordinate = location
        
        print("mapModel lat:\(String(describing: mapModel?.midCoordinate.latitude)) longitude:\(String(describing: mapModel?.midCoordinate.longitude))")
    }
}


//MARK:- Annotations, Map Overlays and Routes
extension MapsViewController
{
    
    
    //MARK:- Add the Map Overlay
    func addOverlay()
    {
        let overlay = MapOverlay(map: mapModel!)
        mapView.add(overlay)
    }
    
    
    //MARK:- Add Point Of Interest Pins
    func addPointOfInterestPins()
    {
        guard let attractions = MapModel.plist("MagicMountainAttractions") as? [[String : String]] else {return}
        
        for attraction in attractions
        {
            let coordinate = MapModel.parseCoordDict(dict: attraction, fieldName: "location")
            let title = attraction["name"] ?? ""
            let typeRawValue = Int(attraction["type"] ?? "0") ?? 0
            let type = PointOfInterestType(rawValue: typeRawValue) ?? .misc
            let subtitle = attraction["subtitle"] ?? ""
            let annotation = PointOfInterestAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
            mapView.addAnnotation(annotation)
        }
    }
    
    
    //MARK:- Add Route
    func addRoute()
    {
        //guard let points = MapModel.plist("EntranceToGoliathRoute") as? [String] else { return }
        
        
        if paths.count > 0
        {
            for path in paths
            {
                let pathPoints = path.pathPoints
                var coords = [CLLocationCoordinate2D].init()
                
                for point in pathPoints
                {
                    let coord = CLLocationCoordinate2DMake(CLLocationDegrees(point.coordinate.latitude), CLLocationDegrees(point.coordinate.longitude))
                    coords.append(coord)
                }
                
                //Draw the route/path
                let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
                mapView.add(myPolyline)
            }
        }
        
 /*
        let pathPoints = self.path
        var coords = [CLLocationCoordinate2D].init()
        
        for point in pathPoints
        {
            let coord = CLLocationCoordinate2DMake(CLLocationDegrees(point.coordinate.latitude), CLLocationDegrees(point.coordinate.longitude))
            coords.append(coord)
        }
   */
        
        //Draw the route/path
  //      let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
  //      mapView.add(myPolyline)
    }
    
    
    //MARK:- Add Boundary
    func addBoundary()
    {
        mapView.add(MKPolygon(coordinates: (mapModel?.boundary)!, count: (mapModel?.boundary.count)!))
    }
    
    
    //MARK:- Add Character locations
    func addCharacterLocation()
    {
        //mapView.add(Character(filename: "BatmanLocations", color: .blue))
        //mapView.add(Character(filename: "TazLocations", color: .orange))
        //mapView.add(Character(filename: "TweetyBirdLocations", color: .yellow))
    }
    
    
    func addAnnotationToMap()
    {
        //Create a Point Of Interest and add to the map
        let coordinate = locationManager.location?.coordinate
        let title = "NEW ANNOTATION!!!"
        let type = PointOfInterestType(rawValue: 1) ?? .poo
        let subtitle = "Subtitle"
        let annotation = PointOfInterestAnnotation(coordinate: coordinate!, title: title, subtitle: subtitle, type: type)
        mapView.addAnnotation(annotation)
    }
    
    
    //MARK:- Add Annotation to map view from dictionary
    func addAnnotationsOnMap(locationToPoint: CLLocation)
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks, placemarks.count > 0
            {
                let placemark = placemarks[0]
                var addressDictionary = placemark.addressDictionary
                annotation.title = addressDictionary!["Name"] as? String
                self.mapView.addAnnotation(annotation)
            }
            
        })
    }
    
    
    //MARK:- Draw Route on Map
    func drawPath(newLocation: CLLocation!, fromLocation oldLocation: CLLocation!)
    {
        //Draw the route/path
        if let oldLocationNew = oldLocation as CLLocation?
        {
            print("present location : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
            
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.add(polyline)
        }
        
        //Calculation for location selection and pointing annotation
        if let previousLocationNew = previousLocation as CLLocation?
        {
            addAnnotationsOnMap(locationToPoint: newLocation)
            previousLocation = newLocation
        }
        else
        {
            //In case previous location doesn't exist
            addAnnotationsOnMap(locationToPoint: newLocation)
            previousLocation = newLocation
        }
    }
    
    
    // MARK: Helper methods
    func loadSelectedOptions()
    {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        for option in selectedOptions
        {
            switch (option)
            {
                case .mapOverlay:
                    self.addOverlay()
                case .mapPins:
                    self.addPointOfInterestPins()
                case .mapRoute:
                    self.addRoute()
                case .mapBoundary:
                    self.addBoundary()
                case .mapCharacterLocation:
                    self.addCharacterLocation()
            }
        }
    }
}


//MARK:- Maps Searching
extension MapsViewController
{
    
    // MARK: - Location UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        if self.mapView.annotations.count != 0
        {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        
        //Create a search request
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        print("localSearch\(localSearch.description)")
        localSearch.start { [weak self] (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil
            {
                let alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            
            
            //Search for the coordinates for the location entered
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            
            //Centre the view on the new location
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "PointOfInterest")   //nil
            self!.mapView.centerCoordinate = pointAnnotation.coordinate
            self!.mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }
}


//MARK:- MKMapView Delegate Methods
extension MapsViewController
{
    
    //MARK:- MKMapView delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        
        if overlay is MapOverlay
        {
            return MapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "overlay_park"))
        }
        else if overlay is MKPolyline
        {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.green
            return lineView
        }
        else if overlay is MKPolygon
        {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.magenta
            return polygonView
        }
        else if let character = overlay as? Character
        {
            let circleView = MKCircleRenderer(overlay: character)
            circleView.strokeColor = character.color
            return circleView
        }
        
        return MKOverlayRenderer()
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let annotationView = PointOfInterestAnnotationView(annotation: annotation, reuseIdentifier: "PointOfInterest")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate: MKUserLocation)
    {
        print("We have moved location = didUpdate")
//        mapView.setCenter(didUpdate.coordinate, animated: true)
    }
    

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        print("Map was moved around = regionDidChangedAnimated")
        let span = mapView.region.span
        print ("span:\(span)")
        

        //getMapBoundary()
        //configureVisibleRegion()
        centerMapOnLocation(location: mapView.centerCoordinate)
        //print("centreCoordinate:\(mapView.centerCoordinate)")
    }
}


//MARK:- CLLocationManager Delegate Methods
extension MapsViewController : CLLocationManagerDelegate
{
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        for newLocation in locations
        {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last
            {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                drawPath(newLocation: newLocation, fromLocation: lastLocation)
            }
            
            locationList.append(newLocation)
            
            //addAnnotationToMap()
            
        }
    }
    
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error \(error)")
    }
}


//let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

// let regionRadius: CLLocationDistance = 1000
// let coordinateRegion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, regionRadius, regionRadius)


//Config the size/region of the mapview
//let latDelta = mapModel.overlayTopLeftCoordinate.latitude - mapModel.overlayBottomRightCoordinate.latitude
//let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
//let region = MKCoordinateRegionMake(mapModel.midCoordinate, span)


//mapView.region = coordinateRegion
