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


class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate
{
    
    //MARK:- Outlets
    
    @IBOutlet weak var mapView: MKMapView!

    
    //MRK:- Locate User on map
    @IBAction func locateMeButton(_ sender: UIBarButtonItem)
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
            locationManager?.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            isCurrentLocation = true
        }
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
    
    
    
    //MARK:- Map variables
    fileprivate var locationManager: CLLocationManager!
    fileprivate var isCurrentLocation: Bool = false
    fileprivate var annotation: MKAnnotation!

    
    //MARK:- Route variables
    var previousLocation: CLLocation!
    
    
    //MARK:- Search variable
    fileprivate var searchController: UISearchController!
    fileprivate var localSearchRequest: MKLocalSearchRequest!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var localSearchResponse: MKLocalSearchResponse!
    
    
    //MARK:- Overlay variables
    fileprivate var mapOverlay: MapOverlay!
    var selectedOptions : [MapOptionsType] = []
    var map = Map(filename: "MagicMountain")
    
    
    //MARK:- Activity Indication
    fileprivate var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK:- UIViewController's methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Load coordinates from CoreData
        mapOverlay = MapOverlay(map: map)
        
        /*
        let currentLocationButton = UIBarButtonItem(title: "Locate Me!!!", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapsViewController.currentLocationButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = currentLocationButton

        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(MapsViewController.searchButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = searchButton
*/
 
        //Config the mapview to show the user location
        mapView.delegate = self
        mapView.mapType = .hybrid
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        
        //Config the size/region of the mapview
        let latDelta = map.overlayTopLeftCoordinate.latitude - map.overlayBottomRightCoordinate.latitude
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        let region = MKCoordinateRegionMake(map.midCoordinate, span)
        mapView.region = region
        
        
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
    
    
    //MARK: Add the map overlay
    func addOverlay()
    {
        let overlay = MapOverlay(map: map)
        mapView.add(overlay)
    }
    
    //MARK:- Add Attraction Pins
    func addAttractionPins()
    {
        guard let attractions = Map.plist("MagicMountainAttractions") as? [[String : String]] else {return}
        
        for attraction in attractions
        {
            let coordinate = Map.parseCoord(dict: attraction, fieldName: "location")
            let title = attraction["name"] ?? ""
            let typeRawValue = Int(attraction["type"] ?? "0") ?? 0
            let type = AttractionType(rawValue: typeRawValue) ?? .misc
            let subtitle = attraction["subtitle"] ?? ""
            let annotation = AttractionAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
            mapView.addAnnotation(annotation)
        }
    }
    
    
    //MARK:- Add Route
    func addRoute()
    {
        guard let points = Map.plist("EntranceToGoliathRoute") as? [String] else { return }
        
        let cgPoints = points.map { CGPointFromString($0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
        
        mapView.add(myPolyline)
    }
    
    //MARK:- Add Boundary
    func addBoundary()
    {
        mapView.add(MKPolygon(coordinates: map.boundary, count: map.boundary.count))
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
                    self.addAttractionPins()
                case .mapRoute:
                    self.addRoute()
                case .mapBoundary:
                    self.addBoundary()
                case .mapCharacterLocation:
                    self.addCharacterLocation()
            }
        }
    }
    
    
    //MARK :- Locate me
  /*
    @objc func currentLocationButtonAction(_ sender: UIBarButtonItem)
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
            locationManager?.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            isCurrentLocation = true
        }
    }
    
    // MARK: - Search
    
    @objc func searchButtonAction(_ button: UIBarButtonItem)
    {
        if searchController == nil
        {
            searchController = UISearchController(searchResultsController: nil)
        }
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    */

    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        if self.mapView.annotations.count != 0
        {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { [weak self] (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil
            {
                let alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self!.mapView.centerCoordinate = pointAnnotation.coordinate
            self!.mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }

    //Add annotation to map view
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
        /*
        if (overlay is MKPolyline)
        {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.red
            pr.lineWidth = 5
            return pr
        }
 */
        
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
        let annotationView = AttractionAnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
        annotationView.canShowCallout = true
        return annotationView
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
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
       
        
        if self.mapView.annotations.count != 0
        {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
 
 /*
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location!.coordinate
        pointAnnotation.title = ""
        mapView.addAnnotation(pointAnnotation)
   */
    
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
