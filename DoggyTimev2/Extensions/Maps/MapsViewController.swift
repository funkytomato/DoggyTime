//
//  MapsViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 27/12/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import MapKit


class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    
    //MARK:- Outlets
    
    @IBOutlet weak var mapView: MKMapView!

    
    //MARK:- Map variables
    
    fileprivate var locationManager: CLLocationManager!
    fileprivate var isCurrentLocation: Bool = false
    
    
    //MARK:- Activity Indication
    
    fileprivate var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK:- UIViewController's methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let currentLocationButton = UIBarButtonItem(title: "Current Location", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapsViewController.currentLocationButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = currentLocationButton
        
        
        
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
    
    
    // MARK: - Actions
    
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
       
        /*
        if self.mapView.annotations.count != 0
        {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
 
 
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location!.coordinate
        pointAnnotation.title = ""
        mapView.addAnnotation(pointAnnotation)
        */
    }
}
