//
//  NetworkDataFetcher.swift
//  testHedgehog
//
//  Created by Илья Холопов on 08.11.2021.
//

import Foundation

class NetworkDataFetcher {
    var networkServise = NetworkService()
    
    func fetchAlbums(urlComponents: URLComponents, completion: @escaping (CurrentData?) -> ()) {
        networkServise.request(urlComponents: urlComponents) { (data, error) in
            if let error = error {
                print("Error fetchAlbums: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: CurrentData.self, from: data)
            completion(decode)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else {return nil}
        
        do{
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON: \(jsonError)")
            return nil
        }
    }
}
