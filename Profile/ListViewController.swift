//
//  ListViewController.swift
//  Profile
//
//  Created by Tanakorn Phoochaliaw on 13/8/2564 BE.
//

import UIKit
import XLPagerTabStrip

class ListViewController: UITableViewController {

    var pageIndex: Int = 0
    var pageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = "Row \(indexPath.row)"

        return cell
    }

}

extension ListViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}
