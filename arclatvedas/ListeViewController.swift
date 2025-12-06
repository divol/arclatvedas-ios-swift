//
//  ListeViewController.swift
//  arclatvedas
//
//  Created by divol on 27/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import Foundation


import UIKit
import CoreData
import CoreDataProxy

class ListeViewController : UITableViewController, NSFetchedResultsControllerDelegate,DataSourceChangedDelegate{
   // var managedObjectContext: NSManagedObjectContext? = nil
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entity(forEntityName: self.tablename, in: DataManager.getContext())
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        //let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil) //"Master"
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        do {
            try _fetchedResultsController!.performFetch()
        } catch let error1 as NSError {
            error = error1
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(String(describing: error)), \(String(describing: error?.userInfo))")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil
    

    
    
    var tablename:String = "[Unnamed]" {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.
        self.fetchedResultsController
        switch tablename{
            
        case "Materiel":
            self.navigationItem.title =  NSLocalizedString("Matériel", comment:"title")
            
        case "Distance":
           self.navigationItem.title = NSLocalizedString("Distances", comment:"title")
            
            
        case "Tir":
            self.navigationItem.title = NSLocalizedString("Scores", comment:"title")
        
        case "Fleche":
            self.navigationItem.title = NSLocalizedString("Flèches", comment:"title")
            
        default: break
            
            
        }


    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(self)
                // Do any additional setup after loading the view, typically from a nib.
                //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
                let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ListeViewController.insertNewObject(_:)))
                self.navigationItem.rightBarButtonItem = addButton
    }

 override   func viewWillAppear(_ animated: Bool){
          self.tableView.reloadData()
    }
    func insertNewMatosObject(_ newManagedObject: AnyObject) {
        
        let locastr=NSLocalizedString("Matériel", comment:"data")
        
        newManagedObject.setValue(Date(), forKey: "timeStamp")
        newManagedObject.setValue(locastr, forKey: "name")
        newManagedObject.setValue("S/N 00000000000", forKey: "serialnumber")
        newManagedObject.setValue("", forKey: "comment")
        newManagedObject.setValue("", forKey: "imagepath")

        
        
        
    }
    
    func insertNewDistanceObject(_ newManagedObject: Distance) {
        
        let locastr=NSLocalizedString("Distance", comment:"data")
        
        newManagedObject.setValue(Date(), forKey: "timeStamp")
        newManagedObject.setValue(locastr, forKey: "name")
        newManagedObject.setValue("", forKey: "comment")
        newManagedObject.setValue("m", forKey: "unit")
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Hausse", in:DataManager.getContext())

         let c = ["5","10","15","18","20","30","40","50","60","70"]
        
        for distance in c {
            
        
            let hausse = Hausse(entity: entityDescription!, insertInto: DataManager.getContext())
        
            hausse.name = distance
            hausse.hausse = "0"
            hausse.relationship = newManagedObject
            
            newManagedObject.relationship.add(hausse)
            
        }

        
        // println(newManagedObject.allHaussesDescription())
    }

    func insertNewTirObject(_ newManagedObject: Tir) {
        let locastr=NSLocalizedString("Au club", comment:"data")
        
        newManagedObject.setValue(Date(), forKey: "timeStamp")
        newManagedObject.setValue(locastr, forKey: "location")
        newManagedObject.setValue("70", forKey: "distance")
        newManagedObject.setValue("", forKey: "comment")
        
        // test
        let entityDescription = NSEntityDescription.entity(forEntityName: "Volee", in: DataManager.getContext())

        let volee = Volee(entity: entityDescription!, insertInto: DataManager.getContext())
        
        volee.volee = "[]"
        volee.rang = 1
       
        volee.relationship = newManagedObject
        
        
        
        newManagedObject.volees.add(volee)
        
         WatchSessionManager.sharedManager.transferUserInfo(["insertNewTir" : 0.description as AnyObject])
        

    }

    func insertNewFlecheObject(_ newManagedObject: AnyObject) {
        
        let locastr=NSLocalizedString("Lot de flêches", comment:"data")
        newManagedObject.setValue(Date(), forKey: "timeStamp")
        newManagedObject.setValue(locastr, forKey: "name")
        newManagedObject.setValue("", forKey: "feather")
        newManagedObject.setValue("", forKey: "comment")
        newManagedObject.setValue("", forKey: "point")
        newManagedObject.setValue(0.0, forKey: "length")
        newManagedObject.setValue(0, forKey: "spin")
        
        
    }

    
    @objc func insertNewObject(_ sender: AnyObject) {
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: entity.name!, into: context) 
        
        
        switch tablename{
            
        case "Materiel":
            insertNewMatosObject(newManagedObject)

        case "Distance":
              insertNewDistanceObject(newManagedObject as! Distance)

            
        case "Tir":
              insertNewTirObject(newManagedObject as! Tir)
        
        case "Fleche":
            insertNewFlecheObject(newManagedObject)
            
        default: break


        }

        
        
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        // Save the context.
        var error: NSError? = nil
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(String(describing: error)), \(String(describing: error?.userInfo))")
            abort()
        }
    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "materielSegue" ){
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailEditMaterielViewController
                
                controller.context  =  self.fetchedResultsController.managedObjectContext
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        } else if (segue.identifier == "flecheSegue" ){
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailEditFlecheViewController
                
                controller.context  =  self.fetchedResultsController.managedObjectContext
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if (segue.identifier == "distanceSegue" ){
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.object(at: indexPath) as! Distance
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailEditDistanceViewController
                
                controller.context  =  self.fetchedResultsController.managedObjectContext
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if (segue.identifier == "tirSegue" ){
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                
                let object = self.fetchedResultsController.object(at: indexPath) as! Tir
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailEditTirViewController
                // controller.context  = self.managedObjectContext
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if (segue.identifier == "blason" ){
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.object(at: indexPath) as! Tir
                let controller = (segue.destination as! UINavigationController).topViewController as! TargetController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }

        
        
        
        
        
        
        
        
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }else{
//            if segue.identifier == "webview" {
//                if let indexPath = self.tableView.indexPathForSelectedRow() {
//                    let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
//                    let controller = (segue.destinationViewController as! UINavigationController).topViewController as! WebViewController
//                    controller.detailItem = object
//                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                    controller.navigationItem.leftItemsSupplementBackButton = true
//                }
//            }
//        }
    }
    
    // MARK: - Table View
    
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)-> CGFloat{
    
    
    switch tablename{
    case "Tir":
        return 100
    case "Distance":
        
        return 161
     default:
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      //  var  ii = self.fetchedResultsController.sections?.count
        
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] 
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch tablename{
            
            case "Materiel":
                let cell = tableView.dequeueReusableCell(withIdentifier: "matoscell", for: indexPath) as! MatosCell
                self.configureMatosCell(cell, atIndexPath: indexPath)
                return cell
            case "Distance":
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "distancecell", for: indexPath) as! DistanceCell
                    self.configureDistanceCell(cell, atIndexPath: indexPath)
                return cell

            case "Tir":
                let cell = tableView.dequeueReusableCell(withIdentifier: "tircell", for: indexPath) as! TirCell
                self.configureTirCell(cell, atIndexPath: indexPath)
                return cell
            
            case "Fleche":
            let cell = tableView.dequeueReusableCell(withIdentifier: "flechecell", for: indexPath) as! FlecheCell
            self.configureFlecheCell(cell, atIndexPath: indexPath)
            return cell
            
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
            return cell
        }
        
       
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let context = self.fetchedResultsController.managedObjectContext
                context.delete(self.fetchedResultsController.object(at: indexPath) as! NSManagedObject)
    
                var error: NSError? = nil
                do {
                    try context.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    print("Unresolved error \(String(describing: error)), \(String(describing: error?.userInfo))")
                    abort()
                }
            }
        }
    
    func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        let object = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
        cell.textLabel!.text = (object.value(forKey: "name")! as AnyObject).description
    }
    func configureMatosCell(_ cell: MatosCell, atIndexPath indexPath: IndexPath) {
        let object = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
        cell.matos!.text = (object.value(forKey: "name")! as AnyObject).description
        cell.serialnumber!.text = (object.value(forKey: "serialnumber")! as AnyObject).description
    }
    
    func configureDistanceCell(_ cell: DistanceCell, atIndexPath indexPath: IndexPath) {
        let object = self.fetchedResultsController.object(at: indexPath) as! Distance

        cell.nom!.text = (object.value(forKey: "name")! as AnyObject).description
        cell.detailItem = object.getAllHaussesSorted()
        
        
    }
    
    func configureTirCell(_ cell: TirCell, atIndexPath indexPath: IndexPath) {
        let object = self.fetchedResultsController.object(at: indexPath) as! Tir
        cell.nom!.text=(object.value(forKey: "location")! as AnyObject).description
        cell.distance!.text=(object.value(forKey: "distance")! as AnyObject).description
        cell.total!.text = object.getTotal().description
        
        
       // let cframe: CGRect = CGRect(x: cell.contentView.frame.width-100 ,y: 0 ,width: 100, height:cell.contentView.frame.height)
        
        
        //let b:UIButton = UIButton(frame:cframe)
        let b:UIButton = UIButton(type: UIButton.ButtonType.system)
        b.frame = CGRect(x: cell.contentView.frame.width-100 ,y: 0 ,width: 100, height:cell.contentView.frame.height)
        b.backgroundColor = UIColor.white
        let locastr=NSLocalizedString("Blason", comment:"data")
        
        b.setTitle( locastr, for: UIControl.State())
        b.setTitleColor(UIColor.black, for: UIControl.State())
        
        b.addTarget(self, action: #selector(ListeViewController.pressedBlason(_:)), for: .touchUpInside)
        b.tag = (indexPath as NSIndexPath).row
        cell.contentView.addSubview(b)

        
        
    }

    func configureFlecheCell(_ cell: FlecheCell, atIndexPath indexPath: IndexPath) {
        let object = self.fetchedResultsController.object(at: indexPath) as! NSManagedObject
        cell.nom!.text = (object.value(forKey: "name")! as AnyObject).description
        cell.spin!.text = (object.value(forKey: "spin")! as AnyObject).description

    }

    
    
    @objc func pressedBlason(_ sender: UIButton!) {
        
       let idx =  IndexPath(row: sender.tag, section: 0)
        self.tableView.selectRow(at: idx, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        
        
       performSegue(withIdentifier: "blason", sender: self)
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
  

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
             if let dcell = tableView.cellForRow(at: indexPath!) {
            switch tablename{
                
            case "Materiel":
                    self.configureMatosCell(dcell as! MatosCell, atIndexPath: indexPath!)
                
            case "Distance":
                
                    self.configureDistanceCell(dcell as! DistanceCell, atIndexPath: indexPath!)
                
            case "Tir":
                    self.configureTirCell(dcell as! TirCell, atIndexPath: indexPath!)
                
                
            case "Fleche":
                self.configureFlecheCell(dcell as! FlecheCell, atIndexPath: indexPath!)
                
                
            default:
                self.configureCell(tableView.cellForRow(at: indexPath!)!, atIndexPath: indexPath!)
            }

            }
            
            
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    
    
    // MARK: - DataSourceChangedDelegate
    //DataSourceChangedDelegate
    func dataSourceDidUpdate(_ userInfo: [String : AnyObject]){
        
        //updatenewtir()
        
    }

    
    
    /*
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    // In the simplest, most efficient, case, reload the table view.
    self.tableView.reloadData()
    }

    */
    
    

    
    

    }
