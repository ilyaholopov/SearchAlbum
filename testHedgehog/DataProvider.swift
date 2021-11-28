//
//  DataProvider.swift
//  testHedgehog
//
//  Created by Илья Холопов on 06.11.2021.
//

import Foundation
import UIKit

class DataProvider {
    var imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString){
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url)
            
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard error == nil,
                      data != nil,
                      let `self` = self else { return }
                
                guard let image = UIImage(data: data!) else {return}
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
                
            }
            dataTask.resume()
        }
    }
}
