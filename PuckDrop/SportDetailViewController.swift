//
//  SportDetailViewController.swift
//  PuckDrop
//
//  Created by Pace Williams on 4/25/22.
//

import UIKit

class SportDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UITextField!
    
    @IBOutlet weak var sportImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addEventButtonPressed(_ sender: UIBarButtonItem) {
    }
    

}
