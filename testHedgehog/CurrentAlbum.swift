//
//  CurrentAlbum.swift
//  testHedgehog
//
//  Created by Илья Холопов on 02.11.2021.
//

import Foundation

struct CurrentWord {
    let resultsAlbums: [results]
    
    init?(currentData: CurrentData) {
        resultsAlbums = currentData.results
    }
}
