//
//  CustomView.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 19/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import Foundation
import UIKit
import BBBadgeBarButtonItem

class ViewFactory {
    
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    class func getCartBarButtonItem(_ receiver: Any?, selector: Selector) -> BBBadgeBarButtonItem{
        let image = UIImage(named: "shopping_cart")?.withRenderingMode(.automatic)
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.setImage(image, for: UIControlState.normal)
        button.addTarget(receiver, action: selector, for: .touchUpInside)
        let barButtonItem = BBBadgeBarButtonItem(customUIButton: button)
        return barButtonItem!
    }
    
    class func getCartViewController() -> MyCartViewController {
        let controller: MyCartViewController = storyboard.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        return controller
    }
    
    class func getItemDetailViewController() -> ItemDetailViewController {
        let controller: ItemDetailViewController = storyboard.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        return controller
    }
    
    class var simpleCartBarButtonItem: UIBarButtonItem {
        let image = UIImage(named: "shopping_cart")?.withRenderingMode(.automatic)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(FirstViewController.cartButtonHandler))
        button.imageInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        return button
    }
}
