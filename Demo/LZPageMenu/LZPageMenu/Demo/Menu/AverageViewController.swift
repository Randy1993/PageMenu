//
//  AverageViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class AverageViewController: UIViewController {

    private var pageMenu: LZPageMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        
        pageMenu = LZPageMenu.init(frame: CGRect.init(x: 0.0, y: 0.0, width: Demo.screenWidth, height: Demo.screenHeight - Demo.naviBarHeight()))
        for index in 1...3 {
            let vc = InfoViewController()
            vc.infoLabel.text = "Number:\(index)"
            vc.title = "Number:\(index)"
            pageMenu.viewControllers.append(vc)
        }
        pageMenu.averageMenuWitdh = true
        pageMenu.menuItemWidthBasedOnTitleTextWidth = false
        pageMenu.enableMenuScroll = false
        pageMenu.enableMenuHorizontalBounce = false
        pageMenu.reloadData()
        view.addSubview(pageMenu.view)
    }
}
