//
//  MainViewController.swift
//  PlaiTester
//
//  Created by Jeff  Hyde on 11/15/17.
//  Copyright © 2017 Jeff  Hyde. All rights reserved.
//


// when I select multiple filters and select All, it should turn “Filter to Favorites” on by default I think. And vice verse (if I deselect all should turn it off).


import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerViewAnimationConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var noLocationView: UIView!
    @IBOutlet var gpsHelper: GPSHelper!
    
    var filterViewController:FilterViewController?
    var data = [Event]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.reloadTableView),
                                               name: .dataComplete,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.addLocationView),
                                               name: .noLocation,
                                               object: nil)
        gpsHelper.requestLocation()
        gpsHelper.startUpdatingLocation()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.getStatusForLocationAuth),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        setUpUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        containerViewAnimationConstraint.constant = self.view.frame.size.height * 2
        self.view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        switch segue.identifier {
        case "DetailViewSegueID"?:
            let detaiViewController = segue.destination as! DetailViewController
            if let indexPath = sender as? IndexPath {
                detaiViewController.data = data[indexPath.row]
                print("Navigating to detail view")
            }
            
        case "ActivityContainerViewSegueID"?:
            filterViewController = segue.destination as? FilterViewController
        default:
            break
        }
    }
    
    func animateFilterView() {
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.view.layoutIfNeeded()
        }) { (complete) in
        }
    }
    
    func setUpUI() {
        if DataHelper.shared.favoriteActivities.isEmpty {
            starButton.isHidden = true
        }
    }
    
    @objc func getStatusForLocationAuth() {
        gpsHelper.getStateStatus()
    }
    
    @objc func addLocationView() {
        if GPSHelper.userLocationState == .denied {
            DispatchQueue.main.async {
                self.noLocationView.isHidden = false
                self.tableView.isHidden = true
            }
        }else if GPSHelper.userLocationState == .notDetermined {
            DispatchQueue.main.async {
                self.noLocationView.isHidden = true
                self.tableView.isHidden = true
            }
        } else if GPSHelper.userLocationState == .accepted {
            DispatchQueue.main.async {
                self.noLocationView.isHidden = true
                self.tableView.isHidden = false
            }
        }
        
    }
    
    @objc func reloadTableView() {
        DispatchQueue.main.async {
            self.data = DataHelper.filterByDistance(DataHelper.mainData)
            self.tableView.reloadData()
            self.filterViewController?.tableView.reloadData()
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        if sender.isSelected {
            if DataHelper.shared.favoriteActivities.isEmpty {
                starButton.isHidden = true
            } else {
                starButton.isHidden = false
            }
            containerViewAnimationConstraint.constant = self.view.frame.size.height * 2
        } else {
            starButton.isHidden = true
            containerViewAnimationConstraint.constant = 0
        }
        sender.isSelected = !sender.isSelected
        animateFilterView()
        tableView.reloadData()
    }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        if sender.isSelected {
            filterButton.isHidden = false
            starButton.setImage(#imageLiteral(resourceName: "StarOff"), for: .disabled)
            data = DataHelper.filterByDistance(DataHelper.mainData)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            filterButton.isHidden = true
            starButton.setImage(#imageLiteral(resourceName: "StarOn"), for: .selected)
            data = DataHelper.filterByActivity(filters: DataHelper.shared.favoriteActivities)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)
        if let url = settingsUrl {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
