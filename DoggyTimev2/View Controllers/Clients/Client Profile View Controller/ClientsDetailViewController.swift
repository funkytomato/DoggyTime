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

    
    // MARK: - Properties
    //var delegate: AddClientViewControllerDelegate?
    var clientData: Client?
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var ForenameField: UITextField!
    @IBOutlet weak var SurnameField: UITextField!
    
    @IBOutlet weak var StreetField: UITextField!
    @IBOutlet weak var TownField: UITextField!
    @IBOutlet weak var PostCodeField: UITextField!
    
    @IBOutlet weak var MobileField: UITextField!
    @IBOutlet weak var eMailField: UITextField!
    
    @IBOutlet weak var DognameField: UITextField!
    @IBOutlet weak var DogTinyPicture: UIImageView!
    @IBOutlet weak var DogPicture: UIImageView!

    
    @IBAction func photoLibraryBtn(_ sender: Any)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    
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
        
        
        ForenameField.text = clientData?.foreName
        SurnameField.text = clientData?.surName
        StreetField.text = clientData?.street
        TownField.text = clientData?.town
        PostCodeField.text = clientData?.postCode
        MobileField.text = clientData?.mobile
        eMailField.text = clientData?.eMail
        //DognameField.text = clientData?.dogName
        //DogPicture?.image = (clientData.dogpicture)!
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("ClientsDetailViewController prepare segue")
        print("segue identifer \(String(describing: segue.identifier))")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveClientDetail"
        {
            guard let forename = ForenameField.text else {return}
            guard let surname = SurnameField.text else {return}
            guard let street = StreetField.text else {return}
            guard let town = TownField.text else {return}
            guard let postcode = PostCodeField.text else {return}
            guard let mobile = MobileField.text else {return}
            guard let email = eMailField.text else {return}
            guard let dogname = DognameField.text else {return}
            
            // Update Client
            clientData?.foreName  = forename
            clientData?.surName = surname
            clientData?.street = street
            clientData?.town = town
            clientData?.postCode = postcode
            clientData?.mobile = mobile
            clientData?.eMail = email
            //clientData?.dogName = dogname
        }
    }
}


extension ClientsDetailViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) ->Bool
    {
        switch textField
        {
        case ForenameField:
            SurnameField.becomeFirstResponder()
        case SurnameField:
            StreetField.becomeFirstResponder()
        case StreetField:
            TownField.becomeFirstResponder()
        case TownField:
            PostCodeField.becomeFirstResponder()
        case PostCodeField:
            MobileField.becomeFirstResponder()
        case MobileField:
            eMailField.becomeFirstResponder()
        case eMailField:
            DognameField.becomeFirstResponder()
        case DognameField:
            DognameField.resignFirstResponder()
            
        default:
            DognameField.resignFirstResponder()
            
        }
        return true
    }
}

/*
//MARK:- IBActions
extension ClientsDetailViewController
{
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        guard let forename = ForenameField.text else { return }
        guard let surname = SurnameField.text else {return}
        guard let street = StreetField.text else {return}
        guard let delegate = delegate else { return }
        
        // Notify Delegate
        delegate.controller(self, didAddClient: forename, surname: surname)
        
        // Dismiss View Controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
 */
