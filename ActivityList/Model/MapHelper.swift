//
//  MapHelper.swift
//  ActivityList
//
//  Created by Jeff  Hyde on 6/13/18.
//  Copyright © 2018 Jeff Hyde. All rights reserved.
//

import Foundation
import MapKit

class MapHelper {
    class func setUpMap(mapView: MKMapView,
                         latitude: Double,
                         longitude: Double,
                         cameraDistance: CLLocationDistance,
                         cameraPitch: CGFloat) {
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isUserInteractionEnabled = true
        mapView.layoutMargins = UIEdgeInsets.init(top: 0,
                                                  left: 0,
                                                  bottom: 0,
                                                  right: 0)
        mapView.tintColor = UIColor(red: 100/255,
                                    green: 66/255,
                                    blue: 162/255,
                                    alpha: 1.0)
        let pinLocation = CLLocationCoordinate2D(latitude: latitude,
                                                 longitude: longitude)
        let location = CLLocation(latitude: latitude,
                                  longitude: longitude)
        mapView.camera = MKMapCamera(lookingAtCenter: pinLocation,
                                     fromDistance: cameraDistance,
                                     pitch: 0,
                                     heading: 0)
        guard let userLocation = UserLocation.shared.location else {return}
        let heading = getBearingBetweenTwoPoints(point1: location,
                                                 point2:userLocation)
        let rotationCamera = MKMapCamera(lookingAtCenter: pinLocation,
                                         fromDistance: cameraDistance,
                                         pitch: cameraPitch,
                                         heading: heading)
        UIView.animate(withDuration: 6,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        mapView.camera = rotationCamera
        }) { (complete) in
            print("Camera completed rotation = \(complete)")
        }
    }
    
    class func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    class func radiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / .pi
    }
    
    class func getBearingBetweenTwoPoints(point1 : CLLocation,
                                           point2 : CLLocation) -> Double {
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        return radiansToDegrees(radians: radiansBearing)
    }
    
    class func getDistanceFromUser(lat: Double,
                                    long: Double) -> String {
        if let userLat = UserLocation.shared.location?.coordinate.latitude,
            let userLong = UserLocation.shared.location?.coordinate.longitude {
            let eventCoord = CLLocation(latitude: lat, longitude: long)
            let userCoord = CLLocation(latitude: userLat, longitude:userLong)
            let distanceFromEvent = eventCoord.distance(from:userCoord)
            let convertedDistance = distanceFromEvent * 0.000621371
            let convertedDecimalValue = String(format: "%.1f", convertedDistance)
            return "\(convertedDecimalValue) mi. away"
        } else {
            return ""
        }
    }
    
}
