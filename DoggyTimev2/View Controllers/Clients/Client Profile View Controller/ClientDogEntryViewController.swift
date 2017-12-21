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


class ClientDogEntryViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate
{
    
    //MARK:- Properties
    var coreDataManager: CoreDataManager!
    var coreDataManagerDelegate: CoreDataManagerDelegate!
    var dogData : Dog?
    
    
    //Collasible Sections
    let kHeaderSectionTag: Int = 6900;
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
    
    
    //Another collasible offering
    struct Section
    {
        var name: String!
        var items: [String]!
        var collapsed: Bool!
        
        init(name: String, items: [String], collapsed: Bool = false)
        {
            self.name = name
            self.items = items
            self.collapsed = false
        }
    }
    
    /*
    var sections = [Section]()
   // sections = [Section([name: "Details", items: ["Owner Details","Walk Details"]])]
    
    sections = [
    Section(name: "Mac", items: ["MacBook", "MacBook Air", "MacBook Pro", "iMac", "Mac Pro", "Mac mini", "Accessories", "OS X El Capitan"]),
    Section(name: "iPad", items: ["iPad Pro", "iPad Air 2", "iPad mini 4", "Accessories"]),
    Section(name: "iPhone", items: ["iPhone 6s", "iPhone 6", "iPhone SE", "Accessories"])
    ]
    */
    
    //Show/Hide PickerViews
    
    let genderPicker = UIPickerView()
    let sizePicker = UIPickerView()
    let breedPicker = UIPickerView()
    let temperamentPicker = UIPickerView()
    
    //MARK:- IBOutlets
    @IBOutlet weak var OwnerNameLabel: UILabel!
    @IBOutlet weak var WalkCountLabel: UILabel!
    @IBOutlet weak var NextWalkDateLabel: UILabel!
    @IBOutlet weak var NextWalkLocationLabel: UILabel!
    @IBOutlet weak var UpdatedDateLabel: UILabel!
    
    @IBOutlet weak var DogNameField: UITextField!
    @IBOutlet weak var GenderField: UITextField!
    //@IBOutlet weak var GenderPicker: UIPickerView!
    @IBOutlet weak var SizeField: UITextField!
    @IBOutlet weak var BreedField: UITextField!
    @IBOutlet weak var TemperamentField: UITextField!
    //@IBOutlet weak var SizePicker: UIPickerView!
    //@IBOutlet weak var TemperamentPicker: UIPickerView!
    
    //@IBOutlet weak var BreedPicker: UIPickerView!
    @IBOutlet weak var BreedPictureView: UIImageView!
    @IBOutlet weak var BreedInfoTextView: UITextView!
    
    @IBOutlet weak var ProfilePictureView: UIImageView!
    
    
    
    
    
    //MARK:- PickerView DataSources
    var breedDataSource = ["Unknown","German Shephard", "Rottweiler", "Beagle", "Bulldog", "Great Dane", "Poodle", "Doberman Pinscher", "Dachshund", "Siberian Huskey", "English Mastiff", "Pit Bull", "Boxer", "Chihuahua",   "Border Collie", "Pug", "Golden Retriever", "Labrador Retriever", "Pointer", "Terrier", "Chow Chow", "Yorkshire Terrier", "Vizsla", "Australian Sheperd", "Maltese Dog", "Greyhound", "Cavalier King Charles Spaniel", "Malinois", "Akita", "Affenpinscher", "Old English Sheepdog", "St. Bernard", "Pomeranian", "Saluki", "Lhasa Apso", "Australian Cattle Dog", "Pekingese", "Alaskan Malamute", "Cardigan Welsh Corgi", "Staffordshire Bull Terrier", "Basset Hound", "Newfoundland", "Great Pyrenees", "Bernese Mountain Dog", "Bull Terrier", "Bullmastiff", "Bernese Mountain Dog", "Bull Terrier", "Bullmastiff", "French Bulldog", "Norwich Terrier", "Bichon Frise", "Shetland Sheepdog", "Airedale Terrier", "Boston Terrier"]
    
    var genderDataSource = ["Male", "Female"]
    
    var sizeDataSource = ["Tiny", "Small", "Medium", "LARGE"]
    
    var temperamentDataSource = ["Green", "Yellow", "Red", "Black"]
    
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
        
        sectionNames = ["Details","Dog Name","Gender","Size","Temperament","Breed","Picture"]
        sectionItems = [["Owner Details","Walk Details"],
                        ["Dog Name"],
                        ["Gender"],
                        ["Size"],
                        ["Temperament"],
                        ["Breed","Breed Picture","Breed Info"],
                        ["Profile Picture"]]
        
        self.tableView!.tableFooterView = UIView()

        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        sizePicker.delegate = self
        sizePicker.dataSource = self
        
        temperamentPicker.delegate = self
        temperamentPicker.dataSource = self
        
        breedPicker.delegate = self
        breedPicker.dataSource = self
        
        if dogData != nil
        {

            guard let owner = dogData?.owner?.foreName else { return }
            self.OwnerNameLabel.text = owner
            
            guard let walkcount = dogData?.walkcount.description else { return }
            self.WalkCountLabel.text = walkcount
            
            
            //self.NextWalkDateLabel.text = dogData?.walking.time
            
            guard let updatedAt = dogData?.updatedAt?.description else { return }
            self.UpdatedDateLabel.text = updatedAt
            
            
            self.DogNameField.text = dogData?.dogName

            self.GenderField.text = dogData?.gender
            GenderField.inputView = genderPicker
        
            self.SizeField.text = dogData?.size
            SizeField.inputView = sizePicker
            
            self.TemperamentField.text = dogData?.temperament
            TemperamentField.inputView = temperamentPicker
            
            self.BreedField.text = dogData?.breed
            BreedField.inputView = breedPicker
            
            if let row = breedDataSource.index(of: (dogData?.breed?.description)!)
            {
                BreedPictureView.image = UIImage(named: breedDataSource[row])
            }
            
            guard let profilePicture = dogData?.profilePicture else { return }
            self.ProfilePictureView.image = UIImage(data: profilePicture)
            
            /*
            if let row = genderDataSource.index(of: (dogData?.gender)!)
            {
                genderPicker.selectRow(row, inComponent: 0, animated: false)
            }
       
            if let row = sizeDataSource.index(of: (dogData?.size?.description)!)
            {
                SizePicker.selectRow(row, inComponent: 0, animated: false)
            }
            
            if let row = temperamentDataSource.index(of: (dogData?.temperament?.description)!)
            {
                TemperamentPicker.selectRow(row, inComponent: 0, animated: false)
            }
 
            if let row = breedDataSource.index(of: (dogData?.breed?.description)!)
            {
                BreedPicker.selectRow(row, inComponent: 0, animated: false)
                BreedPictureView.image = UIImage(named: breedDataSource[row])
            }
 
            guard let profilePicture = dogData?.profilePicture else { return }
            self.ProfilePictureView.image = UIImage(data: profilePicture)
 */
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
        print("segue identifier:\(segue.identifier)")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveClientDogDetail",
            let dogname = DogNameField.text,
            let gender = dogData?.gender,
            let breed = dogData?.breed,
            let size = dogData?.size,
            let temperament = dogData?.temperament,
            let picture = ProfilePictureView.image
        {
            //Create a new Dog profile
            let dog = Dog(context: coreDataManager.mainManagedObjectContext)
            
            
            // Update Client
            dogData?.dogName = dogname
            dogData?.gender = gender
            dogData?.breed = breed
            dogData?.size = size
            dogData?.temperament = temperament
            dogData?.updatedAt = NSDate()
            dogData?.profilePicture = picture as? Data
        }
        
        if let profileViewController = segue.destination as? CameraViewController
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
        
        if segue.identifier == "saveProfilePicture"
        {
            print("save profile picture")
            
            //Updata the dog's profile picture
            //dogData?.profilePicture =
        }
        
        if segue.identifier == "cancelProfilePicture"
        {
            print("cancel profile picture")
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
        if pickerView == genderPicker
        {
            return genderDataSource.count
        }
        else if pickerView == breedPicker
        {
            return breedDataSource.count
        }
        else if pickerView == sizePicker
        {
            return sizeDataSource.count
        }
        else if pickerView == temperamentPicker
        {
            return temperamentDataSource.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        print("ClientDogEntryViewController titleForRow PickerView : \(pickerView.description)")
        if pickerView == genderPicker
        {
            return genderDataSource[row] as String
        }
        else if pickerView == breedPicker
        {
            return breedDataSource[row] as String
        }
        else if pickerView == sizePicker
        {
            return sizeDataSource[row] as String
        }
        else if pickerView == temperamentPicker
        {
            return temperamentDataSource[row] as String
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        print("ClientDogEntryViewController didSelectRow PickerView : \(pickerView.description)")

        
        if pickerView == breedPicker
        {
            print(breedDataSource[row])
            
            BreedPictureView.image = UIImage(named: breedDataSource[row])
            dogData?.breed = breedDataSource[row]
            BreedField.text = breedDataSource[row]
        }
        else if pickerView == genderPicker
        {
            print(genderDataSource[row])
            
            dogData?.gender = genderDataSource[row]
            GenderField.text = genderDataSource[row]
        }
        else if pickerView == sizePicker
        {
            print(sizeDataSource[row])
            
            dogData?.size = sizeDataSource[row]
            SizeField.text = sizeDataSource[row]
        }
        else if pickerView == temperamentPicker
        {
            dogData?.temperament = temperamentDataSource[row]
            TemperamentField.text = temperamentDataSource[row]
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    func pickerShouldReturn(_ pickerView: UIPickerView) -> Bool
    {
        switch pickerView
        {
        case genderPicker:
            breedPicker.becomeFirstResponder()
        case breedPicker:
            sizePicker.becomeFirstResponder()
        case sizePicker:
            temperamentPicker.becomeFirstResponder()
        case temperamentPicker:
            temperamentPicker.resignFirstResponder()
        default:
            temperamentPicker.resignFirstResponder()
        }
        
        return true
    }
}


//MARK:- TableView Methods
extension ClientDogEntryViewController
{

    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 7
        /*
        if sectionNames.count > 0
        {
            tableView.backgroundView = nil
            return sectionNames.count
        }
        else
        {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }
        return 0
        */
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
/*
        if section == 0
        {
            return 1
        }
        
        
        var count = sections.count
        */
        
        if (self.expandedSectionHeaderNumber == section)
        {
            let arrayOfItems = self.sectionItems[section] as! NSArray
            return arrayOfItems.count;
        }
        else
        {
            return 0;
        }
 
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        /*
        switch section
        {
            case 0: return "Details"
            case 1: return "Dog Name"
            case 2: return "Gender"
            case 3: return "Size"
            case 4: return "Temperament"
            case 5: return "Breed"
            case 6: return "Picture"
            default: return ""
        }
        */
        
        if (self.sectionNames.count != 0)
        {
            return self.sectionNames[section] as? String
        }
 
        return ""
 
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44.0;
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0;
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.colorWithHexString(hexStr: "#408000")
        header.textLabel?.textColor = UIColor.white
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section)
        {
            viewWithTag.removeFromSuperview()
        }
        
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "Chevron-Dn-Wht")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ClientDogEntryViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell
        let section = self.sectionItems[indexPath.section] as! NSArray
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = section[indexPath.row] as? String
        
        return cell
    }
    */
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer)
    {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1)
        {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        }
        else
        {
            if (self.expandedSectionHeaderNumber == section)
            {
                tableViewCollapeSection(section, imageView: eImageView!)
            }
            else
            {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView)
    {
        let sectionData = self.sectionItems[section] as! NSArray
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0)
        {
            return;
        }
        else
        {
            UIView.animate(withDuration: 0.4, animations:
                {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count
            {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView)
    {
        let sectionData = self.sectionItems[section] as! NSArray
        
        if (sectionData.count == 0)
        {
            self.expandedSectionHeaderNumber = -1;
            return;
        }
        else
        {
            UIView.animate(withDuration: 0.4, animations:
                {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count
            {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
}

extension ClientDogEntryViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) ->Bool
    {
        switch textField
        {
        case DogNameField:
            GenderField.becomeFirstResponder()
        case GenderField:
            SizeField.becomeFirstResponder()
        case SizeField:
            BreedField.becomeFirstResponder()
        case BreedField:
            TemperamentField.becomeFirstResponder()
        case TemperamentField:
            TemperamentField.resignFirstResponder()
            
        default:
            DogNameField.resignFirstResponder()
            
        }
        return true
    }
}


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
    @IBAction func cancelProfielPicture(_ segue: UIStoryboardSegue)
    {
        print("cancelProfilePicture")
    }

    @IBAction func saveProfilePicture(_ segue: UIStoryboardSegue)
    {
        print("saveProfilePicture")
        guard let profileViewController = segue.source as? AVCameraViewController,
            let image = profileViewController.profileImage else
        {
            return
        }
        
        dogData?.profilePicture = image
        
        //Store to CoreData
        do
        {
            try dogData?.managedObjectContext?.save()
            print("ClientDogEntryViewController saveClientDogDetail dog:\(dogData)")
        }
        catch
        {
            let saveError = error as NSError
            print("Unable to Save Client Dog")
            print("\(saveError), \(saveError.localizedDescription)")
        }
    }
    
    @IBAction func cancelToClientsDetailViewController(_ segue: UIStoryboardSegue)
    {
        print("Back to the ClientProfileViewController")
    }
    
    
    @IBAction func saveClientDogDetail(_ segue: UIStoryboardSegue)
    {
        print("ClientDogEntryViewController saveClientDogDetail")
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
            print("ClientDogEntryViewController saveClientDogDetail dog:\(dog)")
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
