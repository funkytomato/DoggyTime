//
//  CameraViewController.swift
//  DoggyTime
//
//  Created by Spaceman on 26/09/2017.
//  Copyright © 2017 Spaceman. All rights reserved.
//

import UIKit
import Photos

class CameraViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{

    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Camera: UIButton!
    
    @IBOutlet weak var ImageDisplay: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CameraAction(_ sender: UIButton)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
    }
    

    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        ImageDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
    }
    
    @IBAction func PhotoLibraryAction(_ sender: UIButton)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func addAsset(image: UIImage, to album: PHAssetCollection)
    {
        PHPhotoLibrary.shared().performChanges({
            // Request creating an asset from the image.
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            // Request editing the album.
            guard let addAssetRequest = PHAssetCollectionChangeRequest(for: album)
                else { return }
            // Get a placeholder for the new asset and add it to the album editing request.
            addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
        }, completionHandler: { success, error in
            if !success { NSLog("error creating asset: \(String(describing: error))") }
        })
    }
}
