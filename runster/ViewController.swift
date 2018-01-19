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
    
    @IBOutlet weak var splitTable: UITableView!

    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var currentDistance: UILabel!
    var run = [RunDistance]()
    var totalDistance: Double = 0.0
    var totalsplitDistance: Double = 0.0
    var isRunner: Bool = false
//    var lastMarkedLocation = [String: Double]()
//    var lastRunLocation = [String: Double]()
    var currentLocation: CLLocation?
    var location: CLLocation?
    
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
        locationManager.distanceFilter = 1  // In meters.
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
            self.totalDistance += (currentLocation?.distance(from: location!))!
            currentDistance.text = String(format: "%.2f", totalDistance)
            self.totalsplitDistance += (currentLocation?.distance(from: location!))!
            splitDistance.text = String(format: "%.2f", totalsplitDistance)
        }
        location = currentLocation
    }
    
    @IBAction func markLocation(_ sender: UIButton) {
        if isRunner {
            isRunner = false
            sender.setTitle("Start", for: UIControlState.normal)
        } else {
            totalDistance = 0.0
            totalsplitDistance = 0.0
            location = currentLocation
            isRunner = true
            sender.setTitle("Stop", for: UIControlState.normal)
        }
    }
    @IBAction func splitTimeButton(_ sender: Any) {
        totalsplitDistance = 0.0
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
    }
}
