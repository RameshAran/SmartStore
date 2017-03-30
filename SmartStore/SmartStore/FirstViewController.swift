//
//  FirstViewController.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 17/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import UIKit
import BBBadgeBarButtonItem

class FirstViewController: UITableViewController {

    var storeItems: NSMutableArray = NSMutableArray()
    var filteredItems: NSMutableArray = NSMutableArray()
    
    let defaultCellHeight: CGFloat = 65
    
    var imageCache: [String: UIImage] = [String: UIImage]()
    let searchController = UISearchController(searchResultsController: nil)
    var cButtonItem: BBBadgeBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Home";
        setCartButton()
        createSearchInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SessionManager.sharedInstance.dataManager.loadStoreItems { (items) in
            self.storeItems = items
            self.filteredItems = items
        }
        
        //setting the current cart badge value
        cButtonItem?.badgeValue = String(SessionManager.sharedInstance.cartItemCount)
    }
    
    func setCartButton() {
        cButtonItem  = ViewFactory.getCartBarButtonItem(self, selector: #selector(FirstViewController.cartButtonHandler))
        self.navigationItem.rightBarButtonItem = cButtonItem
    }
    
    func createSearchInterface() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Electronics", "Furniture", "Other"]
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func cartButtonHandler() {
        self.navigationController?.pushViewController(ViewFactory.getCartViewController(), animated: true)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "Electronics") {
        
        var predicate: NSPredicate?
        
        if searchText.characters.count > 0 {
            if scope == "All" {
                predicate = NSPredicate(format: "productName CONTAINS[cd] %@", searchText)
            } else {
                predicate = NSPredicate(format: "productName CONTAINS[cd] %@ AND category LIKE %@", searchText, scope)
            }
            let items = NSMutableArray(array: self.storeItems.filtered(using: predicate!))
            self.filteredItems = NSMutableArray(array: items)
        } else {
            if scope == "All" {
                self.filteredItems = self.storeItems
            } else {
                predicate = NSPredicate(format: "category LIKE %@", scope)
                let items = NSMutableArray(array: self.storeItems.filtered(using: predicate!))
                self.filteredItems = NSMutableArray(array: items)
            }
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "item_cell_identifier"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let item: StoreItem = self.filteredItems[indexPath.row] as! StoreItem
        cell.nameLabel.text = item.productName
        cell.priceLabel.text = String(format: "Rs.%d", item.price)
        
        if let img = imageCache[item.imageUrl] {
            cell.productIcon.image = img;
        } else {
            cell.productIcon.image = UIImage(named: "placeholder")
            ImageDownloader.ImageFromUrl(url: item.imageUrl, onfinished: { (img) in
                DispatchQueue.main.async {
                    cell.productIcon.image = img;
                    self.imageCache[item.imageUrl] = img
                }
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ViewFactory.getItemDetailViewController()
        controller.productItem = self.filteredItems[indexPath.row] as? StoreItem
        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FirstViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.selectedScopeButtonIndex = 0
        //tableView.reloadData()
    }
}

extension FirstViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

