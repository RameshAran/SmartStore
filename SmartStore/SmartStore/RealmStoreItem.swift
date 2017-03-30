//
//  RealmStoreItem.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 19/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import RealmSwift

class RealmStoreItem: Object {
    
    dynamic var id: Int = -1
    dynamic var productName: String = ""
    dynamic var price: Int = 0
    dynamic var imageUrl: String = ""
    dynamic var category: String = ""
    dynamic var quantity: Int = 0
    dynamic var cartItemCount: Int = 0
}
