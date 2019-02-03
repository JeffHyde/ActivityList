//
//  Data.swift
//  PlaiTester
//
//  Created by Jeff  Hyde on 11/18/17.
//  Copyright © 2017 Jeff  Hyde. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Strings {
    static let dataUrlString = "http://goo.gl/MdV1uB"
}

struct DefaultKeys {
    static let favoriteActivitiesKey = "FavoriteActivitiesDefaultsKey"
}

class DataHelper {
    static let shared = DataHelper()
    var favoriteActivities = [String]()
    static var mainData = [Event]()
    static var activitySelectionData = [String]()
    
    //TODO: Desired distance from users in meters
    static let maxDistance:Double = 28000000.00
    //
    
    static func setFavorites() {
        if UserDefaults.standard.value(forKey: DefaultKeys.favoriteActivitiesKey) != nil {
            DataHelper.shared.favoriteActivities = UserDefaults.standard.value(forKey: DefaultKeys.favoriteActivitiesKey) as! [String]
        }
    }
    
    static func upDateData() {
        Caller.getEvents(urlString: Strings.dataUrlString) { ( events) in
            mainData = events
            var activitySelectionSet = Set<String>()
            for item in mainData {
                if let activity = item.activity {
                    activitySelectionSet.insert(activity)
                }
            }
            activitySelectionData = ["All"] + Array(activitySelectionSet)
            print("Stripped Selection Array: \(activitySelectionData)")
            let notification = Notification(name: .dataComplete)
            NotificationCenter.default.post(notification)
        }
    }
    
    static func filterByDistance(_ events:[Event]) -> [Event] {
        let filteredEvents = events.filter { event -> Bool in
            if let lat = event.venue?.location?.latitude,
                let long = event.venue?.location?.longitude,
                let userLocation = UserLocation.shared.location {
                let eventLocation = CLLocation(latitude: lat, longitude: long)
                let distance = eventLocation.distance(from: userLocation)
                let convertedDistance = distance * 0.000621371
                if convertedDistance <= maxDistance {
                    return true
                }
            }
            return false
        }
        return filteredEvents
    }
    
    static func filterByActivity(filters: [String]) -> [Event]  {
        let filteredEvents = mainData.filter { event -> Bool in
            if let activity = event.activity  {
                return filters.contains(activity)
            }
            return false
        }
        return filterByDistance(filteredEvents)
    }
    
}

