//
//  Event.swift
//  PuckDrop
//
//  Created by Pace Williams on 4/26/22.
//

import Foundation
import Firebase

class Event  {
    var eventTitle: String
    var locationName: String
    var address: String
    var descriptionText: String
    var date: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["eventTitle": eventTitle, "locationName": locationName, "address": address, "descriptionText": descriptionText, "date": date, "postingUserID": postingUserID]
    }
    
    
    
    init(eventTitle: String, locationName: String, address: String, descriptionText: String, date: String, postingUserID: String, documentID: String) {

        self.eventTitle = eventTitle
        self.locationName = locationName
        self.address = address
        self.descriptionText = descriptionText
        self.date = date
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        let postingUserID = Auth.auth().currentUser?.uid ?? ""
        self.init(eventTitle: "", locationName: "", address: "", descriptionText: "", date: "", postingUserID: postingUserID, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let eventTitle = dictionary["eventTitle"] as! String? ?? ""
        let locationName = dictionary["locationName"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let descriptionText = dictionary["descriptionText"] as! String? ?? ""
        let date = dictionary["date"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        
        self.init(eventTitle: eventTitle, locationName: locationName, address: address, descriptionText: descriptionText, date: date, postingUserID: postingUserID, documentID: "")

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
