//
//  MyCartViewController.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 17/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import UIKit
import RealmSwift

class MyCartViewController: UITableViewController {

    var items: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        items = SessionManager.sharedInstance.cartItems
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cellIdentifier = "cart_cell_identifier"
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
            }
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            let item: StoreItem = items![indexPath.row] as! StoreItem
            cell.nameLabel.text = item.productName
            cell.priceLabel.text = String(format: "Rs.%d", item.price)
            cell.quantityLabel.text = String(format: "Quantity: %d", item.cartItemCount);
            
            cell.productIcon.image = UIImage(named: "placeholder")
            ImageDownloader.ImageFromUrl(url: item.imageUrl, onfinished: { (img) in
                DispatchQueue.main.async {
                    cell.productIcon.image = img;
                }
            })
            
            return cell
        }
        
        let cellIdentifier = "cart_summary_cell_identifier"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CartSummaryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        cell.accessoryType = UITableViewCellAccessoryType.none
        
        var totalPrice: Int = 0
        for  item in items! {
            let unitPrice: Int = (item as! StoreItem).price
            let quantity: Int = (item as! StoreItem).cartItemCount
            let totalItemPrice: Int = unitPrice * quantity
            totalPrice += totalItemPrice
        }
        
        cell.priceLabel.text = String(format: "Total Price: %d", totalPrice)
        cell.checkoutButton.addTarget(self, action: #selector(MyCartViewController.checkOutButtonClicked), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (items?.count)!
        }
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 126
        }
        return 214
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let controller = ViewFactory.getItemDetailViewController()
            controller.productItem = items![indexPath.row] as? StoreItem
            controller.fromCartView = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItem(index: indexPath)
        }
    }
    
    func removeItem(index: IndexPath) {
        
        //remove from disk
        let realm = try! Realm()
        let itemToDelete = realm.objects(RealmStoreItem.self).filter("id = %d", (items?[index.row] as! StoreItem).id)
        try! realm.write {
            realm.delete(itemToDelete)
        }
        
        items?.removeObject(at: index.row)
        self.tableView.deleteRows(at: [index], with: .left)
        self.tableView.reloadData()
        
        //update cart badge number
        var count = SessionManager.sharedInstance.cartItemCount
        count -= 1
        SessionManager.sharedInstance.cartItemCount = count
    }
    
    func checkOutButtonClicked() {
        //checkout all products
        
        //reset 
        let realm = try! Realm()
        let allItems = realm.objects(RealmStoreItem.self)
        try! realm.write {
            realm.delete(allItems)
        }
        
        items?.removeAllObjects()
        SessionManager.sharedInstance.cartItemCount = 0
        
        showSuccessAlert()
    }
    
    func showSuccessAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Success", message: "Thank you for purchasing this product.", preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            self.popToHome()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func popToHome() {
        let viewControllers = self.navigationController?.popToRootViewController(animated: true)
        if (viewControllers?.count)! > 0 {
            print("poped: controllers: %@", viewControllers)
        }
    }
}
