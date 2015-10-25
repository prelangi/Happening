//
//  MapViewController.swift
//  Happening
//
//  Created by Prasanthi Relangi on 10/24/15.
//  Copyright © 2015 TeamAwesomeHackingEDU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse


class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBAction func didPressBackButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    var locationManager:CLLocationManager!
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Do any additional setup after loading the view, typically from a nib.
        //Get current location
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        //request authorization before updating localition

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        

        

        

        
        let query = PFUser.query()! //PFQuery(className:"User")
        query.whereKey("mySkills", equalTo:"iOS")
        query.whereKey("location", nearGeoPoint:(PFUser.currentUser()?.objectForKey("location"))! as! PFGeoPoint, withinKilometers: 50)
        query.limit = 10
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                // The find succeeded.
                
                print("Successfully retrieved \(objects!.count) people.")
                
                // Do something with the found objects
                
                if let objects = objects as [PFObject]! {
                    
                    for object in objects {

                        let annotation = MKPointAnnotation()
                        let pinName = object.objectForKey("username") as! String
                        let pinSubtitle = object.objectForKey("email") as! String
                        let pinSkills = object.objectForKey("mySkills") as! NSArray
                        let pinLocationPF = object.objectForKey("location") //as! PFGeoPoint
                        
                            var pinLocationCL:CLLocationCoordinate2D = CLLocationCoordinate2DMake(pinLocationPF!.latitude, pinLocationPF!.longitude)

                            
                            annotation.coordinate = pinLocationCL
                            annotation.title = pinName
                            annotation.subtitle = pinSubtitle
                            
                            self.mapView.addAnnotation(annotation)
                        
                        print(object.objectForKey("location"))
                        print(object.objectForKey("username"))
                        
                    
                    }
                
                } else {
                
                // Log details of the failure
                
                print("Error: \(error!) \(error!.userInfo)")
                
                }
            
            }
        }
    }
        // Do any additional setup after loading the view.
    
    override func viewDidAppear(animated: Bool) {
        mapView.mapType = MKMapType.Standard
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
        mapView.delegate = self
        
        //[mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
        //[mapView setDelegate:self];
        
   

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  
        let location = locations.last as CLLocation!
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapView.setRegion(region, animated: true)
        
//        let userGeoPoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        
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
