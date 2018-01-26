//
//  CustomHeadView.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/25.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class CustomHeadView: UIView {

    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var barViewHeight: NSLayoutConstraint!
    var backAction: (()->Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        barViewHeight.constant = Demo.naviBarHeight()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        backAction()
    }
}
