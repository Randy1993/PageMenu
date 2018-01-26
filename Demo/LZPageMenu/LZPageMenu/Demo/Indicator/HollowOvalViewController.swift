//
//  HollowOvalViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class HollowOvalViewController: UIViewController {

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
        pageMenu.selectionIndicatorType = .hollowOval
        pageMenu.selectionIndicatorColor = UIColor.red
        pageMenu.selectedMenuItemLabelColor = UIColor.black
        pageMenu.unselectedMenuItemLabelColor = UIColor.white
        pageMenu.selectionIndicatorHeight = pageMenu.menuHeight
        pageMenu.selectionIndicatorOffset = UIEdgeInsetsMake(0.0, -8.0, 0.0, -8.0)
        pageMenu.reloadData()
        view.addSubview(pageMenu.view)
    }


}
