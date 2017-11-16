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
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Dog> =
    {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Dog> = Dog.fetchRequest()
        print("fetchRequest:\(fetchRequest.description)")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        print("fetchedResultsCOntroller\(fetchedResultsController.description)")
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
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
        
        //Fetch dogs from CoreData
        do
        {
            try fetchedResultsController.performFetch()
        }
        catch
        {
            let fetchError = error as NSError
            print("Unable to Save Dog")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        
        ForenameField.text = clientData?.foreName
        SurnameField.text = clientData?.surName
        StreetField.text = clientData?.street
        TownField.text = clientData?.town
        PostCodeField.text = clientData?.postCode
        MobileField.text = clientData?.mobile
        eMailField.text = clientData?.eMail
        
        
        //  DO I SET THE DOG ID HERE TOO?
        
        
        //DognameField.text = clientData?.dogName
        //DogPicture?.image = (clientData.dogpicture)!
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
        if segue.identifier == "SaveClientDetail"
        {
            guard let forename = ForenameField.text else {return}
            guard let surname = SurnameField.text else {return}
            guard let street = StreetField.text else {return}
            guard let town = TownField.text else {return}
            guard let postcode = PostCodeField.text else {return}
            guard let mobile = MobileField.text else {return}
            guard let email = eMailField.text else {return}
            //guard let dogname = DognameField.text else {return}
            
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
        
        if let profileViewController = segue.destination as? ClientDogEntryViewController,
 //       if segue.identifier == "AddDogSegue",
            let indexPath = self.tableView.indexPathForSelectedRow
        {
            //Load an existing Dog profile
            
            // Fetch Dog
            let dog = fetchedResultsController.object(at: indexPath)
            
            //Configure View Controller
            profileViewController.setCoreDataManager(coreDataManager: coreDataManager)
            profileViewController.dogData = dog
            
        }
        else if let profileViewController = segue.destination as? ClientDogEntryViewController
       // else if segue.identifier == "AddDogSegue"
        {
            //Create a new Dog profile
            let dog = Dog(context: coreDataManager.mainManagedObjectContext)
            
            //Populate Dog
            dog.dogName = ""
            dog.gender = ""
            dog.breed = ""
            dog.size = ""
            dog.profilePicture = nil
            dog.temperament = ""
            dog.owner = clientData
            
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
            try dog.managedObjectContext?.save()
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Dog")
            print("\(saveError), \(saveError.localizedDescription)")
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

extension ClientsDetailViewController: NSFetchedResultsControllerDelegate
{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type)
        {
        case .insert:
            if let indexPath = newIndexPath
            {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            /*
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? ClientCell
            {
                configureCell(cell, at: indexPath)
            }
 */
            break;
        case .move:
            if let indexPath = indexPath
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath
            {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
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
