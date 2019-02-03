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
        DataHelper.setFavorites()
    }
    
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return DataHelper.activitySelectionData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCellID",
                                                 for: indexPath) as! FilterTableViewCell
        let data = DataHelper.activitySelectionData[indexPath.row]
        cell.configure(data: data,
                       index: indexPath.row)
        cell.starButton.addTarget(self,
                                  action:#selector(cellStarPressed(sender:)),
                                  for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let data = DataHelper.activitySelectionData[indexPath.row]
        let mainViewController = self.parent as! MainViewController
        if indexPath.row == 0 {
            mainViewController.data = DataHelper.filterByDistance(DataHelper.mainData)
        } else {
            mainViewController.data = DataHelper.filterByActivity(filters: [data])
        }
        mainViewController.tableView.reloadData()
        mainViewController.filterButton.sendActions(for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    @objc func cellStarPressed(sender:UIButton) {
        let indexPath = IndexPath(row: sender.tag,
                                  section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        let activity = cell.activityTitleLabel.text
        if sender.isSelected {
            sender.setImage(#imageLiteral(resourceName: "StarOff"),
                            for: .disabled)
            DataHelper.shared.favoriteActivities = DataHelper.shared.favoriteActivities.filter {
                $0 != activity
            }
            UserDefaults.standard.set(DataHelper.shared.favoriteActivities,
                                      forKey: DefaultKeys.favoriteActivitiesKey)
        } else {
            sender.setImage(#imageLiteral(resourceName: "StarOn"),
                            for: .selected)
            DataHelper.shared.favoriteActivities.append(DataHelper.activitySelectionData[sender.tag])
            UserDefaults.standard.set(DataHelper.shared.favoriteActivities,
                                      forKey: DefaultKeys.favoriteActivitiesKey)
        }
        sender.isSelected = !sender.isSelected
    }
    
}
