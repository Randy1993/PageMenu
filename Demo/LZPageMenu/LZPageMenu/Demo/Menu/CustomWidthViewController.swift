//
//  CustomWidthViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class CustomWidthViewController: UIViewController {

    private var pageMenu: LZPageMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        
        pageMenu = LZPageMenu.init(frame: CGRect.init(x: 0.0, y: 0.0, width: Demo.screenWidth, height: Demo.screenHeight - Demo.naviBarHeight()))
        pageMenu.menuItemUnselectedWidths = [Float]()
        pageMenu.menuItemSelectedWidths = [Float]()
        for index in 1...10 {
            let vc = InfoViewController()
            vc.infoLabel.text = "Number:\(index)"
            vc.title = "Number:\(index)"
            pageMenu.viewControllers.append(vc)
            
            pageMenu.menuItemUnselectedWidths!.append(Float(index*20 + 65))
            pageMenu.menuItemSelectedWidths!.append(Float(index*20 + 65))
        }
        pageMenu.menuItemWidthBasedOnTitleTextWidth = false
        pageMenu.selectionIndicatorWithEqualToTextWidth = false
        pageMenu.reloadData()
        view.addSubview(pageMenu.view)
    }
}
