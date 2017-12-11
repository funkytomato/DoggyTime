//
//  ClientProfileViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 15/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit
import CoreData

 
class ClientProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    
    // MARK: - Properties
    var coreDataManager: CoreDataManager!
    var coreDataManagerDelegate: CoreDataManagerDelegate!
    var petDataSource: DogsDataSource?
    
    
    //Selected client's profile data
    var clientData: Client?
    var dogsOwned = [Dog]()

    
    //MARK:- IBOutlets
    @IBOutlet weak var ForenameField: UITextField!
    @IBOutlet weak var SurnameField: UITextField!
    
    @IBOutlet weak var StreetField: UITextField!
    @IBOutlet weak var TownField: UITextField!
    @IBOutlet weak var PostCodeField: UITextField!
    
    @IBOutlet weak var MobileField: UITextField!
    @IBOutlet weak var eMailField: UITextField!
    

    @IBOutlet weak var DogListView: UITableView!
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
        self.petDataSource = DogsDataSource(dogs: dogsOwned)
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
        
        //Populate the UI
        ForenameField.text = clientData?.foreName
        SurnameField.text = clientData?.surName
        StreetField.text = clientData?.street
        TownField.text = clientData?.town
        PostCodeField.text = clientData?.postCode
        MobileField.text = clientData?.mobile
        eMailField.text = clientData?.eMail
        
        updatePetView()
    }
    
    
    //Update the client's pet list
    private func updatePetView()
    {
        //Fetch the list of client dogs
        let dogsOwned = (clientData?.dogsOwned)!
        self.dogsOwned = Array(dogsOwned) as! [Dog]
        self.petDataSource = DogsDataSource(dogs: self.dogsOwned)
        
        DogListView.estimatedRowHeight = 40
        DogListView.rowHeight = UITableViewAutomaticDimension
        DogListView.dataSource = petDataSource
        DogListView.reloadData()
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("ClientsDetailViewController prepare segue")
        print("segue identifer \(String(describing: segue.identifier))")
        print("segue destination \(String(describing: segue.destination))")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //Prepare the Client's profile to be saved
        if segue.identifier == "SaveClientDetail"
        {
            guard let forename = ForenameField.text else {return}
            guard let surname = SurnameField.text else {return}
            guard let street = StreetField.text else {return}
            guard let town = TownField.text else {return}
            guard let postcode = PostCodeField.text else {return}
            guard let mobile = MobileField.text else {return}
            guard let email = eMailField.text else {return}
            
            
            // Update Client
            clientData?.foreName  = forename
            clientData?.surName = surname
            clientData?.street = street
            clientData?.town = town
            clientData?.postCode = postcode
            clientData?.mobile = mobile
            clientData?.eMail = email
        }
        
        
        //Prepare the dog entry controller to load an existing dog profile
        if segue.identifier == "ShowDogProfileSegue",
            let profileViewController = segue.destination as? ClientDogEntryViewController,
            let indexPath = self.DogListView.indexPathForSelectedRow
        {
            //Load an existing Dog profile
            
            // Fetch Dog
            let dog = self.dogsOwned[indexPath.item]
            
            //Configure View Controller
            profileViewController.setCoreDataManager(coreDataManager: coreDataManager)
            profileViewController.dogData = dog
        }

            
        //Prepare the dog entry controller to create a new dog profile
        else if segue.identifier == "AddDogSegue",
            let profileViewController = segue.destination as? ClientDogEntryViewController
        {
            
            //Create a new Dog profile
            let dog = Dog(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Dog
            dog.dogName = ""
            dog.breed = ""
            dog.gender = ""
            dog.size = ""
            dog.temperament = "Good"
            dog.profilePicture = nil
            dog.temperament = ""
            dog.createdAt = NSDate()
            dog.updatedAt = NSDate()
            //dog.uuid = ""
            dog.owner = clientData
           
         
            //Create relationship between client and dog
            clientData?.addToDogsOwned(dog)
        
            
            //Configure View Controller
            profileViewController.setCoreDataManager(coreDataManager: coreDataManager)
            profileViewController.dogData = dog
        }
    }
}


// MARK:- IBActions
extension ClientProfileViewController
{
    
    @IBAction func cancelToClientsDetailViewController(_ segue: UIStoryboardSegue)
    {
        print("Back in the ClientsDetailViewController")
    }
    

    //Save the dog profile from the Client Dog Entry window
    @IBAction func saveClientDogDetail(_ segue: UIStoryboardSegue)
    {
        print("ClientsDetailViewController saveClientDetail")
        print("Segue source\(segue.source)")
        guard let profileViewController = segue.source as? ClientDogEntryViewController,
            let dog = profileViewController.dogData else
        {
            return
        }
        
        //Store to CoreData
        do
        {
            try clientData?.managedObjectContext?.save()
            try dog.managedObjectContext?.save()
            print("ClientsDetailViewController saveClientDogDetail dog:\(dog)")
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Client Dog")
            print("\(saveError), \(saveError.localizedDescription)")
        }
        
        //Update the pet list
        updatePetView()
    }
}


//MARK:- Automatic tab to next field entry
extension ClientProfileViewController: UITextFieldDelegate
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
            eMailField.resignFirstResponder()
            
        default:
            eMailField.resignFirstResponder()
            
        }
        return true
    }
}


//MARK:- CoreDataManager Protocol
extension ClientProfileViewController: CoreDataManagerDelegate
{
    
    func setCoreDataManager(coreDataManager: CoreDataManager)
    {
        self.coreDataManager = coreDataManager
    }
}
