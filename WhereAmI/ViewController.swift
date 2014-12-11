//
//  ViewController.swift
//  WhereAmI
//
//  Created by swift on 12/10/14.
//  Copyright (c) 2014 Georgia Institute of Technology. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    
    var locationManager : CLLocationManager?
    var circleOverlay : MKCircle?
    var circleRenderer : MKCircleRenderer?
    
    //This functions sets the map to satellite view
    @IBAction func setSatelite(sender: AnyObject) {
        myMapView.mapType = MKMapType.Satellite
    }
    
    //This functions sets the map to standard view
    @IBAction func setStandard(sender: AnyObject) {
        myMapView.mapType = .Standard
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myMapView.delegate = self
        
        // Create the location manager if this
        if (nil == locationManager) {
            
            locationManager = CLLocationManager()
        }
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // set a movement threshold
        locationManager?.distanceFilter = 50;
        
        locationManager?.requestWhenInUseAuthorization()
        
        locationManager?.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let cllocations = locations as [CLLocation]
        let location : CLLocation = cllocations.last!
        
        // create a pin on your current location
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(location.coordinate)
        annotation.title = "You are Here"
        
        myMapView.addAnnotation(annotation)
        
        // zoom the map to your current location
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        myMapView.setRegion(region, animated: true)
        
        var circle = MKCircle(centerCoordinate: location.coordinate, radius: location.horizontalAccuracy)
        myMapView.addOverlay(circle)
        
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle{
            var circleRender = MKCircleRenderer(overlay: overlay)
            var fillColor = UIColor.blueColor()
            var strokeColor = UIColor.blackColor()
            
            circleRender.fillColor = fillColor
            circleRender.strokeColor = strokeColor
            circleRender.lineWidth = 4
            
            return circleRender
        }else{
            return nil
        }
    }
}

