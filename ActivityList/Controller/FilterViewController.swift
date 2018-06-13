//
//  FilterViewController.swift
//  PlaiTest1
//
//  Created by Jeff  Hyde on 12/6/17.
//  Copyright © 2017 Jeff  Hyde. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        if Defaults.userDefaults.value(forKey: Defaults.favoriteActivitiesKey) != nil {
            DataHelper.shared.favoriteActivities = Defaults.userDefaults.value(forKey: Defaults.favoriteActivitiesKey) as! [String]
        }
    }
    
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
  
    @objc func cellStarPressed(sender:UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        let activity = cell.activityTitleLabel.text
        if sender.isSelected {
            sender.setImage(#imageLiteral(resourceName: "StarOff"), for: .disabled)
            DataHelper.shared.favoriteActivities = DataHelper.shared.favoriteActivities.filter{$0 != activity}
            Defaults.userDefaults.set(DataHelper.shared.favoriteActivities, forKey: Defaults.favoriteActivitiesKey)
        } else {
            sender.setImage(#imageLiteral(resourceName: "StarOn"), for: .selected)
            DataHelper.shared.favoriteActivities.append(DataHelper.activitySelectionData[sender.tag])
            Defaults.userDefaults.set(DataHelper.shared.favoriteActivities, forKey: Defaults.favoriteActivitiesKey)
        }
        sender.isSelected = !sender.isSelected
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHelper.activitySelectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCellID", for: indexPath) as! FilterTableViewCell
        let data = DataHelper.activitySelectionData[indexPath.row]
        cell.activityTitleLabel.text = data
        if indexPath.row == 0  { cell.starButton.isHidden = true }
        cell.starButton.tag = indexPath.row
        cell.starButton.addTarget(self, action:#selector(cellStarPressed(sender:)), for: .touchUpInside)
        if DataHelper.shared.favoriteActivities.contains(cell.activityTitleLabel.text!) {
            cell.starButton.isSelected = true
            cell.starButton.setImage(#imageLiteral(resourceName: "StarOn"), for: .selected)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = DataHelper.activitySelectionData[indexPath.row]
        let mainViewController = self.parent as! MainViewController
        if indexPath.row == 0 {
             mainViewController.data = DataHelper.filterByDistance(DataHelper.mainData)
                 print("Main Data: \(String(describing: mainViewController.data))")
        } else {
            mainViewController.data = DataHelper.filterByActivity(filters: [data])
                print("Main Data Changed To: \(String(describing: mainViewController.data.count))")
        }
        mainViewController.tableView.reloadData()
        mainViewController.filterButton.sendActions(for: .touchUpInside)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
