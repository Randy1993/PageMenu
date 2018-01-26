//
//  ReloadTitlesViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class ReloadTitlesViewController: UIViewController {

    private var pageMenu: LZPageMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
    
        pageMenu = LZPageMenu.init(frame: CGRect.init(x: 0.0, y: 0.0, width: Demo.screenWidth, height: Demo.screenHeight - Demo.naviBarHeight()))
        for index in 1...10 {
            let vc = InfoViewController()
            vc.infoLabel.text = "Number:\(index)"
            vc.title = "Number:\(index)"
            pageMenu.viewControllers.append(vc)
        }
        pageMenu.reloadData()
        view.addSubview(pageMenu.view)
        
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 200, width: 120, height: 40))
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Update Titles", for: .normal)
        button.addTarget(self, action: #selector(buttonAction(button:)), for:.touchUpInside)
        view.addSubview(button)
    }
    
    @objc func buttonAction(button: UIButton) {
        button.tag += 1
        for (index, value) in pageMenu.viewControllers.enumerated() {
            let infoVC = value as! InfoViewController
            infoVC.title = "NewNumber:\((index + 1) * button.tag)"
            infoVC.infoLabel.text = "NewNumber:\((index + 1) * button.tag)"
        }
        
        pageMenu.updateTitles()
    }

}
