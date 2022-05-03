//
//  Event.swift
//  PuckDrop
//
//  Created by Pace Williams on 4/26/22.
//

import Foundation
import Firebase
import MapKit

class Event: NSObject, MKAnnotation {
    var eventTitle: String
    var locationName: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var descriptionText: String
    var date: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["eventTitle": eventTitle, "locationName": locationName, "address": address, "latitude": latitude, "longitude": longitude, "descriptionText": descriptionText, "date": date, "postingUserID": postingUserID]
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    
    var title: String? {
        return locationName
    }
    
    var subtitle: String? {
        return address
    }
    
    
    init(eventTitle: String, locationName: String, address: String, coordinate: CLLocationCoordinate2D, descriptionText: String, date: String, postingUserID: String, documentID: String) {

        self.eventTitle = eventTitle
        self.locationName = locationName
        self.address = address
        self.coordinate = coordinate
        self.descriptionText = descriptionText
        self.date = date
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    override convenience init() {
        let postingUserID = Auth.auth().currentUser?.uid ?? ""
        self.init(eventTitle: "", locationName: "", address: "", coordinate: CLLocationCoordinate2D(), descriptionText: "", date: "", postingUserID: postingUserID, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let eventTitle = dictionary["eventTitle"] as! String? ?? ""
        let locationName = dictionary["locationName"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let descriptionText = dictionary["descriptionText"] as! String? ?? ""
        let date = dictionary["date"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        
        self.init(eventTitle: eventTitle, locationName: locationName, address: address, coordinate: coordinate, descriptionText: descriptionText, date: date, postingUserID: postingUserID, documentID: "")

    }
    
    func saveData(name: String, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        
        // Grab the User ID
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("ERROR: Could not save data because we don't have a valid postingUserID.")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if WE have saved a record, we'll have an ID, otherwise .addDocument will create one
        if self.documentID == "" { // create a new via .addDocument
            var ref: DocumentReference? = nil // Firestone will create a new one
            ref = db.collection("sports").document(name).collection("events").addDocument(data: dataToSave) { (error) in
                
                guard error == nil else {
                    print("ERROR: adding document \(error!.localizedDescription)")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)")
                completion(true)
            }
            
        } else { // save to existing document
            let ref = db.collection("sports").document(name).collection("events").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    print("ERROR: updating document \(error!.localizedDescription)")
                    return completion(false)
                }
                print("Updated document: \(self.documentID)")
                completion(true)
            }
            
        }
    }
}
