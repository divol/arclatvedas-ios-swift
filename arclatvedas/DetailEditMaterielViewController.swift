//
//  DetailEditMaterielViewController.swift
//  arclatvedas
//
//  Created by divol on 28/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import MobileCoreServices
import UIKit
//import AssetsLibrary
import Photos
import CoreDataProxy
import CoreData
class DetailEditMaterielViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var matos: UITextField!
    @IBOutlet weak var serialnumber: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var commentaire:UITextView!
    @IBOutlet weak var viewimage:UIImageView!
    
    
    var newMedia: Bool?
    
    var context : AnyObject?
    
    var patha:String?=nil
    
    var imageManager:PHImageManager = PHImageManager.default();
    
    var imageframe:CGRect?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let singleTap = UITapGestureRecognizer(target: self, action:#selector(tapDetected))
        singleTap.numberOfTapsRequired = 1
        
        imageframe = viewimage.frame;
        viewimage.isUserInteractionEnabled = true
        viewimage.addGestureRecognizer(singleTap)
        
        
        
        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DetailEditMaterielViewController.saveObject(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        // Do any additional setup after loading the view.
          self.configureView()
    }

    
    @objc func tapDetected() {
        
        let theframe:CGRect?
        let small = (viewimage.frame == imageframe)
        if (small){
            let statusBarHeight = view.window?.windowScene?
                .statusBarManager?
                .statusBarFrame.height ?? 0

            let mtop = self.navigationController!.navigationBar.frame.size.height + statusBarHeight

            
            
            var taille: CGFloat = min(self.view.frame.size.width, self.view.frame.size.height)
            if taille == self.view.frame.size.height {
                taille -= mtop
            }
            
            
            theframe = CGRect(x: 0,y: mtop, width: taille, height: taille)
        }else{
            theframe = imageframe!

        }
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                  self.viewimage.frame = theframe!
            
            }, completion: { finished in
                
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
    
    
    
    
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: NSManagedObject = self.detailItem  as? NSManagedObject{
            
           // self.navigationItem.title = ""
            var value : String
            if let textename = self.matos {
                 value = detail.value(forKey: "name") as! String
                textename.text = value
            }
            
            if let texteserialnumber = self.serialnumber {
                value = detail.value(forKey: "serialnumber") as! String
                texteserialnumber.text = value
            }
            
            if let textedate = self.date {
                
                let dateFormat:DateFormatter = DateFormatter()
                dateFormat.dateStyle = DateFormatter.Style.short
                dateFormat.dateFormat="dd/MM/yy"
                let ladate:Date  = detail.value(forKey: "timeStamp") as! Date
                
                
                let dateString:String = dateFormat.string(from: ladate)
                
                textedate.text = dateString
            }
            
            if let textecommentaire = self.commentaire {
                value = detail.value(forKey: "comment") as! String
                textecommentaire.text = value
            }
            
            if let texteimage = self.viewimage {
                if let id = detail.value(forKey: "imagepath") as? String, !id.isEmpty {
                    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                    if status == .authorized || status == .limited {
                        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
                        if let asset = assets.firstObject {
                            let targetSize = UIScreen.main.bounds.size
                            let options = PHImageRequestOptions()
                            options.isNetworkAccessAllowed = true
                            options.deliveryMode = .highQualityFormat
                            imageManager.requestImage(for: asset,
                                                      targetSize: targetSize,
                                                      contentMode: .aspectFit,
                                                      options: options) { result, info in
                                if let img = result {
                                    texteimage.image = img
                                }
                            }
                        }
                    } else if status == .notDetermined {
                        PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in
                            // éventuellement recharger la vue
                            self.view.layoutIfNeeded()
                        }
                    } else {
                        // afficher un message expliquant que la lecture des photos est refusée
                    }
                }
            }
            //
        }
    }

    
    
    
    @objc func saveObject(_ sender: AnyObject) {
    if let detail: AnyObject = self.detailItem {
        

        let dateFormat:DateFormatter = DateFormatter()
        dateFormat.dateStyle = DateFormatter.Style.short
        dateFormat.dateFormat="dd/MM/yy"
        let ladate :Date = dateFormat.date(from: self.date.text!)!
        
        detail.setValue(ladate, forKey: "timeStamp")
        detail.setValue(self.matos.text, forKey: "name")
        detail.setValue(self.serialnumber.text, forKey: "serialnumber")
        detail.setValue(self.commentaire.text, forKey: "comment")
        if self.patha != nil {
            detail.setValue(self.patha, forKey: "imagepath")
        }
        
        
        DataManager.saveManagedContext()
        
//        if let cont:AnyObject = self.context {
//            var error: NSError? = nil
//            if !cont.save(&error) {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                //println("Unresolved error \(error), \(error.userInfo)")
//                abort()
//            }
//
//        }
        
        }
    }
    
    
    
    @IBAction func useCamera(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerController.SourceType.camera)
            {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.mediaTypes = [UTType.image.identifier]
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true, 
                    completion: nil)
                newMedia = true
        }
    }
    
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        
        if let mediaType = info[.mediaType] as? String {
                // utilisation de mediaType
            
            if mediaType == "public.image" {
                if let image = info[.originalImage] as? UIImage {
                    viewimage.image = image
                    self.patha=nil;
                    self.dismiss(animated: true, completion: nil)
                    if newMedia == true {
                        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
                        switch status {
                        case .authorized, .limited:
                            var placeholder: PHObjectPlaceholder?
                            PHPhotoLibrary.shared().performChanges({
                                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                                placeholder = request.placeholderForCreatedAsset
                            }) { success, error in
                                if success, let id = placeholder?.localIdentifier {
                                    self.patha = id
                                } else {
                                    // If picking from library, try to read existing asset from info
                                    if let pickedAsset = info[.phAsset] as? PHAsset {
                                        self.patha = pickedAsset.localIdentifier
                                    }
                                    else
                                    {
                                        self.patha = nil
                                    }
                                }
                            }
                        case .notDetermined:
                            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                                if newStatus == .authorized || newStatus == .limited {
                                    var placeholder: PHObjectPlaceholder?
                                    PHPhotoLibrary.shared().performChanges({
                                        let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                                        placeholder = request.placeholderForCreatedAsset
                                    }) { success, error in
                                        if success, let id = placeholder?.localIdentifier {
                                            self.patha = id
                                        } else if let pickedAsset = info[.phAsset] as? PHAsset {
                                            self.patha = pickedAsset.localIdentifier
                                        }
                                    }
                                } else {
                                    // informer l’utilisateur que la sauvegarde n’est pas possible
                                }
                            }
                        case .denied, .restricted:
                            // afficher un message expliquant comment activer l’accès dans Réglages
                            break
                        @unknown default:
                            break
                        }
                    }

                    
                }
            }
                
        }
        
       
        
       
    }

    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        else { return }
        
        if let mediaType = info[.mediaType] as? String {
                // utilisation de mediaType
            }
        self.dismiss(animated: true, completion: nil)
        
        
        
        if mediaType == kUTTypeImage as String {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            viewimage.image = image
            self.patha=nil;
            if (newMedia == true) {
                
                
                /*
                let library:ALAssetsLibrary = ALAssetsLibrary()
               
                library.writeImage(toSavedPhotosAlbum: image.cgImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!, completionBlock: { (path,err) -> Void in
                     self.patha = path?.description
                })
                
//                UIImageWriteToSavedPhotosAlbum(image, self,
//                    "image:didFinishSavingWithError:contextInfo:", nil)
                
                */
            } else if mediaType == kUTTypeMovie as String {
                // Code to support video here
            }
            
        }
    }
    */
    func image(_ image: UIImage, didFinishSavingWithError error: NSErrorPointer?, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

