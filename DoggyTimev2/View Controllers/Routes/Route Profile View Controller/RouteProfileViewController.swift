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
    @IBOutlet weak var routeId: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var terrain: UITextField!
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var duration: UITextField!
    
    @IBAction func startBtn(_ sender: Any) {
    }
    @IBAction func finishBtn(_ sender: Any) {
    }
    
    
    //MARK:- Properties
    let dataSource: RoutesDataSource
    
    //Data to receive from RouteViewController
    var routeData: Route?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.dataSource = RoutesDataSource(routes: SampleData.generateRoutesData())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.routeId.text = routeData?.routeId.description
        self.name.text = routeData?.name
        self.terrain.text = routeData?.terrain
        self.distance.text = routeData?.distance.description
        self.duration.text = routeData?.duration.description
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
}
