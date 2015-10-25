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
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        //request authorization before updating localition
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Create a query for places
        /*print("Doing a query")
        var query = PFQuery(className:"User")
        // Interested in locations near user.
        query.whereKey("username", equalTo:"prasu")
        // Limit what could be a lot of points.
        query.limit = 10
        // Final list of objects
        do {
            let nearbyPeople = try query.findObjects()
            print("number of people with iOS interest ", nearbyPeople.count)
        } catch {
            print(error)
        }*/
        
        
        
        
        
        
        
        var query = PFUser.query()! //PFQuery(className:"User")
        query.whereKey("mySkills", equalTo:"iOS")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject]! {
                    for object in objects {
                        print(object.objectForKey("location"))
                        print(object.objectForKey("username"))
                        
                        var mappoint = object.objectForKey("location")
                        
                        if(mappoint != nil) {
                            var annotation = MKPointAnnotation()
                            var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mappoint!.latitude, mappoint!.longitude)
                            annotation.coordinate = location
                            
                            annotation.title = object.objectForKey("username") as! String
                            var skills_list = object.objectForKey("mySkills")
                            print(skills_list)
                            
                            //var skills_string = skills_list.joinwith
                            
                            annotation.subtitle = "hello" //"-".join(object.objectForKey("mySkills")) as! String
                            print("printing annotation")
                            self.mapView.addAnnotation(annotation)
                            
                        }
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        mapView.mapType = MKMapType.Standard
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
        mapView.delegate = self
        
        //[mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
        //[mapView setDelegate:self];
        
   

    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]) {
  
        let location = locations.last as CLLocation!
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        self.mapView.setRegion(region, animated: true)
        
        let userGeoPoint = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        
        
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
