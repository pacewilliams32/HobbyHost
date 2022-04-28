//
//  Events.swift
//  PuckDrop
//
//  Created by Pace Williams on 4/27/22.
//

import Foundation
import Firebase

class Events {
    var eventArray: [Event] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(name: String, completed: @escaping () -> ()) {
        db.collection("sports").document(name).collection("events").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.eventArray = [] // cleans out existing array
            
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer  in the singular class
                let event = Event(dictionary: document.data())
                event.documentID = document.documentID
                self.eventArray.append(event)
            }
            completed()
        }
    }
}
