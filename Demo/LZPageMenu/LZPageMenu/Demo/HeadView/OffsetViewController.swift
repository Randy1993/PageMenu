//
//  OffsetViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/25.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class OffsetViewController: UIViewController {

    private var pageMenu: LZPageMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        
        let headView = Bundle.main.loadNibNamed("CustomHeadView", owner: nil, options: nil)?.first as! CustomHeadView
        headView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 200)
        headView.layer.borderColor = UIColor.red.cgColor
        headView.layer.borderWidth = 1
        
        pageMenu = LZPageMenu.init(frame: CGRect.init(x: 0.0, y: 0.0, width: Demo.screenWidth, height: Demo.screenHeight - Demo.naviBarHeight()))
        for index in 1...10 {
            let vc = OneTableViewController()
            vc.title = "Number:\(index)"
            pageMenu.viewControllers.append(vc)
        }
        pageMenu.headView = headView
        pageMenu.headViewHeight = 200
//        pageMenu.headViewTopSafeDistance = 64
        pageMenu.headViewMaxmumOffsetRate = 0.5
        pageMenu.stretchHeadView = false
        pageMenu.reloadData()
        view.addSubview(pageMenu.view)
    }
}
