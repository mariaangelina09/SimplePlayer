//
//  Song.swift
//  SimplePlayer
//
//  Created by Maria Angelina on 29/01/22.
//

import Foundation

struct SongResponse: Codable {
    let object: SongObject
}

struct SongObject: Codable {
    let resultCount: Int?
    let results: [Song]
}

struct Song: Codable {
    let artistId,
        collectionId,
        trackId: Int?
    
    let wrapperType,
        kind,
        artistName,
        collectionName,
        trackName,
        collectionCensoredName,
        trackCensoredName,
        artistViewUrl,
        collectionViewUrl,
        trackViewUrl,
        previewUrl,
        artworkUrl30,
        artworkUrl60,
        artworkUrl100,
        releaseDate,
        collectionExplicitness,
        trackExplicitness,
        country,
        currency,
        primaryGenreName: String?
    
    let collectionPrice,
        trackPrice: Double?
    
    let discCount,
        discNumber,
        trackCount,
        trackNumber,
        trackTimeMillis: Int?
    
    let isStreamable: Bool?
}
