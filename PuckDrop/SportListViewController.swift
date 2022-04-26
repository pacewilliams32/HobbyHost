//
//  SportListViewController.swift
//  PuckDrop
//
//  Created by Pace Williams on 4/25/22.
//

import UIKit

class SportListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sports = ["Hockey", "Football", "Wiffleball", "Softball", "Baseball", "Soccer", "Basketball", "Golf", "Bowling", "Tennis"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

}

extension SportListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SportTableViewCell
        cell.nameLabel?.text = sports[indexPath.row]
        cell.iconImage.image = UIImage(named: sports[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}
