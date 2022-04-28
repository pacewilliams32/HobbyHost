//
//  EventDetailViewController.swift
//  PuckDrop
//
//  Created by Pace Williams on 4/26/22.
//

import UIKit
import GooglePlaces

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class EventDetailViewController: UIViewController {
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UIDatePicker!
    
    
    
    var event: Event!
    var sportName: String!
    var eventTitle: String!
    var locationName: String!
    var address: String!
    var descriptionText: String!
    var date: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.minimumDate = Date()
        
        if event == nil {
            event = Event()
            
        }
        
        updateUserInterface()
    }
    

    
    func updateUserInterface() {
        eventTextField.text = eventTitle  //event.eventTitle
        venueLabel.text = locationName//event.locationName
        addressLabel.text = address //event.address
        descriptionTextView.text = descriptionText //event.description
        
        
        
    }
    
    func updateFromInterface() {
        event.eventTitle = eventTextField.text!
        event.locationName = venueLabel.text!
        event.address = addressLabel.text!
        event.descriptionText = descriptionTextView.text!
        event.date = date
        

        
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        updateFromInterface()
        event.saveData(name: sportName) { (success) in
            if success {

                self.leaveViewController()
            } else {
                self.oneButtonAlert(title: "Save Failed", message: "For some reason, the data would not save to the cloud.")
            }
        }

    }
    
    @IBAction func addLocationButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        date = dateFormatter.string(from: sender.date)
       
    }
}

extension EventDetailViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        locationName = place.name ?? "Unknown Address"
        address = place.formattedAddress ?? "Unknown Address"
        
        updateUserInterface()
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
