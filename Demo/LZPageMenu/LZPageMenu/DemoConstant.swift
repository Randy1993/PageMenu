//
//  DemoConstant.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/25.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

struct Demo {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static func naviBarHeight() -> CGFloat {
        var isIphoneX = false
        isIphoneX = (screenWidth == 375.0 && screenHeight == 812.0)
        
        return isIphoneX ? 88.0 : 64.0
    }
}
