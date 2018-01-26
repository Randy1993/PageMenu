//
//  BarViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class BarViewController: UIViewController {
    
    private var pageMenu: LZPageMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        
        pageMenu = LZPageMenu.init(frame: CGRect.init(x: 0.0, y: 0.0, width: Demo.screenWidth, height: Demo.screenHeight - Demo.naviBarHeight()))
        for index in 1...2 {
            let vc = InfoViewController()
            vc.infoLabel.text = "Number:\(index)"
            vc.title = "Number:\(index)"
            pageMenu.viewControllers.append(vc)
        }
        pageMenu.showMenuInNavigationBar = true
        pageMenu.menuItemSpace = 10.0
        pageMenu.menuContentInset = UIEdgeInsets.zero
        pageMenu.menuInset = UIEdgeInsets.zero
        pageMenu.menuBackgroundColor = UIColor.clear
        pageMenu.selectedMenuItemLabelColor = UIColor.blue
        pageMenu.unselectedMenuItemLabelColor = UIColor.black
        pageMenu.selectedMenuItemLabelFont = UIFont.boldSystemFont(ofSize: 16)
        pageMenu.unselectedMenuItemLabelFont = UIFont.boldSystemFont(ofSize: 16)
        pageMenu.enableMenuHorizontalBounce = false
        pageMenu.enableMenuScroll = false
        pageMenu.defaultSelectedIndex = 1
        view.addSubview(pageMenu.view)
        
        pageMenu.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
