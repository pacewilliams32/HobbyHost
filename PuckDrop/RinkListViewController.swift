//
//  RinkListViewController.swift
//  PuckDrop
//
//  Created by Pace Williams on 4/25/22.
//

import UIKit

class RinkListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var rinks = ["Aliso Viejo Ice Palace", "Lake Forest Ice Palace", "Disney Ice"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    

}

extension RinkListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RinkTableViewCell
        cell.nameLabel?.text = rinks[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
