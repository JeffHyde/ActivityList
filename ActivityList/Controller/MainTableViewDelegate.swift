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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewController.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCellID", for: indexPath) as! TableViewCell
        let data = mainViewController.data[indexPath.row]
        cell.eventNameLabel.text = data.name
        if let venueName = data.venue?.name, let venueAddress = data.venue?.address {
        cell.venueNameLabel.text = venueName
        cell.addressLabel.text = venueAddress
        }
        cell.timeLabel.text = data.time
        cell.summaryLabel.text = data.summary
        cell.membershipLabel.text = data.membership_link
        if let eventLat = data.venue?.location?.latitude,
            let eventLong = data.venue?.location?.longitude,
            let userLat = UserLocation.shared.location?.coordinate.latitude,
            let userLong = UserLocation.shared.location?.coordinate.longitude {
            let eventCoord = CLLocation(latitude: eventLat, longitude: eventLong)
            let userCoord = CLLocation(latitude: userLat, longitude:userLong)
            let distanceFromEvent = eventCoord.distance(from:userCoord)
            let convertedDistance = distanceFromEvent * 0.000621371
            let convertedDecimalValue = String(format: "%.1f", convertedDistance) // "3.14"
            cell.distanceLabel.text = ("\(convertedDecimalValue) mi. away")
        } else {
            cell.distanceLabel.text = ""

        }
        data.getImage { _ in
            DispatchQueue.main.async {
                if let currentCell = tableView.cellForRow(at: indexPath) as? TableViewCell {
                    currentCell.eventImageView.image = data.image
                    tableView.layoutIfNeeded()
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainViewController.performSegue(withIdentifier: "DetailViewSegueID", sender: indexPath)
       
    }

}
