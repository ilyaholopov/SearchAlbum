//
//  CurrentTranslationData.swift
//  testHedgehog
//
//  Created by Илья Холопов on 02.11.2021.
//

import Foundation


struct CurrentData: Decodable {
    let resultCount: Int
    let results: [results]
}

struct results: Decodable {
    let artworkUrl100: String?
    let collectionId: Int?
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let primaryGenreName: String?
}

