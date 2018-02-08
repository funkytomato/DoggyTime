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
        

        
        //If mapModel is nil load the user's current location
        if mapModel?.name == "New"
        //if mapModel?.midCoordinate == coordinate
        {
            mapModel?.midCoordinate = (locationManager.location?.coordinate)!
        }
        
        //Load coordinates from CoreData
        //mapOverlay = MapOverlay(map: mapModel!)
        
        configureMapView()
        configureVisibleRegion()
        //centerMapOnALocation(location: (mapModel?.midCoordinate)!)
        
        
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
        //print("MapsViewController prepare segue")
        //print("segue identifer \(String(describing: segue.identifier))")
        //print("segue destination \(String(describing: segue.destination))")
        
        //Prepare the Maps Options View Controller
        if segue.identifier == "segueOptions",
            let optionsController = segue.destination as? MapOptionsViewController
        {
            optionsController.selectedOptions = selectedOptions
        }
        if segue.identifier == "saveRouteDetail"
        {
            print("MapsViewController prepare saveRouteDetail called")
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
            centerMapOnALocation(location: currentLocation.coordinate)
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

    //This function will zoom surrounding the route
            /*
    private func mapRegion() -> MKCoordinateRegion?
    {

        guard
            let locations = run.locations,
            locations.count > 0
            else
        {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)

    }
 */
   
    //Mark:- Create and define the visibl map area
    private func loadVisibleMapAreaFromMapModel()
    {
        let mapCentrePoint = MKMapPoint(x: (mapModel?.midCoordinate.latitude)!, y: (mapModel?.midCoordinate.longitude)!)
        let mapSize = MKMapSize(width: (mapModel?.mapWidth)!, height: (mapModel?.mapHeight)!)
        let mRect = MKMapRect(origin: mapCentrePoint, size: mapSize)
        
        mapView.setVisibleMapRect(mRect, animated: true)
    }
    
    
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
    
    
    func populateMapModel()
    {
        //Get Map Cordinates
        let mRect: MKMapRect = self.mapView.visibleMapRect
        //mapModel?.overlayBoundingMapRect
        
        
        let topLeftCoord = MKMapPointMake( MKMapRectGetMinX(mRect), MKMapRectGetMaxY(mRect))
        let topRightCoord = MKMapPointMake( MKMapRectGetMaxX(mRect), MKMapRectGetMaxY(mRect))
        let bottomLeftCoord = MKMapPointMake( MKMapRectGetMinX(mRect), MKMapRectGetMinY(mRect))
        let bottomRightCoord = MKMapPointMake( MKMapRectGetMaxX(mRect), MKMapRectGetMinY(mRect))
        
        
        //Capture the height and width of the visible map in metres
        let mapWidth = MKMapRectGetWidth(mRect) / 10;
        let mapHeight = MKMapRectGetHeight(mRect) / 10;
        
        
        //Save to the MapModel
        mapModel?.name = "saved"
        mapModel?.midCoordinate = MKCoordinateForMapPoint( MKMapPointMake( MKMapRectGetMidX(mRect), MKMapRectGetMidY(mRect)))
        mapModel?.mapWidth = mapWidth
        mapModel?.mapHeight = mapHeight
        //mapModel?.regionRadius = regionRadius
        //mapModel?.spanLongitudeDelta =
        //mapModel?.spanLongitudeDelta =
        
        mapModel?.overlayTopLeftCoordinate = MKCoordinateForMapPoint(topLeftCoord)
        mapModel?.overlayTopRightCoordinate = MKCoordinateForMapPoint(topRightCoord)
        mapModel?.overlayBottomLeftCoordinate = MKCoordinateForMapPoint(bottomLeftCoord)
        //mapModel?.overlayBottomRightCoordinate = MKCoordinateForMapPoint(bottomRightCoord)
        
        //mapModel?.boundary =
    }
    
    
    //Calculate and return the span of the visible region in metres
    func calculateVisibleSpan() -> Double
    {
        //Get the current view size and set the MapModel regionRadius
        let mRect: MKMapRect = self.mapView.visibleMapRect
        let topCoord = MKMapPointMake( MKMapRectGetMidX(mRect), MKMapRectGetMaxY(mRect))
        let bottomCoord = MKMapPointMake( MKMapRectGetMidX(mRect), MKMapRectGetMinY(mRect))
        let currentDistWideInMeters = MKMetersBetweenMapPoints(topCoord, bottomCoord)
        
        print("saveMapBoundary-currentDistWideInMeters: \(currentDistWideInMeters)")
        
        return currentDistWideInMeters
    }
    
    //NOT CURRENTLY USED BECAUSE THE OVERLAY COORDINATES ARE NOT BEING SET AS OF YET
    //MARK:- Configure the visible Map Region
    func configureVisibleRegion()
    {
        //Config the size/region of the mapview
        var region: MKCoordinateRegion
        guard let spanDistance = mapModel?.regionRadius else { return }
        region = MKCoordinateRegionMakeWithDistance((mapModel?.midCoordinate)!, spanDistance, spanDistance)
        print("span\(spanDistance)")
        mapView.setRegion(region, animated: true)
    }
    
    
    //MARK:- Center the Map on the User's Current Location
    func centerMapOnALocation(location: CLLocationCoordinate2D)
    {
        mapModel?.midCoordinate = location
        print("location\(location)")
        var region = MKCoordinateRegion()
        region.center = (mapModel?.midCoordinate)!
        mapView.setRegion(region, animated: true)
    }
    
    //NOT USED
    func centerMapOnUser(mapView : MKMapView)
    {
        var region = MKCoordinateRegion()
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
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
        //print("We have moved location = didUpdate")
        //mapView.setCenter(didUpdate.coordinate, animated: true)
    }
    

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        //print("Map was moved around = regionDidChangedAnimated")
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
        }
    }
    
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error \(error)")
    }
    
    
    func showUserLocation(locationManager : CLLocationManager, mapView : MKMapView)
    {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse
        {
            locationManager.requestWhenInUseAuthorization()
        }
        else
        {
            mapView.showsUserLocation = true
        }
    }
}
