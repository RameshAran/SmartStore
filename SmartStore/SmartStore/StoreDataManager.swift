//
//  StoreDataManager.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 18/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import Foundation

class StoreDataManager: NSObject {

    func loadStoreItems(_ completionClosure: @escaping (_ indexes: NSMutableArray)-> ()) {
        
        let mItemArray: NSMutableArray = NSMutableArray()
        if let path = Bundle.main.path(forResource: "sample_data", ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                if let jsonResult = try? JSONSerialization.jsonObject(with: jsonData as Data, options: []) as! [String:Any]
                {
                    if let persons : NSArray = jsonResult["items"] as? NSArray
                    {
                        //print(persons);
                        for case let dict as NSDictionary in persons {
                            //print(dict)
                            let mItem: StoreItem = StoreItem(json: dict)
                            //print(mItem)
                            mItemArray.add(mItem)
                        }
                        completionClosure(mItemArray)
                        return;
                    }
                }
            }
        }
        completionClosure(mItemArray)
    }
}
