//
//  TwoTablesViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/25.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class TwoTablesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
     private let indentifire = "Indentifire"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createTableView(tag: 1)
        createTableView(tag: 2)
    }

    func createTableView(tag: Int) {
        let frame = tag == 1 ? CGRect.init(x: 0.0, y: 0, width: view.frame.width/2, height: view.frame.height) : CGRect.init(x: view.frame.width/2, y: 0 , width: view.frame.width/2, height: view.frame.height)
        let tableView = UITableView.init(frame: frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = tag
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
        cell!.textLabel?.text = "\(tableView.tag)-Row:\(indexPath.row)"
        
        return cell!
    }
}
