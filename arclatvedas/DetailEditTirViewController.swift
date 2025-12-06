//
//  DetailEditTirViewController.swift
//  arclatvedas
//
//  Created by divol on 28/04/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit
import CoreData
import CoreDataProxy

class DetailEditTirViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,
                                    UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LineChartDelegate,DataSourceChangedDelegate
    {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var totalLabel : UILabel!
    
    
    
    var label = UILabel()
    var lineChart: LineChart!

     @IBOutlet weak var statview: UIView!
    
    
    fileprivate let reuseIdentifier = "scoreButtons"
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    
    
    let distances = ["5","10","15","18","20","25","30","40","50","60","70"]
    let valeurs = ["X","10","9","8","7","6","5","4","3","2","1","M"]
    let colors = [UIColor.yellow,UIColor.yellow,UIColor.yellow,UIColor.red,UIColor.red,UIColor.blue,UIColor.blue,UIColor.black,UIColor.black,UIColor.white,UIColor.white,UIColor.white]
    
    
     let textcolors = [UIColor.black,UIColor.black,UIColor.black,
                UIColor.black,UIColor.black,
                UIColor.white,UIColor.white,
                UIColor.white,UIColor.white,
                UIColor.black,UIColor.black,UIColor.black]
    
    
    
     let tags = [100,10,9,8,7,6,5,4,3,2,1,0]
    

   // var context : AnyObject?
    
    
    let NOMBREMAX : Int = 6
    var curVolee:Volee?
    var curCount:Int = -1
    
    
    var detailItem: Tir? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(self)
        
//        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveObject:")
//        self.navigationItem.rightBarButtonItem = saveButton
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(DetailEditTirViewController.editObject(_:)))
        self.navigationItem.rightBarButtonItem = editButton

        
        // Do any additional setup after loading the view.
        self.collection.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
        
        
       
        
        self.configureView()
        
        
        tableview.layer.borderColor = UIColor.darkGray.cgColor
        tableview.layer.borderWidth = 1.0;
        tableview.layer.cornerRadius = 0;
        tableview.clipsToBounds=true;

        
        
        
    }
    
    
    
    func configureView() {
        // Update the user interface for the detail item.
        guard let detail: Tir = self.detailItem else{
                return
        }
        self.navigationItem.title = detail.location + ":" + detail.distance
        
        totalLabel?.text = detail.getTotal().description
        
        

        
         if let detail: Tir = self.detailItem {
            if detail.volees.count > 0 {
                
                
                self.curVolee = detail.volees.lastObject as? Volee
                curCount = detail.volees.count-1
            }else{
                curVolee = createEmptyVolee()
                WatchSessionManager.sharedManager.transferUserInfo(["createEmptyVolee" : 0 as AnyObject])
                saveObject(self)
                curCount = 0
            }
        }
        
    }
    
    @objc func editObject (_ sender: AnyObject) {
        if let detail: Tir = self.detailItem {
            let alert = UIAlertController(title: "Edit", message: "Message", preferredStyle: UIAlertController.Style.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
                
                var texts = alert.textFields
               for i in 0 ..< texts!.count{
                
                    let textField: UITextField = texts![i]
                    if textField.placeholder == "Localication:" {
                    
                        if let detail: Tir = self.detailItem {
                            
                            detail.setValue(textField.text, forKey: "location")
                        }

                    }else {
                         detail.setValue(textField.text, forKey: "distance")
                        
                    }
                
                }
                self.saveObject(self)
                self.navigationItem.title = detail.location + ":" + detail.distance

            }))
            let locastr=NSLocalizedString("Cancel", comment:"data")
            alert.addAction(UIAlertAction(title: locastr, style: UIAlertAction.Style.cancel, handler: nil))
            alert.addTextField(configurationHandler: {(textField: UITextField)  in
                textField.placeholder = "Localication:"
                textField.isSecureTextEntry = false
                if let detail: Tir = self.detailItem {
                    
                     textField.text = detail.location
                }
            })
            alert.addTextField(configurationHandler: {(textField: UITextField)  in
                textField.placeholder = "Distance:"
                textField.keyboardType = .decimalPad
                textField.isSecureTextEntry = false
                if let detail: Tir = self.detailItem {
                    
                    textField.text = detail.distance
                }

            })
            
                
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func saveObject(_ sender: AnyObject) {
        if let _: Tir = self.detailItem {
            
            
            self.view.resignFirstResponder()
            
//            let dateFormat:NSDateFormatter = NSDateFormatter()
//            dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
//            dateFormat.dateFormat="dd-MM-yy"
//            let ladate :NSDate = dateFormat.dateFromString("")!
//            
            
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
            
            if let detail: Tir = self.detailItem {
                totalLabel?.text = detail.getTotal().description
            }
            
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
    
    
    // MARK: Tableview ds
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let detail: Tir = self.detailItem {
            return detail.volees.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("voleeCell") as! UITableViewCell
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        for  (var i = 0 ; i < cell.contentView.subviews.count ; i++ ){
//            
//            let v:UIView = cell.contentView.subviews[i] as! UIView
//             v.removeFromSuperview()
//        }
       
         let detail: Tir = self.detailItem!
        

       
        let vol: Volee =  detail.volees.object(at: (indexPath as NSIndexPath).row) as! Volee
        
        let rect = CGRect(x: 5 ,y: 9 ,width: 30, height:21)
        
        let label:UILabel = UILabel(frame: rect)
        label.text = ((indexPath as NSIndexPath).row + 1).description
        label.backgroundColor = UIColor.gray
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 1.0;
        label.layer.cornerRadius = 8;
        label.clipsToBounds=true;

        
        label.textAlignment = .center
        
        
        cell.contentView.addSubview(label)
        
        
        for i in 0 ..< NOMBREMAX{
            //une constante pour le 6 !!
            let points:Int = vol.getAt(i)
            
            if points >= 0 {
                let x = 65 + (30 * i)
                
                let rect = CGRect(x: x ,y: 9 ,width: 30, height:21)
                
                let label:UILabel = UILabel(frame: rect)
                
                if points == 100 {
                    label.text = "X"
                }else  if points == 0 {
                    label.text = "M"

                } else {
                    label.text = points.description

                }
                label.textAlignment = .center
                if i % 2 == 0 {
                    label.backgroundColor = UIColor.white
                    
                }else {
                    label.backgroundColor = UIColor.lightGray
                }

                
                 cell.contentView.addSubview(label)
            }
            
         
        
        }

        
        
        
        
        return cell;
    }

     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let detail: Tir = self.detailItem {
                DataManager.deleteManagedObject(detail.volees.object(at: (indexPath as NSIndexPath).row) as! NSManagedObject)
//                self.context!.deleteObject(detail.volees.objectAtIndex(indexPath.row) as! NSManagedObject)
               // detail.volees.removeObjectAtIndex(indexPath.row)
                self.curCount -= 1
//                if self.curCount >= 0 {
//                    self.curVolee = detail.volees.lastObject as! Volee
//                } else {
//                    self.curVolee = nil
//                }
                
            }
            saveObject(self)
            if let detail: Tir = self.detailItem {
                
                if self.curCount >= 0 {
                    self.curVolee = detail.volees.lastObject as? Volee
                } else {
                    self.curVolee = nil
                }
                
            }


            tableView.deleteRows(at: [indexPath], with: .fade)
            

            DispatchQueue.global(qos:DispatchQoS.QoSClass.userInitiated).async { // 1
                DispatchQueue.main.async { // 2
                    self.tableview.reloadData()
                }
            }


            
            
        }
    }

    
    
    
    // MARK: pickerView ds
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return distances.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return distances[row]
    }
    


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return valeurs.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier , for:indexPath) 
        
         let cframe: CGRect = CGRect(x: 0 ,y: 0 ,width: cell.frame.width, height:cell.frame.height)
        
        
        let b:UIButton = UIButton(frame:cframe)
        
           // b.backgroundColor = UIColor.whiteColor()
        let c : UIColor = colors[(indexPath as NSIndexPath).item]
             b.backgroundColor = c
        
            b.tag = tags[(indexPath as NSIndexPath).item]
        b.setTitle( valeurs[(indexPath as NSIndexPath).item], for: UIControl.State())
//            b.setTitleColor(UIColor.blackColor(), forState: .Normal)
        b.setTitleColor(textcolors[(indexPath as NSIndexPath).item], for: UIControl.State())

            b.addTarget(self, action: #selector(DetailEditTirViewController.pressed(_:)), for: .touchUpInside)
        
        cell.addSubview(b)
        return cell
    }
    
 @IBAction func pressed(_ sender: UIButton!) {
    
    switch sender.tag {
        case 1000 :
        
            curVolee?.deleteLast();
            
            saveObject(self)
             WatchSessionManager.sharedManager.transferUserInfo(["deleteScore" : 0 as AnyObject])
            tableview.reloadData()

        break
        
       
        case 2000 :
              if let vol: Volee = self.curVolee {
                    if ((vol.getTaille() == NOMBREMAX)  || (vol.getTaille() == 3)) {
                        
                         saveObject(self)
                        
                        curVolee = createEmptyVolee()
                        WatchSessionManager.sharedManager.transferUserInfo(["createEmptyVolee" : 0 as AnyObject])
                         saveObject(self)
                        
                         if let detail: Tir = self.detailItem {
                        
                        curCount =  detail.volees.count-1
                            }
                        
                    }
              }
            if self.detailItem!.volees.count == 0 {
                curVolee = createEmptyVolee()
                WatchSessionManager.sharedManager.transferUserInfo(["createEmptyVolee" : 0 as AnyObject])
                saveObject(self)
                
                curCount=0

            }
            tableview.reloadData()

    case 3000 :
        UIView.transition(with: self.statview, duration: 0.325, options: .transitionFlipFromLeft, animations: { () -> Void in
            if  self.statview.alpha == 0.0 {
                if let detail: Tir = self.detailItem {
                    
                    if detail.volees.count > 1 {
                        self.buildChart()
                        self.statview.alpha=1.0
                        self.tableview.alpha=0.0
                    }
                
                }
            }else{
                self.statview.alpha=0.0
                self.tableview.alpha=1.0
            }
            
        }, completion: { (Bool) -> Void in
            
        })
        
        
        default :
            self.curVolee?.addScore(sender.tag, impact:CGPoint(x: 0,y: 0),zone:CGPoint(x: 0,y: 0));
            saveObject(self)
            WatchSessionManager.sharedManager.transferUserInfo(["addScore" : sender.tag as AnyObject])
            tableview.reloadData()
    }
    let index: IndexPath  = IndexPath(row: curCount, section: 0)
    tableview.scrollToRow(at: index, at:.none, animated: true)

    }

    
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            
            return CGSize(width: 46, height: 30)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func createEmptyVolee() -> Volee {
        
        
 
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Volee", in: DataManager.getContext())
        
        let volee = Volee(entity: entityDescription!, insertInto: DataManager.getContext())
        
        volee.setValue("[]", forKey: "volee")
        volee.setValue(detailItem!, forKey: "relationship")
        volee.setValue(0 ,forKey: "rang")
        
        
        
        detailItem!.volees.add(volee)
        
        return volee
    }
    
    
    
    
    func buildChart() {
        
//        var lineChart: LineChart!

        var views: [String: AnyObject] = [:]
        self.statview!.backgroundColor = UIColor.white
        
        
        label.text = "..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        self.statview.addSubview(label)
        views["label"] = label
        self.statview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
        self.statview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[label]", options: [], metrics: nil, views: views))
        
        // simple arrays
        var data: [CGFloat] = []
        var data2: [CGFloat] = []
        
        // simple line with custom x axis labels
        var xLabels: [String] = []
        
        if let detail: Tir = self.detailItem {
            for j in 0 ..< detail.volees.count{
                let vol: Volee =  detail.volees.object(at: j) as! Volee
               // let f:CGFloat = CGFloat(vol.getTotal())
                data.append(CGFloat(vol.getTotal()))
                var localtotal = 0
                var localcount = 0

                for i in 0 ..< NOMBREMAX{
                    
                    let points:Int = vol.getAt(i)
                    if points >= 0 {
                        
                        localcount += 1
                        if points == 100 {
                           localtotal += 10
                        }else  if points == 0 {
                            
                        } else {

                            localtotal += points
                        }

                    }
                    
                        
                }
                if localcount != 0 {
                 data2.append( CGFloat(localtotal / localcount))
                }else{
                    data2.append(0)

                }
                xLabels.append("\(j+1)")
            }
        }
        lineChart = LineChart()
        lineChart!.backgroundColor = UIColor.white
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.addLine(data2)
        
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.statview.addSubview(lineChart)
        views["chart"] = lineChart
        self.statview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[chart]-0-|", options: [], metrics: nil, views: views))
        
        self.statview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
        
        
        
        
    }
    
    
    /**
    * Line chart delegate method.
    */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "Volée: \(Int(x+1))     (Score,Moy): \(yValues)"
    }
    
    
    
    /**
    * Redraw chart on device rotation.
    */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }

    // MARK: - DataSourceChangedDelegate
    //DataSourceChangedDelegate
    func dataSourceDidUpdate(_ userInfo: [String : AnyObject]){
        
       // self.navigationController!.popViewControllerAnimated(true)
        DispatchQueue.global(qos:DispatchQoS.QoSClass.userInitiated).async { // 1
            DispatchQueue.main.async { // 2
                //self.tableview.reloadData()
            }
        }
        
        
        //updatenewtir()
        
    }
    
}
