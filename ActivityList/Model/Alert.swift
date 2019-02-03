//
//  Alert.swift
//  ActivityList
//
//  Created by Jeff  Hyde on 12/19/17.
//  Copyright © 2017 Jeff Hyde. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Alert {
    static func showAlertActionSheetForNavigation(coordinate:CLLocationCoordinate2D,
                                                  address: String?,
                                                  title: String,
                                                  description: String,
                                                  cancelButtonTitle: String,
                                                  navigateTitle: String,
                                                  viewController: UIViewController ) {
        let alertController = UIAlertController(title: title,
                                                message: description,
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: cancelButtonTitle,
                                         style: .cancel,
                                         handler: {(alert: UIAlertAction!) in
                                            // do nothing
        })
        let navigateAction = UIAlertAction(title: navigateTitle,
                                           style: .default,
                                           handler: { (alert: UIAlertAction!) in
                                            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate,
                                                                                           addressDictionary:nil))
                                            if let address = address {
                                                mapItem.name = "\(address)"
                                                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                                            }
        })
        navigateAction.setValue(UIColor.red,
                                forKeyPath: "titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(navigateAction)
        viewController.present(alertController,
                               animated: true,
                               completion: nil)
    }
}
