//
//  OneTableViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/25.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class OneTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let indentifire = "Indentifire"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = UITableView.init(frame: view.bounds)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: indentifire)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: indentifire)
        }
        cell!.textLabel?.text = "Row:\(indexPath.row)"
        
        return cell!
    }
}
