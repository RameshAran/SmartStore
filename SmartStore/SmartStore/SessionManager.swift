//
//  SessionManager.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 18/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import Foundation
import RealmSwift

class SessionManager {
    public static let sharedInstance = SessionManager()
    
    let dataManager: StoreDataManager
    
    let realm = try! Realm()
    
    var cartItemCount: Int = 0
    
    var cartItems: NSMutableArray = NSMutableArray()
        
    private init() {
        self.dataManager = StoreDataManager()
        loadCartFromDisc()
    }
    
    func loadCartFromDisc () {
        
        let items = realm.objects(RealmStoreItem.self)
        
        for realmItem in items {
            
            let sItem = StoreItem()
            
            sItem.id = realmItem.id
            sItem.productName = realmItem.productName
            sItem.price = realmItem.price
            sItem.imageUrl = realmItem.imageUrl
            sItem.category = realmItem.category
            sItem.quantity = realmItem.quantity
            sItem.cartItemCount = realmItem.cartItemCount
            
            cartItems.add(sItem)
            cartItemCount += 1
        }
    }
}
