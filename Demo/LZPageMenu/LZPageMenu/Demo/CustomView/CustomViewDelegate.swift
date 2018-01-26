//
//  CustomViewDelegate.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class CustomViewDelegate: NSObject, LZPageMenuCustomProtocol {
    func menuItemView() -> UIView {
        
        return Bundle.main.loadNibNamed("CustomMenuItem", owner: nil, options: nil)![0] as! UIView
    }
    
    func menuItemUnselectedWidth(index: Int) -> Float {
        return 130.0
    }
    
    func configView(view: UIView, index: Int, selected: Bool) {
        let customView = view as! CustomMenuItem
        
        customView.titleLabel.textColor = selected ? UIColor.red : UIColor.black
        customView.subtitleLabel.textColor = selected ? UIColor.red : UIColor.black
        customView.titleLabel.text = "Title\(index + 1)"
        customView.subtitleLabel.text = "Subtitle\(index + 1)"
    }
}
