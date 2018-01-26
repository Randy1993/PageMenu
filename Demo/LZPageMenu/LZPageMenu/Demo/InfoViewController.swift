//
//  InfoViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    let infoLabel: UILabel
    
    init() {
        infoLabel = UILabel.init()
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont.systemFont(ofSize: 18)
        infoLabel.textAlignment = .center
        
        super.init(nibName: nil, bundle: nil)
        
        infoLabel.frame = CGRect.init(x: 0, y: 100, width: view.frame.width, height: 40)
        view.backgroundColor = UIColor.lightGray
        view.addSubview(infoLabel)
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
