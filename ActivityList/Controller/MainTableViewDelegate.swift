//
//  MainTableViewDelegate.swift
//  PlaiTester
//
//  Created by Jeff  Hyde on 11/18/17.
//  Copyright © 2017 Jeff  Hyde. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class MainTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainViewController: MainViewController!
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return mainViewController.data.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCellID",
                                                 for: indexPath) as! MainTableViewCell
        let data = mainViewController.data[indexPath.row]
        cell.eventNameLabel.text = data.name
        cell.configure(data: data,
                       completion: {
                        tableView.layoutIfNeeded()
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        mainViewController.performSegue(withIdentifier: "DetailViewSegueID",
                                        sender: indexPath)
    }
    
}
