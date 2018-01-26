//
//  AttributeViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class AttributeViewController: UIViewController {

    private var pageMenu: LZPageMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        
        pageMenu = LZPageMenu.init(frame: CGRect.init(x: 0.0, y: 0.0, width: Demo.screenWidth, height: Demo.screenHeight - Demo.naviBarHeight()))
        pageMenu.menuItemSelectedTitles = [NSAttributedString]()
        pageMenu.menuItemUnselectedTitles = [NSAttributedString]()
        for index in 1...10 {
            let vc = InfoViewController()
            vc.infoLabel.text = "Number:\(index)"
            pageMenu.menuItemSelectedTitles!.append(getAttributeText(text: "Number:\(index)", selected: true))
            pageMenu.menuItemUnselectedTitles!.append(getAttributeText(text: "Number:\(index)", selected: false))
            pageMenu.viewControllers.append(vc)
        }
        pageMenu.reloadData()
        view.addSubview(pageMenu.view)
    }
    
    func getAttributeText(text: String, selected: Bool) -> NSAttributedString {
        let firstColor: UIColor = selected ? UIColor.red : UIColor.white
        let secondColor: UIColor = selected ? UIColor.black : UIColor.lightGray
        
        let firstAttribute = NSAttributedString.init(string: text, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : firstColor])
        let secondAttribute = NSAttributedString.init(string: "(Remarks)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor : secondColor])
        let mutableString = NSMutableAttributedString.init(attributedString: firstAttribute)
        mutableString.append(secondAttribute)
        
        return mutableString
    }

}
