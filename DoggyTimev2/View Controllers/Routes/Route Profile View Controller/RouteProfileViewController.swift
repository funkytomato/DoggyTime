//
//  RouteProfileViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 29/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import CoreData

/*
protocol AddRouteViewControllerDelegate
{
    func controller(_ controller: RouteProfileViewController, didAddRoute name: String )
}
*/


class RouteProfileViewController: UITableViewController
{
    
    //MARK:- Properties
    //var delegate: AddRouteViewControllerDelegate?
    var routeData: Route?
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var TerrainField: UITextField!
    @IBOutlet weak var DistanceField: UITextField!
    @IBOutlet weak var DurationField: UITextField!
    
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
        
        //self.routeIdField.text = routeData?.routeId.description
        self.NameField.text = routeData?.name
        self.TerrainField.text = routeData?.terrain
        self.DistanceField.text = routeData?.distance.description
        self.DurationField.text = routeData?.duration.description
        
        //tableView.reloadData()
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
        //if let _ = segue.destination as? RoutesViewController,
        if segue.identifier == "SaveRouteDetail",
            //let routeid = routeIdField.text,
            let name = NameField.text,
            let terrain = TerrainField.text,
            let distance = DistanceField.text,
            let duration = DurationField.text
        {
            
            //Get the latest data and pass to destinationController to be saved
            //let route = Route(context: PersistentService.context)
            //route.routeid = Int16(routeid)!
            routeData?.name = name
            routeData?.terrain = terrain
            routeData?.distance = Float(distance)!
            routeData?.duration = Float(duration)!
        }
    }
}

/*
//MARK:- IBActions
extension RouteProfileViewController
{
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any)
    {
        guard let name = NameField.text else { return }
        guard let terrain = TerrainField.text else {return}
        guard let distance = DistanceField.text else {return}
        guard let duartion = DurationField.text else {return }
        guard let delegate = delegate else { return }
        
        // Notify Delegate
        delegate.controller(self, didAddRoute: name)
        
        // Dismiss View Controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
}
 */
