//
//  MapsViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 27/12/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate
{
    
    
    //MARK:- Properties to be set on prepare
    //var mapData: Map?
    var mapModel : MapModel? //just this one!
    
    
    
    //var locationName : String? //and this too
    var pointsOfInterest: [PointOfInterest]?
    var path : [Path]?
    
    
    //MARK:- Overlay variables
    var mapOverlay: MapOverlay! //and maybe this one!
    var selectedOptions : [MapOptionsType] = []
    //var map = MapModel(filename: "MagicMountain")

    
    //MARK:- Map variables
    fileprivate var locationManager: CLLocationManager!
    fileprivate var isCurrentLocation: Bool = false
    fileprivate var annotation: MKAnnotation!
    fileprivate var loggingRoute: Bool = false
    //fileprivate var currentLocation : CLLocationCoordinate2D
    
    
    //MARK:- Route variables
    var previousLocation: CLLocation!
    
    
    //MARK:- Search variable
    fileprivate var searchController: UISearchController!
    fileprivate var localSearchRequest: MKLocalSearchRequest!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var localSearchResponse: MKLocalSearchResponse!
    
    
    //MARK:- Activity Indication
    fileprivate var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK:- Outlets
    @IBOutlet weak var mapView: MKMapView!

    
    //MRK:- Locate User on map
    @IBAction func locateMeButton(_ sender: UIBarButtonItem)
    {
        configureLocationManager()
    }
    
    
    // MARK: - Search
    @IBAction func searchButton(_ sender: UIBarButtonItem)
    {
        if searchController == nil
        {
            searchController = UISearchController(searchResultsController: nil)
        }
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

    
    @IBAction func PointOfinterestButton(_ sender: Any)
    {

        configureLocationManager()
        

        //Create a Point Of Interest and add to the map
        let coordinate = locationManager.location?.coordinate
        let title = "NEW ANNOTATION!!!"
        let type = PointOfInterestType(rawValue: 1) ?? .poo
        let subtitle = "Subtitle"
        let annotation = PointOfInterestAnnotation(coordinate: coordinate!, title: title, subtitle: subtitle, type: type)
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func recordButton(_ sender: Any)
    {
        
        //Set loggingRoute variable
        if loggingRoute
        {
                loggingRoute = false
        }
        else
        {
            loggingRoute = true
        }
        
        configureLocationManager()
    }
    
    
    func configureLocationManager()
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            if locationManager == nil
            {
                locationManager = CLLocationManager()
            }
            
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            isCurrentLocation = true
        }
    }
    
    
    func configureMapView()
    {
        // For User Tracking
        //Config the mapview to show the user location
        mapView.delegate = self
        mapView.mapType = .standard
        //mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        mapModel = MapModel()
        
        super.init(coder: aDecoder)
    }
    
    
    //MARK:- UIViewController's methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()


        //Load coordinates from CoreData
        //mapOverlay = MapOverlay(map: mapModel)
    
        //If mapModel is nil load the user's current location
        if mapModel?.midCoordinate == nil
        {
            configureLocationManager()
            mapModel?.midCoordinate = (locationManager.location?.coordinate)!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("MapsViewController prepare segue")
        print("segue identifer \(String(describing: segue.identifier))")
        print("segue destination \(String(describing: segue.destination))")
        
        //(segue.destination as? MapOptionsViewController)?.selectedOptions = selectedOptions
        if segue.identifier == "segueOptions",
            let optionsController = segue.destination as? MapOptionsViewController
        {
            optionsController.selectedOptions = selectedOptions
        }
    }
    
    @IBAction func closeOptions(_ exitSegue: UIStoryboardSegue) {
        guard let vc = exitSegue.source as? MapOptionsViewController else { return }
        selectedOptions = vc.selectedOptions
        loadSelectedOptions()
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        mapView.mapType = MKMapType.init(rawValue: UInt(sender.selectedSegmentIndex)) ?? .standard
    }
    
    
    //NOT CURRENTLY USED BECAUSE THE OVERLAY COORDINATES ARE NOT BEING SET AS OF YET
    func configureVisibleRegion()
    {
        //Config the size/region of the mapview
        let latDelta = (mapModel?.overlayTopLeftCoordinate.latitude)! - (mapModel?.overlayBottomRightCoordinate.latitude)!
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        let region = MKCoordinateRegionMake((mapModel?.midCoordinate)!, span)
        mapView.region = region
    }
    
    
    //Center map on location
    func centerMapOnLocation(location: CLLocationCoordinate2D)
    {
        
        let regionRadius: CLLocationDistance = (mapModel?.regionRadius)!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        

        mapModel?.midCoordinate = location
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        print("mapModel lat:\(mapModel?.midCoordinate.latitude) longitude:\(mapModel?.midCoordinate.longitude)")
    }
    
    
    
    //MARK: Add the map overlay
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
        guard let points = MapModel.plist("EntranceToGoliathRoute") as? [String] else { return }
        
        let cgPoints = points.map { CGPointFromString($0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
        
        mapView.add(myPolyline)
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

    
    //Add annotation to map view from dictionary
    func addAnnotationsOnMap(locationToPoint: CLLocation)
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks as? [CLPlacemark], placemarks.count > 0
            {
                let placemark = placemarks[0]
                var addressDictionary = placemark.addressDictionary
                annotation.title = addressDictionary!["Name"] as? String
                self.mapView.addAnnotation(annotation)
            }
            
        })
    }
    
    
    
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
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.centerCoordinate, regionRadius, regionRadius)
        
        //mapModel.midCoordinate = mapView.centerCoordinate
        //mapModel.overlayTopLeftCoordinate = mapView
        //mapModel.overlayTopRightCoordinate = mapView
        //mapModel.overlayBottomLeftCoordinate = mapView
        //mapModel.overlayBottomRightCoordinate = mapView.
        
        print("centreCoordinate:\(mapView.centerCoordinate)")
        //self.mapModel?.midCoordinate = mapView.centerCoordinate
        centerMapOnLocation(location: mapView.centerCoordinate)
    }
    
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation], newLocation: CLLocation!, fromLocation oldLocation: CLLocation!)
    //func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        if !isCurrentLocation
        {
            return
        }
        
        isCurrentLocation = false
        
        
        let location = locations.last
        //let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
       // let regionRadius: CLLocationDistance = 1000
       // let coordinateRegion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, regionRadius, regionRadius)
        
        
        //Config the size/region of the mapview
        //let latDelta = mapModel.overlayTopLeftCoordinate.latitude - mapModel.overlayBottomRightCoordinate.latitude
        //let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        //let region = MKCoordinateRegionMake(mapModel.midCoordinate, span)
        
        
        //mapView.region = coordinateRegion
        
        centerMapOnLocation(location: (location?.coordinate)!)
        
        
        //currentLocation = center
        
        //self.mapView.setRegion(region, animated: true)

     
        if self.mapView.annotations.count != 0
        {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        if loggingRoute
        {
            drawPath(newLocation: newLocation, fromLocation: oldLocation)
        }
    }
    
    
    //Create and draw the path on the map
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
            //IN case previous location doesn't exist
            addAnnotationsOnMap(locationToPoint: newLocation)
            previousLocation = newLocation
        }
    }
}
