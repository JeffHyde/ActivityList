//
//  MainTableViewCell.swift
//  ActivityList
//
//  Created by Jeff  Hyde on 6/13/18.
//  Copyright © 2018 Jeff  Hyde. All rights reserved.
//

import UIKit
import CoreLocation

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var membershipLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    func configure(data: Event, completion: @escaping () -> ()) {
        eventNameLabel.text = data.name
        if let venueName = data.venue?.name,
            let venueAddress = data.venue?.address {
            venueNameLabel.text = venueName
            addressLabel.text = venueAddress
        }
        timeLabel.text = data.time
        summaryLabel.text = data.summary
        membershipLabel.text = data.membership_link
        if let eventLat = data.venue?.location?.latitude,
            let eventLong = data.venue?.location?.longitude,
            let userLat = UserLocation.shared.location?.coordinate.latitude,
            let userLong = UserLocation.shared.location?.coordinate.longitude {
            let eventCoord = CLLocation(latitude: eventLat,
                                        longitude: eventLong)
            let userCoord = CLLocation(latitude: userLat,
                                       longitude:userLong)
            let distanceFromEvent = eventCoord.distance(from:userCoord)
            let convertedDistance = distanceFromEvent * 0.000621371
            let convertedDecimalValue = String(format: "%.1f",
                                               convertedDistance) // "3.14"
            distanceLabel.text = ("\(convertedDecimalValue) mi. away")
        } else {
            distanceLabel.text = ""
        }
        data.getImage { (image) in
            DispatchQueue.main.async {
                self.eventImageView.image  = data.image
                completion()
            }
            
        }
    }
    
}
