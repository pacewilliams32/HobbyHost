//
//  SportDetailViewController.swift
//  PuckDrop
//
//  Created by Pace Williams on 4/25/22.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class SportDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UITextField!
    
    @IBOutlet weak var sportImage: UIImageView!
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    var events: Events!
    var sportName: String!
//    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getLocation()
        nameLabel.text = sportName
        sportImage.image = UIImage(named: sportName)
        events = Events()
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        configureSegmentedControl()
        
        
        
    }
    
    func configureSegmentedControl() {
        // set font colors for segmented control
        let blueFontColor = [NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryColor") ?? UIColor.blue]
        let blackFontColor = [NSAttributedString.Key.foregroundColor: UIColor.black]
        sortSegmentedControl.setTitleTextAttributes(blueFontColor, for: .selected)
        sortSegmentedControl.setTitleTextAttributes(blackFontColor, for: .normal)

        // add white border to segmented control
        sortSegmentedControl.layer.borderColor = UIColor.black.cgColor
        sortSegmentedControl.layer.borderWidth = 1.0
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEvent" {
            let sportEventName = sportName
            let destination = segue.destination as! UINavigationController
            let eventDetailViewController = destination.topViewController as! EventDetailViewController
            eventDetailViewController.sportName = sportEventName
        } else if segue.identifier == "ShowEvent" {
            let destination = segue.destination as! EventDetailViewController
            let selectedIndexPath = eventTableView.indexPathForSelectedRow!
            destination.eventTitle = events.eventArray[selectedIndexPath.row].eventTitle
            destination.locationName = events.eventArray[selectedIndexPath.row].locationName
            destination.address = events.eventArray[selectedIndexPath.row].address
            destination.descriptionText = events.eventArray[selectedIndexPath.row].descriptionText
            
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        events.loadData(name: sportName) {
            self.eventTableView.reloadData()
        }
    }
   
}

extension SportDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        cell.eventTitleLabel?.text = events.eventArray[indexPath.row].eventTitle
        cell.eventDistanceLabel?.text = events.eventArray[indexPath.row].locationName
        cell.eventDateLabel?.text = events.eventArray[indexPath.row].date
        return cell
        
    }
    
    
}

//extension SportDetailViewController: CLLocationManagerDelegate {
//
//    func getLocation() {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("Checking authenticaiton status")
//        handleAuthenticalStatus(status: status)
//    }
//
//    func handleAuthenticalStatus(status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted:
//            self.oneButtonAlert(title: "Location services denied", message: "Parental controls may be restricting location use in this app.")
//        case .denied:
//            // TODO: Handle alert w/ ability to change
//            break
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.requestLocation()
//        @unknown default:
//            print("DEVELOPER ALERT: Unknown case of status in handleAutheticalStatus\(status)")
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let currentLocation = locations.last ?? CLLocation()
//        print("Current location is \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
//            var locationName = ""
//            if placemarks != nil {
//                // get first placemark
//                let placemark = placemarks?.last
//                //assign placemark
//                locationName = placemark?.name ?? "Parts Unknown"
//            } else {
//                print("ERROR: Retrieving place")
//                locationName = "Could not find location"
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        <#code#>
//    }
//}
