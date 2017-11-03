//
//  ClientsDetailViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 15/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit
import CoreData

class ClientsDetailViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    //MARK:- IBOutlets
    @IBOutlet weak var ForenameField: UITextField!
    @IBOutlet weak var SurnameField: UITextField!
    
    @IBOutlet weak var StreetField: UITextField!
    @IBOutlet weak var TownField: UITextField!
    @IBOutlet weak var PostCodeField: UITextField!
    
    @IBOutlet weak var MobileField: UITextField!
    @IBOutlet weak var eMailField: UITextField!
    
    @IBOutlet weak var DognameField: UITextField!
    @IBAction func photoLibraryBtn(_ sender: Any)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var DogPicture: UIImageView!
    
    
    // MARK: - Properties
    weak var clientData: Client?
    
    
    // MARK:- Initializers
    required init?(coder aDecoder: NSCoder)
    {
        print("init ClientDetailsViewController")
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        print("deinit ClientDetailsViewController")
    }
 
    
    override func viewDidLoad()
    {
        print("ClientDetailsViewController viewDidLoad")
        super.viewDidLoad()

        ForenameField.text = clientData?.forename
        SurnameField.text = clientData?.surname
        StreetField.text = clientData?.street
        TownField.text = clientData?.town
        PostCodeField.text = clientData?.postcode
        MobileField.text = clientData?.mobile
        eMailField.text = clientData?.email
        DognameField.text = clientData?.dogname
        //DogPicture?.image = (clientData.dogpicture)!
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("ClientsDetailViewController prepare segue")
        print("segue identifer \(segue.identifier)")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination as? ClientsViewController,
            let forename = ForenameField.text,
            let surname = SurnameField.text,
            let street = StreetField.text,
            let town = TownField.text,
            let postcode = PostCodeField.text,
            let mobile = MobileField.text,
            let email = eMailField.text,
            let dogname = DognameField.text
        {

            
            let client = Client(context: PersistentService.context)
            client.forename  = forename
            client.surname = surname
            client.street = street
            client.town = town
            client.postcode = postcode
            client.mobile = mobile
            client.email = email
            client.dogname = dogname
            
            self.clientData = client
        }
    }
}
