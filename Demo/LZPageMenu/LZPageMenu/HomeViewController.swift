//
//  HomeViewController.swift
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/24.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                jumpTo("LineViewController")
            case 1:
                jumpTo("DotViewController")
            case 2:
                jumpTo("ImageViewController")
            case 3:
                jumpTo("SquareViewController")
            case 4:
                jumpTo("SolidOvalViewController")
            case 5:
                jumpTo("HollowOvalViewController")
            case 6:
                jumpTo("CustomOvalViewController")
            default: break
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                jumpTo("AverageViewController")
            case 1:
                jumpTo("CustomMenuViewController")
            case 2:
                jumpTo("ReloadTitlesViewController")
            case 3:
                jumpTo("CustomWidthViewController")
            case 4:
                jumpTo("BarViewController")
            case 5:
                jumpTo("AttributeViewController")
            default: break
            }
        }
        
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                jumpTo("SingleViewController")
            case 1:
                jumpTo("DoubleViewController")
            case 2:
                jumpTo("OffsetViewController")
            default: break
            }
        }
    }
    
    func jumpTo(_ viewController: String) {
        if let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String {
            let vcClass: UIViewController.Type = NSClassFromString(nameSpace + "." + viewController) as! UIViewController.Type
            let vc: UIViewController = vcClass.init()
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
