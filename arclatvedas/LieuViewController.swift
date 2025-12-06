//
//  LieuViewController.swift
//  arclatvedas
//
//  Created by divol on 11/05/2016.
//  Copyright © 2016 jack. All rights reserved.
// INFO: https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

import UIKit
import MapKit
import CoreLocation

class LieuViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    
    var lieux = [LieuAnnotation]()

    
    func loadInitialData() {
        // 1
        let fileName = Bundle.main.path(forResource: "lieux", ofType: "json");
        //    var readError : NSError?
        var data: Data?
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: fileName!), options: NSData.ReadingOptions(rawValue: 0))
        } catch _ {
            data = nil
        }
        
        // 2
        //    var error: NSError?
        var jsonObject: Any? = nil
        if let data = data {
            do {
                jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
            } catch _ {
                jsonObject = nil
            }
        }
        
        // 3
        if let jsonObject = jsonObject as? [[String: String]] {
            for item in jsonObject {
                //print (item);
                
          //      [{"title":"Terrain","subtitle":"ALV-MMM","lat":"43.581268","long":"3.838444" },

                 let title:String = (item["title"])!
                let  subtitle:String = (item["subtitle"])!
                let latitude = ( (item["lat"])! as NSString).doubleValue
                let longitude = ((item["long"])! as NSString).doubleValue
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

                let unlieu = LieuAnnotation(title: title,sub:subtitle, coordinate:coordinate)
                lieux.append(unlieu)


            }

        }
            // 4
    }
    
    
    
    
    
    let initialLocation = CLLocation(latitude: 43.567051, longitude: 3.898359)
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }

    
    
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            map.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            map.showsUserLocation = false
        @unknown default:
            map.showsUserLocation = false
        }
    }

    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            let name = detail.value(forKey: "name") as AnyObject
            
            self.navigationItem.title = NSLocalizedString(name.description, comment:"data")
            
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        locationManager.delegate = self
        
        centerMapOnLocation(initialLocation)
     //   let salle = LieuAnnotation(title: "Salle",sub:"", coordinate: CLLocationCoordinate2D(latitude: 43.567051, longitude: 3.898359))
        
      //  map.addAnnotation(salle)

        
        loadInitialData()
        map.addAnnotations(lieux)

        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

// MARK: MKMapViewDelegate
extension LieuViewController: MKMapViewDelegate {
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LieuAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type:.detailDisclosure)
            }
            return view
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! LieuAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }

}

// MARK: CLLocationManagerDelegate
extension LieuViewController: CLLocationManagerDelegate {
    // iOS 14+
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
    
    // iOS < 14
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationStatus()
    }
}
