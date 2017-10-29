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
    @IBOutlet weak var dognameFd: UITextField!
    @IBOutlet weak var sexFd: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    @IBOutlet weak var breedFd: UITextField!
    @IBOutlet weak var breedPicker: UIPickerView!
    @IBOutlet weak var breedpictureView: UIImageView!
    @IBOutlet weak var sizePicker: UIPickerView!
    //@IBOutlet weak var sizeFd: UITextField!
    @IBOutlet weak var pictureView: UIImageView!
    
    var breedDataSource = ["German Shephard", "Rottweiler", "Beagle", "Bulldog", "Great Dane", "Poodle", "Doberman Pinscher", "Dachshund", "Siberian Huskey", "English Mastiff", "Pit Bull", "Boxer", "Chihuahua",   "Border Collie", "Pug", "Golden Retriever", "Labrador Retriever", "Pointer", "Terrier", "Chow Chow", "Yorkshire Terrier", "Vizsla", "Australian Sheperd", "Maltese Dog", "Greyhound", "Cavalier King Charles Spaniel", "Malinois", "Akita", "Affenpinscher", "Old English Sheepdog", "St. Bernard", "Pomeranian", "Saluki", "Lhasa Apso", "Australian Cattle Dog", "Pekingese", "Alaskan Malamute", "Cardigan Welsh Corgi", "Staffordshire Bull Terrier", "Basset Hound", "Newfoundland", "Great Pyrenees", "Bernese Mountain Dog", "Bull Terrier", "Bullmastiff", "Bernese Mountain Dog", "Bull Terrier", "Bullmastiff", "French Bulldog", "Norwich Terrier", "Bichon Frise", "Shetland Sheepdog", "Airedale Terrier", "Boston Terrier"]
    
    var genderDataSource = ["Male", "Female"]
    
    var sizeDataSource = ["Tiny", "Small", "Medium", "LARGE"]
    
    //MARK:- Properties
    let dataSource: DogsDataSource?
    
    //Data to send to profile controller
    var dogData : Dog?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.dataSource = DogsDataSource(dogs: SampleData.generateDogsData())
        super.init(coder: aDecoder)
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
        
        //Do additional setup
        self.dognameFd.text = dogData?.dogName
        
        //self.sexFd.text = dogData?.sex
        if let row = genderDataSource.index(of: (dogData?.sex.description)!)
        {
            genderPicker.selectRow(row, inComponent: 0, animated: false)
        }
        
        
        //self.breedFd.text = dogData?.breed
        if let row = breedDataSource.index(of: (dogData?.breed.description)!)
        {
            breedPicker.selectRow(row, inComponent: 0, animated: false)
            breedpictureView.image = UIImage(named: breedDataSource[row])
        }
        
        //self.sizeFd.text = dogData?.size
        self.pictureView.image = dogData?.picture
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        //Dispose of any resources that can be recreated
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
        }
    }
}

//MARK:- IBActions
extension DogProfileViewController
{
    
    
}


//MARK:- UITableViewDataSource
extension DogProfileViewController
{
    //DO NOT DO BECAUSE WRITE TO INDIVIDUAL ROWS
/*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let dog = dataSource?.dogs[indexPath.row]
        cell.textLabel?.text = dog?.dogName
        return cell
    }
 */
}

