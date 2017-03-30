//
//  ItemDetailViewController.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 18/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import UIKit
import BBBadgeBarButtonItem
import RealmSwift


class ItemDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productIcon: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var cButtonItem: BBBadgeBarButtonItem?
    var productItem: StoreItem?
    var fromCartView: Bool = false
    
    //let realm = try! Realm()
    let savedItem: RealmStoreItem = RealmStoreItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if fromCartView == false {
            setCartButton()
        } else {
            addToCartButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = productItem?.productName
        priceLabel.text = String(format: "Price: Rs.%d", (productItem?.price)!)
        
        self.productIcon.image = UIImage(named: "placeholder")
        ImageDownloader.ImageFromUrl(url: (productItem?.imageUrl)!, onfinished: { (img) in
            DispatchQueue.main.async {
                self.productIcon.image = img;
            }
        })
        
        //setting the current cart badge value
        cButtonItem?.badgeValue = String(SessionManager.sharedInstance.cartItemCount)
    }
    
    func setCartButton() {
        cButtonItem = ViewFactory.getCartBarButtonItem(self, selector: #selector(ItemDetailViewController.cartButtonClicked))
        self.navigationItem.rightBarButtonItem = cButtonItem
    }

    @IBAction func addToCart(sender: UIButton) {
        
        if isAlreadyInCart() {
            var _count: Int = (productItem?.cartItemCount)!
            _count = _count + 1
            
            if (productItem?.quantity)! >=  _count{
                productItem?.cartItemCount = _count
                updateCountToDisk(count: _count)
            } else {
                showOutOfItems()
            }
            
            return
        }
        
        SessionManager.sharedInstance.cartItems.add(productItem)
        productItem?.cartItemCount = 1
        saveToDisk()
        updateBadge()
        //showAddedCartAlert()
    }
    
    func cartButtonClicked() {
        self.navigationController?.pushViewController(ViewFactory.getCartViewController(), animated: true)
    }
    
    func updateBadge() {
        var count = SessionManager.sharedInstance.cartItemCount
        count += 1
        SessionManager.sharedInstance.cartItemCount = count
        cButtonItem?.badgeValue = String(count)
    }
    
    func saveToDisk() {
        //saving to disc
        
        savedItem.id = (productItem?.id)!
        savedItem.productName = (productItem?.productName)!
        savedItem.price = (productItem?.price)!
        savedItem.imageUrl = (productItem?.imageUrl)!
        savedItem.category = (productItem?.category)!
        savedItem.quantity = (productItem?.quantity)!
        savedItem.cartItemCount = 1
        
        try! SessionManager.sharedInstance.realm.write {
            SessionManager.sharedInstance.realm.add(savedItem)
        }
    }
    
    func updateCountToDisk(count: Int) {
        try! SessionManager.sharedInstance.realm.write {
            savedItem.cartItemCount = count
        }
    }
    
    func isAlreadyInCart() -> Bool {
        let realm = try! Realm()
        let items = realm.objects(RealmStoreItem.self)
        
        for realmItem in items {
            if realmItem.id == productItem?.id {
                return true
            }
        }
        return false
    }
    
    func showAddedCartAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Added to Cart", message: "This product has been added to your cart.", preferredStyle: .alert)
        let viewCartAction: UIAlertAction = UIAlertAction(title: "View Cart", style: .default) { action -> Void in
            self.cartButtonClicked()
        }
        let addAnotherAction: UIAlertAction = UIAlertAction(title: "Add More", style: .default) { action -> Void in
            self.popToHome()
        }
        alertController.addAction(viewCartAction)
        alertController.addAction(addAnotherAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlreadyAddedCartAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Added to Cart", message: "This product has been already added to your cart.", preferredStyle: .alert)
        let viewCartAction: UIAlertAction = UIAlertAction(title: "View Cart", style: .default) { action -> Void in
            self.cartButtonClicked()
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default) { action -> Void in
            self.popToHome()
        }
        alertController.addAction(viewCartAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showOutOfItems() {
        let alertController: UIAlertController = UIAlertController(title: "Items not available", message: "Items not available. Please wait.", preferredStyle: .alert)
        let viewCartAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            
        }
        alertController.addAction(viewCartAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func popToHome() {
        let viewControllers = self.navigationController?.popToRootViewController(animated: true)
        if (viewControllers?.count)! > 0 {
            print("poped: controllers: %@", viewControllers)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
