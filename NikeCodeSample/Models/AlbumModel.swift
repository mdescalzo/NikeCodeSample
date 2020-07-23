//
//  AlbumModel.swift
//

import Foundation

struct AlbumModel: Codable {
    
    let id: String
    let artistName: String
    let releaseDate: String
    let name: String
    let kind: String
    let copyright: String
    let artistId: String
    let contentAdvisoryRating: String?
    let artistUrl: String
    let artworkUrl100: String
    let url: String
    let genres: [GenreModel]
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case id = "id"
        case artistName = "artistName"
        case releaseDate = "releaseDate"
        case name = "name"
        case kind = "kind"
        case copyright = "copyright"
        case artistId = "artistId"
        case contentAdvisoryRating = "contentAdvisoryRating"
        case artistUrl = "artistUrl"
        case artworkUrl100 = "artworkUrl100"
        case url = "url"
        case genres = "genres"
    }
}

struct GenreModel: Codable {
    let genreId: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case genreId = "genreId"
        case name = "name"
        case url = "url"
    }
}
