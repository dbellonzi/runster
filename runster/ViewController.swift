//
//  ViewController.swift
//  runster
//
//  Created by Daniel Bellonzi on 1/18/18.
//  Copyright © 2018 Daniel Bellonzi. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var splitTime: UILabel!
    @IBOutlet weak var splitDistance: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var currentDistance: UILabel!
    var run = [RunDistance]()
    var totalDistance: Double = 0.0
    var isRunner: Bool = false
//    var lastMarkedLocation = [String: Double]()
//    var lastRunLocation = [String: Double]()
    var currentLocation: CLLocation?
    var locationA: CLLocation?
    
    let locationManager = CLLocationManager()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enableBasicLocationServices()
    }
    
    
    func enableBasicLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            enableMyWhenInUseFeatures()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse:
            enableMyWhenInUseFeatures()
            break
            
        case .notDetermined, .authorizedAlways:
            break
        }
    }
    
    func disableMyLocationBasedFeatures(){
        print("disableMyLocationBasedFeatures")
    }
    
    func enableMyWhenInUseFeatures(){
        print("enableMyWhenInUseFeaatures")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5  // In meters.
        locationManager.startUpdatingLocation()
    }
    
    func openRun() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RunDistance")
        do {
            let result = try managedObjectContext.fetch(request)
            run = result as! [RunDistance]
        } catch {
            print("\(error)")
        }
    }
    
    //call location
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        if isRunner {
            self.totalDistance += (currentLocation?.distance(from: locationA!))!
            locationA = currentLocation
            currentDistance.text = String(format: "%.2f", totalDistance)
        }

//        self.currentLocation["latitude"] = lastLocation.coordinate.latitude
//        self.currentLocation["longitude"] = lastLocation.coordinate.longitude
//        print(currentLocation)
        
        // Do something with the location.
    }
    
    @IBAction func markLocation(_ sender: UIButton) {
        locationA = currentLocation
        isRunner = true
    }
    @IBAction func splitTimeButton(_ sender: Any) {
    }
}
