//
//  NetworkService.swift
//  testHedgehog
//
//  Created by Илья Холопов on 07.11.2021.
//

import Foundation

class NetworkService {
    
    func request(urlComponents: URLComponents, completion: @escaping (Data?, Error?) -> Void) {
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.sync {
                completion(data, error)
            }
        }
    }
}
