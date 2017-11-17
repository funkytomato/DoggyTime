//
//  ClientDogEntryViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 08/11/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

//
//  DogProfileViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 23/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit
import CoreData

/*
protocol AddClientDogEntryViewControllerDelegate
{
    func controller(_ controller: ClientDogEntryViewController, didAddClientDog dogname: String)
}
*/

class ClientDogEntryViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    //var delegate: AddClientDogEntryViewControllerDelegate?
    
    //MARK:- Properties
    var coreDataManager: CoreDataManager!
    var coreDataManagerDelegate: CoreDataManagerDelegate!
     weak var dogData : Dog?
    
    //MARK:- IBOutlets
    @IBOutlet weak var DogNameField: UITextField!
    @IBOutlet weak var GenderPicker: UIPickerView!
    
    @IBOutlet weak var BreedPicker: UIPickerView!
    @IBOutlet weak var BreedPictureView: UIImageView!
    @IBOutlet weak var BreedInfoTextView: UITextView!
    
    @IBOutlet weak var SizePicker: UIPickerView!
    @IBOutlet weak var ProfilePictureView: UIImageView!
    
    
    //MARK:- PickerView DataSources
    var breedDataSource = ["Unknown","German Shephard", "Rottweiler", "Beagle", "Bulldog", "Great Dane", "Poodle", "Doberman Pinscher", "Dachshund", "Siberian Huskey", "English Mastiff", "Pit Bull", "Boxer", "Chihuahua",   "Border Collie", "Pug", "Golden Retriever", "Labrador Retriever", "Pointer", "Terrier", "Chow Chow", "Yorkshire Terrier", "Vizsla", "Australian Sheperd", "Maltese Dog", "Greyhound", "Cavalier King Charles Spaniel", "Malinois", "Akita", "Affenpinscher", "Old English Sheepdog", "St. Bernard", "Pomeranian", "Saluki", "Lhasa Apso", "Australian Cattle Dog", "Pekingese", "Alaskan Malamute", "Cardigan Welsh Corgi", "Staffordshire Bull Terrier", "Basset Hound", "Newfoundland", "Great Pyrenees", "Bernese Mountain Dog", "Bull Terrier", "Bullmastiff", "Bernese Mountain Dog", "Bull Terrier", "Bullmastiff", "French Bulldog", "Norwich Terrier", "Bichon Frise", "Shetland Sheepdog", "Airedale Terrier", "Boston Terrier"]
    
    var genderDataSource = ["Male", "Female"]
    
    var sizeDataSource = ["Tiny", "Small", "Medium", "LARGE"]
    
   /*
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
    */
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        print("ClientDogEntryViewController deinit")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*
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
        */
        
        BreedPicker.delegate = self
        BreedPicker.dataSource = self
        
        GenderPicker.delegate = self
        GenderPicker.dataSource = self
        
        SizePicker.delegate = self
        SizePicker.dataSource = self
        
        if dogData != nil
        {
            self.DogNameField.text = dogData?.dogName
            
            //self.sexFd.text = dogData?.sex
            if let row = genderDataSource.index(of: (dogData?.gender)!)
            {
                GenderPicker.selectRow(row, inComponent: 0, animated: false)
            }
            
            
            //self.breedFd.text = dogData?.breed
            if let row = breedDataSource.index(of: (dogData?.breed?.description)!)
            {
                BreedPicker.selectRow(row, inComponent: 0, animated: false)
                BreedPictureView.image = UIImage(named: breedDataSource[row])
            }
            
            //self.sizeFd.text = dogData?.size
            //self.pictureView.image = dogData?.picture
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("ClientDogEntryViewController prepare segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveClientDogDetail",
            //let dogid = dog
            let dogname = DogNameField.text,
            let gender = dogData?.gender,
            let breed = dogData?.breed,
            let size = dogData?.size,
            let temperament = dogData?.temperament,
            let picture = ProfilePictureView.image
        {
            
            // Update Client
            dogData?.dogName = dogname
            dogData?.gender = gender
            dogData?.breed = breed
            dogData?.size = size
            dogData?.temperament = temperament
            //dogData?.profilePicture = picture
            
        }
        
        if let profileViewController = segue.destination as? CameraViewController2
        {
            /*
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
 */
        }
    }
}

//MARK:- PickerView
extension ClientDogEntryViewController
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        print("ClientDogEntryViewController numberOfComponents PickerView :\(pickerView.description)")
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        print("ClientDogEntryViewController numberOfRowsInComponent PickerView : \(pickerView.description)")
        if pickerView == GenderPicker
        {
            return genderDataSource.count
        }
        else if pickerView == BreedPicker
        {
            return breedDataSource.count
        }
        else if pickerView == SizePicker
        {
            return sizeDataSource.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        print("ClientDogEntryViewController titleForRow PickerView : \(pickerView.description)")
        if pickerView == GenderPicker
        {
            return genderDataSource[row] as String
        }
        else if pickerView == BreedPicker
        {
            return breedDataSource[row] as String
        }
        else if pickerView == SizePicker
        {
            return sizeDataSource[row] as String
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print("ClientDogEntryViewController didSelectRow PickerView : \(pickerView.description)")

        
        if pickerView == BreedPicker
        {
            print(breedDataSource[row])
            
            BreedPictureView.image = UIImage(named: breedDataSource[row])
            dogData?.breed = breedDataSource[row]
        }
        else if pickerView == GenderPicker
        {
            print(genderDataSource[row])
            
            dogData?.gender = genderDataSource[row]
        }
        else if pickerView == SizePicker
        {
            print(sizeDataSource[row])
            
            dogData?.size = sizeDataSource[row]
        }
    }
    
    func pickerShouldReturn(_ pickerView: UIPickerView) -> Bool
    {
        switch pickerView
        {
        case GenderPicker:
            BreedPicker.becomeFirstResponder()
        case BreedPicker:
            SizePicker.becomeFirstResponder()
        case SizePicker:
            SizePicker.resignFirstResponder()
        default:
            SizePicker.resignFirstResponder()
        }
        
        return true
    }
}

extension ClientDogEntryViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) ->Bool
    {
        switch textField
        {
        case DogNameField:
            GenderPicker.becomeFirstResponder()
            //        case genderPicker:
            //            breedPicker.becomeFirstResponder()
            //        case breedPicker:
            //            sizePicker.becomeFirstResponder()
            //        case sizePicker:
            //            sizePicker.resignFirstResponder()
            
        default:
            SizePicker.resignFirstResponder()
            
        }
        return true
    }
}

/*
extension ClientDogEntryViewController: NSFetchedResultsControllerDelegate
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
*/
 
/*
 extension ClientDogEntryViewController: UIPickerViewDelegate
 {
 func pickerShouldReturn(_ pickerView: UIPickerView) -> Bool
 {
 switch pickerView
 {
 case genderPicker:
 breedPicker.becomeFirstResponder()
 case breedPicker:
 sizePicker.becomeFirstResponder()
 case sizePicker:
 sizePicker.resignFirstResponder()
 default:
 sizePicker.resignFirstResponder()
 }
 
 return true
 }
 }
 */

/*

//MARK:- IBActions
extension ClientDogEntryViewController
{
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        guard let dogname = DogNameField.text else { return }
        //guard let gender = GenderPicker.text else {return}
        //guard let breed = BreedPicker.text else {return}
        //guard let size = SizePicker.text else { return }
        //guard let temperament =
        guard let delegate = delegate else { return }
        
        // Notify Delegate
        delegate.controller(self, didAddClientDog: dogname)
        
        // Dismiss View Controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
*/

// MARK:- IBActions
extension ClientDogEntryViewController //: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    /*
    @IBAction func CameraAction(_ sender: Any?)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        ProfilePictureView.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
    }
    
    */
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
            print("Unable to Save Client Dog")
            print("\(saveError), \(saveError.localizedDescription)")
        }
 
    }
}


//MARK:- CoreDataManager Protocol
extension ClientDogEntryViewController: CoreDataManagerDelegate
{
    
    func setCoreDataManager(coreDataManager: CoreDataManager)
    {
        self.coreDataManager = coreDataManager
        coreDataManagerDelegate = self
    }
}
