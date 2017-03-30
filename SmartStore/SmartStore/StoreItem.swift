//
//  StoreItem.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 17/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import Foundation

class StoreItem: NSObject {
    
    var id: Int = -1
    var productName: String = ""
    var price: Int = 0
    var imageUrl: String = ""
    var category: String = ""
    var quantity: Int = 0
    var cartItemCount: Int = 0
    
    override init() {
    
    }
    
    init(json: NSDictionary) {
        
        if let mId = json["id"] {
            self.id = mId as! Int
        }
        
        if let mName = json["productName"] {
            self.productName = mName as! String
        }
        
        if let mPrice = json["price"] {
            self.price = mPrice as! Int
        }
        
        if let mImageUrl = json["imageUrl"] {
            self.imageUrl = mImageUrl as! String
        }
        
        if let mCategory = json["category"] {
            self.category = mCategory as! String
        }
        
        if let mPrice = json["quantity"] {
            self.quantity = mPrice as! Int
        }
    }
}
