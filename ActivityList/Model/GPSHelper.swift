//
//  GPSHelper.swift
//  TireRotation
//
//  Created by Jeff  Hyde on 11/28/17.
//  Copyright © 2017 Jeff  Hyde. All rights reserved.
//

import Foundation
import CoreLocation

class GPSHelper:NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    static var userLocationState = UserLocationState.notDetermined
    
    override func awakeFromNib() {
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        UserLocation.shared.location = location
        if UserLocation.shared.location != nil {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.authorizedWhenInUse:
            GPSHelper.userLocationState = .accepted
            getStateStatus()
        case CLAuthorizationStatus.denied:
            GPSHelper.userLocationState = .denied
            getStateStatus()
        case CLAuthorizationStatus.notDetermined:
            GPSHelper.userLocationState = .notDetermined
            getStateStatus()
        default:
            break
        }
    }
    
    func getStateStatus() {
        let notification = Notification(name: .noLocation)
        NotificationCenter.default.post(notification)
        if GPSHelper.userLocationState == .denied ||
            GPSHelper.userLocationState == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if GPSHelper.userLocationState == .accepted {
            DataHelper.upDateData()
        }
    }
    
}

enum UserLocationState {
    case accepted
    case denied
    case notDetermined
    
}

class UserLocation {
    public static let shared = UserLocation()
    var location:CLLocation?
    
}

