//
//  Annotation.swift
//  PlaiTest1
//
//  Created by Jeff  Hyde on 12/8/17.
//  Copyright © 2017 Jeff  Hyde. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var name: String?
    var address: String?
    var imageURL: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?,
         subtitle: String?,
         address: String?,
         name: String?,
         coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.name = name
        self.address = address
        self.coordinate = coordinate
        super.init()
    }
    
}
