//
//  SingleViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/25.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController, LZPageMenuProtocol {

    private var pageMenu: LZPageMenu!
    private var headView: CustomHeadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = true
        
        headView = Bundle.main.loadNibNamed("CustomHeadView", owner: nil, options: nil)?.first as! CustomHeadView
        headView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 200)
        headView.layer.borderColor = UIColor.red.cgColor
        headView.layer.borderWidth = 1
        headView.backAction = {
            [unowned self] in
            
            self.navigationController?.popViewController(animated: true)
        }
        
        pageMenu = LZPageMenu.init(frame: CGRect.init(x: 0.0, y: 0.0, width: Demo.screenWidth, height: Demo.screenHeight))
        for index in 1...10 {
            let vc = OneTableViewController()
            vc.title = "Number:\(index)"
            pageMenu.viewControllers.append(vc)
        }
        
        pageMenu.delegate = self
        pageMenu.headView = headView
        pageMenu.headViewHeight = 200
        pageMenu.headViewTopSafeDistance = 64
        pageMenu.headViewMaxmumOffsetRate = 0.5
        pageMenu.reloadData()
        view.addSubview(pageMenu.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: LZPageMenuProtocol
    func headerViewOffsetY(offsetY: CGFloat, heightOffset: CGFloat) {
        headView.barView.isHidden = !(offsetY < 0 && fabs(offsetY) >= CGFloat(pageMenu.headViewHeight - pageMenu.headViewTopSafeDistance))
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        print("NewPage:\(index)")
    }
    
    func subScrollViewDidScroll(subScrollView: UIScrollView) {
        print("subScrollViewDidScroll:\(subScrollView.contentOffset)")
    }
    
    func subScrollViewDidEndScroll(subScrollView: UIScrollView) {
        print("subScrollViewDidEndScroll")
    }
}
