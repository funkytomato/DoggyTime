//
//  RouteProfileViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 29/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit

class RouteProfileViewController: UITableViewController
{
    //MARK:- IBOutlets
    @IBOutlet weak var routeIdField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var terrainField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    
    @IBAction func startBtn(_ sender: Any) {
    }
    @IBAction func finishBtn(_ sender: Any) {
    }
    
    
    //MARK:- Properties
    
    //Data to receive from RouteViewController
   weak var routeData: Route?
    
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
        
        //self.routeIdField.text = routeData?.routeId.description
        self.nameField.text = routeData?.name
        self.terrainField.text = routeData?.terrain
        self.distanceField.text = routeData?.distance.description
        self.durationField.text = routeData?.duration.description
        
        tableView.reloadData()
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
        //if segue.identifier == "SaveRouteDetail",
        if let _ = segue.destination as? RoutesViewController,
            //let routeId = routeData?.routeId,
            let name = nameField.text,
            let terrain = terrainField.text,
            let distance = distanceField.text,
            let duration = durationField.text
        {
            
            
            let route = Route(context: PersistentService.context)
            route.name = name
            route.terrain = terrain
            //route.distance = Float(distance)!
            //route.duration = Float(duration)!
            
            self.routeData = route
            
        }
    }
}

extension String
{
    func toDouble()->Double?
    {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toFloat()->Float?
    {
        return NumberFormatter().number(from: self)?.floatValue
    }
}
