//
//  DetailViewController.swift
//  PlaiTester
//
//  Created by Jeff  Hyde on 11/15/17.
//  Copyright © 2017 Jeff  Hyde. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var navigateButton: UIButton!
    
    var data:Event?
    var latitude:Double?
    var longitude:Double?
    let cameraDistance: CLLocationDistance = 2000
    let cameraPitch :CGFloat = 75
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapGetPlaceMark()
    }
    
    func setUpMapGetPlaceMark() {
        latitude = data?.venue?.location?.latitude
        longitude = data?.venue?.location?.longitude
        if let lat = latitude,
            let long = longitude {
            MapHelper.setUpMap(mapView: self.mapView,
                               latitude: lat,
                               longitude: long,
                               cameraDistance: self.cameraDistance,
                               cameraPitch: self.cameraPitch)
            nameLabel.text = data?.name
            timeLabel.text = data?.time
            descriptionLabel.text = data?.description
            distanceLabel.text = MapHelper.getDistanceFromUser(lat: lat,
                                                               long: long)
            let coord = CLLocationCoordinate2D.init(latitude: lat,
                                                    longitude: long)
            let anno = Annotation(title: data?.name,
                                  subtitle: data?.venue?.address,
                                  address: data?.venue?.address,
                                  name: data?.name,
                                  coordinate: coord)
            self.mapView.addAnnotation(anno)
        }
    }
    
    @IBAction func navigatePressed(_ sender: UIButton) {
        if let lat = latitude, let long = longitude {
            Alert.showAlertActionSheetForNavigation(coordinate: CLLocationCoordinate2DMake(lat,
                                                                                           long),
                                                    address: data?.venue?.address, title: "",
                                                    description: "Warning: You will leave this app and we will show you directions using Apple's Maps app.",
                                                    cancelButtonTitle: "Cancel",
                                                    navigateTitle: "Route me!",
                                                    viewController: self)
        }
    }
}
