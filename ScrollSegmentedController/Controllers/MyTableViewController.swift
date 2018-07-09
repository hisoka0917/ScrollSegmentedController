//
//  MyTableViewController.swift
//  ScrollSegmentedController
//
//  Created by Wang Kai on 2018/7/9.
//  Copyright © 2018年 github. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {

    private var titleNumber: Int = 0


    init(style: UITableViewStyle, number: Int) {
        self.titleNumber = number
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        self.titleNumber = 1
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellReuseIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseIdentifier", for: indexPath)

        cell.textLabel?.text = String(indexPath.row)
        cell.detailTextLabel?.text = String(self.titleNumber)

        return cell
    }

}
