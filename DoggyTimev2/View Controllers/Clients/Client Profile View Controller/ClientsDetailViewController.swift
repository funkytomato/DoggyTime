//
//  ClientsDetailViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 15/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit

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
    var clientData: Client?
    
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
        super.viewDidLoad()

        ForenameField.text = clientData?.forename
        SurnameField.text = clientData?.surname
        StreetField.text = clientData?.street
        TownField.text = clientData?.town
        PostCodeField.text = clientData?.postcode
        MobileField.text = clientData?.mobile
        eMailField.text = clientData?.eMail
        DognameField.text = clientData?.dogname
        DogPicture?.image = (clientData?.dogpicture)!
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveClientDetail",
            let clientForeName = ForenameField.text,
            let clientSurName = SurnameField.text,
            let clientAddress = StreetField.text,
            let clientTown = TownField.text,
            let clientPostCode = PostCodeField.text,
            let clientMobile = MobileField.text,
            let clienteMail = eMailField.text,
            let clientDogName = DognameField.text,
            let clientDogPicture = DogPicture
        {

            clientData = Client(forename: clientForeName,
                            surname: clientSurName,
                            street: clientAddress,
                            town: clientTown,
                            postcode: clientPostCode,
                            mobile: clientMobile,
                            eMail: clienteMail,
                            dogname: clientDogName,
                            dogpicture: clientDogPicture.image)
 
            
        }
    }
}
