//
//  ImageDownloader.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 18/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    class func ImageFromUrl(url: String, onfinished:@escaping (_ image: UIImage?) -> Void) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
        let downloadTask = session.dataTask(with: url as URLRequest, completionHandler: {
            data,response,error in
            
            if error == nil
            {
                if let image = UIImage(data: data!)
                {
                    onfinished(image)
                }
            }
        })
        downloadTask.resume();
        
    }
}

