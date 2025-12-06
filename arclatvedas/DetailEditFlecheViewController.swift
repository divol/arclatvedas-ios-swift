//
//  DetailEditFlecheViewController.swift
//  arclatvedas
//
//  Created by divol on 28/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreDataProxy
import CoreData

class DetailEditFlecheViewController: UIViewController {

    var context : AnyObject?

    
    @IBOutlet weak var nom: UITextField!
    @IBOutlet weak var taille: UITextField!
    @IBOutlet weak var spin: UITextField!
    @IBOutlet weak var plume: UITextField!
    @IBOutlet weak var pointe: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var commentaire:UITextView!

    
    
    

//    comment
//    feather
//    length
//    name
//    point
//    spin
//    timeStamp
    

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DetailEditFlecheViewController.saveObject(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        // Do any additional setup after loading the view.
        self.configureView()
        
    }

    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: NSManagedObject = self.detailItem as? NSManagedObject{
            
            
            
            if let textename = self.nom {
                let value = detail.value(forKey: "name") as! String
                textename.text = value
            }
            
            if let textetaille = self.taille {
                 //double
                let value = detail.value(forKey: "length") as! Double
                textetaille.text = value.description
            }
            
            if let textespin = self.spin {
               //int16
                let value = detail.value(forKey: "spin") as! NSNumber
                textespin.text = value.description
            }
            if let texteplume = self.plume {
                let value = detail.value(forKey: "feather") as! String
                texteplume.text = value
            }
            
            if let textepointe = self.pointe {
                let value = detail.value(forKey: "point") as! String
                textepointe.text = value
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
                let value = detail.value(forKey: "comment") as! String
                textecommentaire.text = value
            }

        }
    }
    

    
    @objc func saveObject(_ sender: AnyObject) {
        if let detail: NSManagedObject = self.detailItem as? NSManagedObject{
            
            
            let dateFormat:DateFormatter = DateFormatter()
            dateFormat.dateFormat="dd/MM/yy"
           // dateFormat.dateStyle = DateFormatter.Style.short
            
                let ladate = dateFormat.date(from: (self.date.text)! )!
                detail.setValue(ladate, forKey: "timeStamp")

           
           

            
            detail.setValue(self.nom.text, forKey: "name")
            
            let formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal;
            
            if let number = formatter.number(from: self.taille.text!) {
                detail.setValue(number, forKey: "length")
            }
            detail.setValue( NSNumber(value: Int(self.spin.text!)! as Int), forKey: "spin")
            
            detail.setValue(self.plume.text, forKey: "feather")
            detail.setValue(self.pointe.text, forKey: "point")

            detail.setValue(self.commentaire.text, forKey: "comment")

            
            DataManager.saveManagedContext()
            
            
//            if let cont:AnyObject = self.context {
//                var error: NSError? = nil
//                if !cont.save(&error) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    //println("Unresolved error \(error), \(error.userInfo)")
//                    abort()
//                }
//                
//            }
            
        }
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
