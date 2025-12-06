//
//  MasterViewController.swift
//  arclatvedas
//
//  Created by divol on 23/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreData

import CoreDataProxy

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    enum Table: Int {
        case infos = 0, mandats, photos, materiel,fleches,charte, distances, scores,chrono, lieux, apropos
    }
    
    
    var detailViewController: DetailViewController? = nil
   // var managedObjectContext: NSManagedObjectContext? = nil
    
    // MARK: - Fetched results controller
    
    var fetchedResultsEventController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsForEventController != nil {
            return _fetchedResultsForEventController!
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entity(forEntityName: "Event", in: DataManager.getContext())
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "ordre", ascending: true)
        //let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.getContext(), sectionNameKeyPath: nil, cacheName: nil) //"Master"
        aFetchedResultsController.delegate = self
        _fetchedResultsForEventController = aFetchedResultsController
        
        var error: NSError? = nil
        do {
            try _fetchedResultsForEventController!.performFetch()
        } catch let error1 as NSError {
            error = error1
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(String(describing: error)), \(String(describing: error?.userInfo))")
            abort()
        }
        
        return _fetchedResultsForEventController!
    }
    var _fetchedResultsForEventController: NSFetchedResultsController<NSFetchRequestResult>? = nil
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        // Do any additional setup after loading the view, typically from a nib.
        //        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        //
        //        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewEventObject:")
        //        self.navigationItem.rightBarButtonItem = addButton
        
        
        if let split = self.splitViewController {
           // let controllers = split.viewControllers
            if split.viewControllers.count > 1 {
                self.detailViewController = self.splitViewController?.viewControllers[1] as? DetailViewController
            }

           // self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }
    //CharteViewController
    override func viewWillAppear(_ animated: Bool){
        let sectionInfo = self.fetchedResultsEventController.sections![0] 
        let compte = sectionInfo.numberOfObjects
        
        
        
        if (compte == 0){
            
            self.initNewEventObject("Les informations",url:"http://arclatvedas.free.fr/index.php?option=com_content&view=article&id=194&tmpl=component",ordre:Table.infos.rawValue + 1)
            
            self.initNewEventObject("Les mandats",url:"http://arclatvedas.free.fr/index.php?option=com_content&view=article&id=228&tmpl=component",ordre:Table.mandats.rawValue + 1)
            self.initNewEventObject("Photos",url:"https://www.flickr.com/photos/arclatvedas/",ordre:Table.photos.rawValue + 1)
            
            self.initNewEventObject("Matériel",url:"",ordre:Table.materiel.rawValue + 1)
            
            self.initNewEventObject("Flèches",url:"",ordre:Table.fleches.rawValue + 1)
            
            self.initNewEventObject("Sélecteur de flèche",url:"",ordre:Table.charte.rawValue + 1)

            self.initNewEventObject("Distances",url:"",ordre:Table.distances.rawValue + 1)
            
            self.initNewEventObject("Scores",url:"",ordre:Table.scores.rawValue + 1)
            
            self.initNewEventObject("Lieux",url:"",ordre:Table.lieux.rawValue + 1)

            self.initNewEventObject("Chrono",url:"",ordre:Table.chrono.rawValue + 1)
            
            self.initNewEventObject("À propos d'Arc Lat'Védas",url:"http://arclatvedas.free.fr/index.php?option=com_content&view=article&id=20&tmpl=component",ordre:Table.apropos.rawValue + 1)
            
        }else{
             if (compte == 8){
                //ajout d'un calcul de spin

                 self.initNewEventObject("Sélecteur de flèche",url:"",ordre:Table.charte.rawValue + 1)
                
                 self.initNewEventObject("Lieux",url:"",ordre:Table.lieux.rawValue + 1)
                
                self.initNewEventObject("Chrono",url:"",ordre:Table.chrono.rawValue + 1)
            }
            
            if (compte == 9){
                
                self.initNewEventObject("Lieux",url:"",ordre:Table.lieux.rawValue + 1)
                
                self.initNewEventObject("Chrono",url:"",ordre:Table.chrono.rawValue + 1)
                
            }
            
            if (compte == 10){
                
                self.initNewEventObject("Chrono",url:"",ordre:Table.chrono.rawValue + 1)
                
            }
            //mise a jour des indexs
            var count = 1
            for event in self.fetchedResultsEventController.fetchedObjects as! [NSManagedObject] {
                
                
                event.setValue(count, forKey: "ordre")
                count += 1
            }
            let context = self.fetchedResultsEventController.managedObjectContext
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initNewEventObject(_ name:String, url:String, ordre : Int) {
        let context = self.fetchedResultsEventController.managedObjectContext
        let entity = self.fetchedResultsEventController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: entity.name!, into: context) 
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(Date(), forKey: "timeStamp")
        newManagedObject.setValue(name, forKey: "name")
        newManagedObject.setValue(url, forKey: "url")
        newManagedObject.setValue(ordre, forKey: "ordre")
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
    
    
    
    func insertNewEventObject(_ sender: AnyObject) {
        let context = self.fetchedResultsEventController.managedObjectContext
        let entity = self.fetchedResultsEventController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObject(forEntityName: entity.name!, into: context) 
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(Date(), forKey: "timeStamp")
        newManagedObject.setValue("", forKey: "name")
        newManagedObject.setValue("", forKey: "url")
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
        
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsEventController.object(at: indexPath) as! NSManagedObject
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else{
            if segue.identifier == "webview" {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let object = self.fetchedResultsEventController.object(at: indexPath) as! NSManagedObject
                    let controller = (segue.destination as! UINavigationController).topViewController as! WebViewController
                    controller.detailItem = object
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }else {
                if segue.identifier == "matos" {
                    if let indexPath = self.tableView.indexPathForSelectedRow {
                        //let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
                        let controller = (segue.destination as! UINavigationController).topViewController as! ListeViewController
                        
//                        controller.managedObjectContext=self.managedObjectContext;
                        
                        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                        
                        controller.navigationItem.leftItemsSupplementBackButton = true
                        let row:Table = Table(rawValue: (indexPath as NSIndexPath).row)!
                        
                        switch (row ){
                        case Table.materiel:
                            controller.tablename="Materiel"
                        case Table.fleches:
                            controller.tablename="Fleche"
                        case Table.distances:
                            controller.tablename="Distance"
                        case Table.scores:
                            controller.tablename="Tir"
                        default:
                            controller.tablename=""
                        }
                        
                        
                    }
                    
                    
                } else {
                    if segue.identifier == "statistique" {
                        let controller = (segue.destination as! UINavigationController).topViewController as! StatistiqueViewController
//                        controller.managedObjectContext=self.managedObjectContext;
                        
                        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                        
                        controller.navigationItem.leftItemsSupplementBackButton = true
                        
                        controller.tablename="Tir"
                        
                    } else {
                        
                        if segue.identifier == "charteSegue" {
                            let controller = (segue.destination as! UINavigationController).topViewController as! CharteViewController
                            //                        controller.managedObjectContext=self.managedObjectContext;
                            
                            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                            
                            controller.navigationItem.leftItemsSupplementBackButton = true
                            
                            controller.tablename="SpinCharte"
                            
                        } else {
                            if segue.identifier == "lieux" {
                                let controller = (segue.destination as! UINavigationController).topViewController as! LieuViewController
                                //                        controller.managedObjectContext=self.managedObjectContext;
                                
                                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                                
                                controller.navigationItem.leftItemsSupplementBackButton = true
                                
                            } else {
                                if segue.identifier == "chrono" {
                                    let controller = (segue.destination as! UINavigationController).topViewController as! ChronoViewController
                                    //                        controller.managedObjectContext=self.managedObjectContext;
                                    
                                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                                    
                                    controller.navigationItem.leftItemsSupplementBackButton = true
                                    
                                }
                            }
                        }
                        
                    }
                }
                
            }
            
            
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       // var  ii = self.fetchedResultsEventController.sections?.count
        
        return self.fetchedResultsEventController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsEventController.sections![section] 
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuViewCell
        
        
        if let but = cell.but{
            
            but.removeFromSuperview()
        }

        
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
       // let object = self.fetchedResultsEventController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        let row:Table = Table(rawValue: (indexPath as NSIndexPath).row)!
        //case Infos = 0, Mandats, Photos, Materiel,Fleches, Distances, Scores, Apropos
        
        switch (row ){
            
        case .infos,.mandats,.photos,.apropos:
            
            self.performSegue(withIdentifier: "webview", sender: self)
            
        case .materiel:
            self.performSegue(withIdentifier: "matos", sender: self)
        case .fleches:
            self.performSegue(withIdentifier: "matos", sender: self)
        case .charte:
            self.performSegue(withIdentifier: "charteSegue", sender: self)
        case .distances:
            self.performSegue(withIdentifier: "matos", sender: self)
        case .scores:
            self.performSegue(withIdentifier: "matos", sender: self)
        case .lieux:
            self.performSegue(withIdentifier: "lieux", sender: self)
        case .chrono:
            self.performSegue(withIdentifier: "chrono", sender: self)
//        default:
//            let page :String = object.valueForKey("url")!.description
//            if (!page.isEmpty){
//                self.performSegueWithIdentifier("webview", sender: self)
//            }
            
        }
        
        
    }
    
    @objc func pressedStat(_ sender: UIButton!) {
        
        
        performSegue(withIdentifier: "statistique", sender: self)
    }
    //    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if editingStyle == .Delete {
    //            let context = self.fetchedResultsController.managedObjectContext
    //            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
    //
    //            var error: NSError? = nil
    //            if !context.save(&error) {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                //println("Unresolved error \(error), \(error.userInfo)")
    //                abort()
    //            }
    //        }
    //    }
    
    func configureCell(_ cell: MenuViewCell, atIndexPath indexPath: IndexPath) {
        let object = self.fetchedResultsEventController.object(at: indexPath) as! NSManagedObject
        cell.textLabel!.text = NSLocalizedString((object.value(forKey: "name")! as AnyObject).description, comment:"data")
        
        cell.but = nil
        
        let ordre = object.value(forKey: "ordre") as? NSNumber
        if  ordre?.intValue ==  Table.scores.rawValue+1 {
            
            let b:UIButton = UIButton(type: UIButton.ButtonType.system)
            b.frame = CGRect(x: 200 ,y: 0 ,width: 100, height:cell.contentView.frame.height)
            b.backgroundColor = UIColor.white
            b.setTitle( "Graph", for: UIControl.State())
            b.setTitleColor(UIColor.black, for: UIControl.State())
            b.tag = 666
            b.addTarget(self, action: #selector(MasterViewController.pressedStat(_:)), for: .touchUpInside)
            
            cell.contentView.addSubview(b)
            cell.but = b
            
        }

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
            tableView.reloadRows(at: [indexPath!], with:.automatic)

           // self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
//        default:
//            return
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    /*
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    // In the simplest, most efficient, case, reload the table view.
    self.tableView.reloadData()
    }
    */
    
    
    
    
    
}

