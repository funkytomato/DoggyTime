//
//  DogProfileViewController.swift
//  DoggyTimev2
//
//  Created by Jason Fry on 23/10/2017.
//  Copyright © 2017 Jason Fry. All rights reserved.
//

import UIKit


class DogProfileViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    //MARK:- IBOutlets
    @IBOutlet weak var dognameField: UITextField!
    //@IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    //@IBOutlet weak var breedField: UITextField!
    @IBOutlet weak var breedPicker: UIPickerView!
    @IBOutlet weak var breedpictureView: UIImageView!
    @IBOutlet weak var sizePicker: UIPickerView!
    //@IBOutlet weak var sizeField: UITextField!
    @IBOutlet weak var pictureView: UIImageView!
    
    var breedDataSource = ["Unknown","German Shephard", "Rottweiler", "Beagle", "Bulldog", "Great Dane", "Poodle", "Doberman Pinscher", "Dachshund", "Siberian Huskey", "English Mastiff", "Pit Bull", "Boxer", "Chihuahua",   "Border Collie", "Pug", "Golden Retriever", "Labrador Retriever", "Pointer", "Terrier", "Chow Chow", "Yorkshire Terrier", "Vizsla", "Australian Sheperd", "Maltese Dog", "Greyhound", "Cavalier King Charles Spaniel", "Malinois", "Akita", "Affenpinscher", "Old English Sheepdog", "St. Bernard", "Pomeranian", "Saluki", "Lhasa Apso", "Australian Cattle Dog", "Pekingese", "Alaskan Malamute", "Cardigan Welsh Corgi", "Staffordshire Bull Terrier", "Basset Hound", "Newfoundland", "Great Pyrenees", "Bernese Mountain Dog", "Bull Terrier", "Bullmastiff", "Bernese Mountain Dog", "Bull Terrier", "Bullmastiff", "French Bulldog", "Norwich Terrier", "Bichon Frise", "Shetland Sheepdog", "Airedale Terrier", "Boston Terrier"]
    
    var genderDataSource = ["Male", "Female"]
    
    var sizeDataSource = ["Tiny", "Small", "Medium", "LARGE"]
    
    //MARK:- Properties
    
    //Data to send to profile controller
    weak var dogData : Dog?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        print("DogProfileViewController deinit")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        breedPicker.delegate = self
        breedPicker.dataSource = self
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        sizePicker.delegate = self
        sizePicker.dataSource = self
        
        if dogData != nil
        {
            self.dognameField.text = dogData?.dogname
            
            //self.sexFd.text = dogData?.sex
            if let row = genderDataSource.index(of: (dogData?.gender)!)
            {
                genderPicker.selectRow(row, inComponent: 0, animated: false)
            }
            
            
            //self.breedFd.text = dogData?.breed
            if let row = breedDataSource.index(of: (dogData?.breed?.description)!)
            {
                breedPicker.selectRow(row, inComponent: 0, animated: false)
                breedpictureView.image = UIImage(named: breedDataSource[row])
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
        print("DogProfileViewController prepare segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveDogDetail",
            //let dogid = dog
            let dogname = dognameField.text,
            let gender = dogData?.gender,
            let breed = dogData?.breed,
            let size = dogData?.size
           // let picture = pictureView.image
        {
            
            let dog = Dog(context: PersistentService.context)
            dog.dogname = dogname
            dog.gender = gender
            dog.breed = breed
            dog.size = size
            //dog.picture = picture
            
            self.dogData = dog
        }
    }
}

//MARK:- PickerView
extension DogProfileViewController
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
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
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
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
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == breedPicker
        {
            print(breedDataSource[row])
            
            breedpictureView.image = UIImage(named: breedDataSource[row])
            dogData?.breed = breedDataSource[row]
        }
        else if pickerView == genderPicker
        {
            print(genderDataSource[row])
            
            dogData?.gender = genderDataSource[row]
        }
        else if pickerView == sizePicker
        {
            print(sizeDataSource[row])
            
            dogData?.size = sizeDataSource[row]
        }
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
            sizePicker.resignFirstResponder()
        default:
            sizePicker.resignFirstResponder()
        }
        
        return true
    }
}

extension DogProfileViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) ->Bool
    {
        switch textField
        {
        case dognameField:
            genderPicker.becomeFirstResponder()
//        case genderPicker:
//            breedPicker.becomeFirstResponder()
//        case breedPicker:
//            sizePicker.becomeFirstResponder()
//        case sizePicker:
//            sizePicker.resignFirstResponder()

        default:
            sizePicker.resignFirstResponder()
            
        }
        return true
    }
}

/*
extension DogProfileViewController: UIPickerViewDelegate
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
