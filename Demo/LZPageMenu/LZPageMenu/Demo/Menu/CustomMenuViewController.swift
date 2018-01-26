//
//  CustomMenuViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class CustomMenuViewController: UIViewController {

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
        pageMenu.customDelegate = CustomViewDelegate()
        pageMenu.defaultSelectedIndex = 1
        pageMenu.menuHeight = 80
        pageMenu.menuBackgroundColor = UIColor.white
        pageMenu.selectionIndicatorOffset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        pageMenu.menuBottomLineColor = UIColor.lightGray
        pageMenu.menuBottomLineHeight = 1.0
        pageMenu.verticalSeparatorWidth = 1.0
        pageMenu.verticalSeparatorColor = UIColor.lightGray
        pageMenu.verticalSeparatorHeight = 50.0
        pageMenu.hideLastVerticalSeparator = true
        pageMenu.reloadData()
        view.addSubview(pageMenu.view)
    }
}
