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
    var coreDataManager: CoreDataManager!
    var coreDataManagerDelegate: CoreDataManagerDelegate!
    var clientData: Client?
    var dogData: Dog?
    
    var dogsOwned = [Dog]()
    var dataSource: DogsDataSource?
    
    
    
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
        print("init ClientDetailsViewController")
        
        self.dataSource = DogsDataSource(dogs: dogsOwned)

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
        
        //Fetch the list of client dogs
        let dogsOwned = (clientData?.dogsOwned)!
        let pets = Array(dogsOwned) as! [Dog]
        self.dataSource = DogsDataSource(dogs: pets)
        
        DogListView.estimatedRowHeight = 40
        DogListView.rowHeight = UITableViewAutomaticDimension
        DogListView.dataSource = dataSource
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
        
        
        //Prepare the embedded table view to display the client's pet dogs
        if (segue.identifier == "PetList"),
            let childViewController = segue.destination as? DogsEmbeddedTableViewConroller
        {
            print("ClientsDetailViewController prepare got DogsEmbeddedTableViewController")
            
            //Configure View Controller
            childViewController.setCoreDataManager(coreDataManager: coreDataManager)
            
            /*
            //Fetch the list of client dogs
            let dogsOwned = clientData?.dogsOwned
            let pets = Array(dogsOwned!) as! [Dog]
            
            print("embeddedDogsTableViewController dogsOwned \(dogsOwned!)")
            print("embeddedDogsTableViewController pets: \(pets)")
            
            //Configure the controller
            childViewController.dogs = pets
            */
        }
        
        
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
        if segue.identifier == "AddDogSegue",
            let profileViewController = segue.destination as? ClientDogEntryViewController,
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            //Load an existing Dog profile
            
            // Fetch Dog
            //let dog = fetchedResultsController.object(at: indexPath)
            
            //Configure View Controller
            profileViewController.setCoreDataManager(coreDataManager: coreDataManager)
            //profileViewController.dogData = dog
        }

            
        //Prepare the dog entry controller to create a new dog profile
        else if segue.identifier == "AddDogSegue",
            let profileViewController = segue.destination as? ClientDogEntryViewController
        {
            
            //Create a new Dog profile
            let dog = Dog(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Dog
            dog.dogName = "Bruno Marley"
            dog.breed = ""
            dog.gender = "Male"
            dog.size = "Medium"
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
extension ClientsDetailViewController
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
        //Fetch the list of client dogs
        let dogsOwned = (clientData?.dogsOwned)!
        let pets = Array(dogsOwned) as! [Dog]
        self.dataSource = DogsDataSource(dogs: pets)
        DogListView.dataSource = dataSource
        DogListView.reloadData()
    }
}


//MARK:- Automatic tab to next field entry
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
            eMailField.resignFirstResponder()
            
        default:
            eMailField.resignFirstResponder()
            
        }
        return true
    }
}



//MARK:- CoreDataManager Protocol
extension ClientsDetailViewController: CoreDataManagerDelegate
{
    
    func setCoreDataManager(coreDataManager: CoreDataManager)
    {
        print("ClientsDetailViewController setCoreDataManager")
        self.coreDataManager = coreDataManager
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
