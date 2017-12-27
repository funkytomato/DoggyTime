//
//  MapsViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 27/12/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import MapKit


class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate
{
    
    //MARK:- Outlets
    
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func locateMeButton(_ sender: UIBarButtonItem)
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            if locationManager == nil
            {
                locationManager = CLLocationManager()
            }
            
            locationManager?.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
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

    
    //MARK:- Search variables
    
    fileprivate var searchController: UISearchController!
    fileprivate var localSearchRequest: MKLocalSearchRequest!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var localSearchResponse: MKLocalSearchResponse!
    
    
    //MARK:- Activity Indication
    
    fileprivate var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK:- UIViewController's methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let currentLocationButton = UIBarButtonItem(title: "Current Location", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapsViewController.currentLocationButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = currentLocationButton
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(MapsViewController.searchButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = searchButton
        
        mapView.delegate = self
        mapView.mapType = .hybrid
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        activityIndicator.center = self.view.center
    }
    
    
    //MARK :- Locate me
    
    @objc func currentLocationButtonAction(_ sender: UIBarButtonItem)
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            if locationManager == nil
            {
                locationManager = CLLocationManager()
            }
            
            locationManager?.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
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

    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
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
 
 
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location!.coordinate
        pointAnnotation.title = ""
        mapView.addAnnotation(pointAnnotation)
        
    }
}
