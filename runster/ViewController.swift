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

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var splitTable: UITableView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var currentDistance: UILabel!
    
    //Stopwatch Value
    var isRunner: Bool = false
    
    //Distance
    var totalDistance: Double = 0.0
    var splitDistance: Double = 0.0

    //Timer
    var timer: Timer?
    var time: Int = 0
    var splitTime: Int = 0
    
    //Split Values
    var splitTimes = [Int]()
    var splitDist = [Double]()
    
    //Locations
    var currentLocation: CLLocation?
    var location: CLLocation?
    let locationManager = CLLocationManager()
    
    //init
    override func viewDidLoad() {
        super.viewDidLoad()
        splitTable.dataSource = self
        splitTable.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        enableBasicLocationServices()
        loadViewData()
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
    
    //Update Location
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        if isRunner {
            self.totalDistance += (currentLocation?.distance(from: location!))!
            self.splitDistance += (currentLocation?.distance(from: location!))!
        }
        location = currentLocation
    }
    
    //Start Button
    @IBAction func markLocation(_ sender: UIButton) {
        if isRunner {
            isRunner = false
            sender.setTitle("Start", for: UIControlState.normal)
            timer?.invalidate()
        } else {
            location = currentLocation
            isRunner = true
            sender.setTitle("Stop", for: UIControlState.normal)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
                self.time += 1
                self.splitTime += 1
                self.loadViewData()
            })
        }
    }
    
    //Split Button
    @IBAction func splitTimeButton(_ sender: Any) {
        splitDist.insert(splitDistance, at: 0)
        splitTimes.insert(splitTime, at: 0)
        splitDistance = 0.0
        splitTime = 0
        loadViewData()
        loadTable()
    }
    
    //Reset Button
    @IBAction func resetButton(_ sender: UIButton) {
        if isRunner {
            isRunner = false
            sender.setTitle("Start", for: UIControlState.normal)
            timer?.invalidate()
        }
        totalDistance = 0.0
        time = 0
        splitDist = []
        splitTimes = []
        loadTable()
        loadViewData()
    }
    
    //Load View
    func loadViewData() {
        currentTime.text = String(self.time)
        currentDistance.text = String(self.totalDistance)
    }
    
    func loadTable() {
        splitTable.reloadData()
    }
    
    //Table Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splitDist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.text = String(splitTimes[indexPath.row])
        cell.detailTextLabel?.text = String(splitDist[indexPath.row])
        return cell
    }}
