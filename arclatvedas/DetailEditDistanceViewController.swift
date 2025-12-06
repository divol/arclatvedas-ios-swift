//
//  DetailEditDistanceViewController.swift
//  arclatvedas
//
//  Created by divol on 28/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreDataProxy

class DetailEditDistanceViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, resultDelegateProtocol,UITextFieldDelegate {
    
    var context : AnyObject?
    var nsarrayhausses :[Hausse]?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var unit: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    
 

    
    
    var detailItem: Distance? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DetailEditDistanceViewController.saveObject(_:)))
        self.navigationItem.rightBarButtonItem = saveButton

//        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveObject:")
//        self.navigationItem.rightBarButtonItem = saveButton
        // Do any additional setup after loading the view.
        
        unit.addTarget(self, action: #selector(DetailEditDistanceViewController.changeUnit(_:)), for: .valueChanged)
        
        name.delegate = self
        
        self.configureView()
        
    }
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail:Distance = self.detailItem {
            
            
            if let textename = self.name {
                textename.text = (detail.value(forKey: "name")! as AnyObject).description
            }
            
            if let textetaille = self.unit {
              
                let value:String = detail.value(forKey: "unit") as! String
                
                if value == "yard" {
                    textetaille.selectedSegmentIndex = 1;
                }else{
                     textetaille.selectedSegmentIndex = 0;
                }
                
            }
            
            
            var nsarray:[Hausse] = detail.relationship.allObjects as! [Hausse]
            
            nsarray.sort(by: { (s1: Hausse, s2: Hausse) -> Bool in
                return (s1.name.count < s2.name.count)
            })


            nsarrayhausses = nsarray
            
            
            if let table: AnyObject = self.tableview {
                table.reloadData()
            }
        }
    }
    
    
    
    @objc func changeUnit(_ sender: UISegmentedControl) {
        if let detail: AnyObject = self.detailItem  {
        switch sender.selectedSegmentIndex {
        case 0:
            
             detail.setValue("mètre", forKey: "unit")
        case 1:
             detail.setValue("yard", forKey: "unit")
        default:
             detail.setValue("mètre", forKey: "unit")
        }
              saveObject(self)
        }
    }

    
     func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let detail: AnyObject = self.detailItem  {
            
            
            detail.setValue(self.name.text, forKey: "name")

        }
    }
    
    @objc func saveObject(_ sender: AnyObject) {
        if let detail: Distance = self.detailItem  {
            
            let ladate :Date = Date()
            
            detail.setValue(self.name.text, forKey: "name")
           // let toto = self.unit.selectedSegmentIndex
            
            
            if self.unit.selectedSegmentIndex == 0 {
                 detail.setValue("mètre", forKey: "unit")
            }else{
                 detail.setValue("yard", forKey: "unit")
            }

            detail.setValue(ladate, forKey: "timeStamp")
            detail.setValue("", forKey: "comment")

            
            
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
    
    
    
    //MARK: tabledatasource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nsarrayhausses!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "innerDistance", for: indexPath) as! DistanceCellEdit
        
        
        let toto:NSArray
        
        toto = NSArray(array: nsarrayhausses!)
        let h:Hausse = toto[(indexPath as NSIndexPath).row] as! Hausse

        cell.datahausse = h
        cell.resultDelegate = self
        cell.distance.text = h.name
        cell.hausse.text =  h.hausse
        cell.rowindice = (indexPath as NSIndexPath).row
        return cell;
    }

    
      func resultChange(_ therow : Int , name:String , hausse : String)
      {
//        let h:PseudoHausse =  jocker[therow] as! PseudoHausse
//        h.name = name
//        h.hausse = hausse
        
        saveObject(self)
        
        
      }
    
}
