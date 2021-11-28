//
//  NetworkManager.swift
//  testHedgehog
//
//  Created by Илья Холопов on 02.11.2021.
//

import Foundation
import UIKit



class NetworkManager {
    func fetchCurrent(urlRequest url: String, completionHandler: @escaping (CurrentWord) -> Void)  {
        
        let urlString = "https://itunes.apple.com/\(url)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let answer = self.parseJSON(withData: data) {
                    completionHandler(answer)
                }
            }
            semaphore.signal()
        }
        task.resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
    }
    
    func parseJSON(withData data: Data) -> CurrentWord? {
        let decoder = JSONDecoder()
        do {
            let currentData = try decoder.decode(CurrentData.self, from: data)
            guard let currentAlbum = CurrentWord(currentData: currentData) else { return nil}
            return currentAlbum
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
    
}
