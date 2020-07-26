//
//  AlbumViewModel.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/25/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

class AlbumViewModel {
    
    private static var thumbnailCache = NSCache<NSString,UIImage>()
    
    
    let artImage = Box(UIImage(named: "blue-vinyl"))
    let nameString: String
    let artistString: String
    let releaseDateString: String
    let copyrightString: String
    let genreString: String
    let artistUrlString: String
    
    private let albumId: String
    
    required init(model: AlbumModel) {
        nameString = model.name
        artistString = model.artistName
        artistUrlString = model.artistUrl
        releaseDateString = {
            let inputFormat: DateFormatter = {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd"
                return df
            }()
            let outputFormat: DateFormatter = {
                let df = DateFormatter()
                df.timeStyle = .none
                df.dateStyle = .long
                return df
            }()
            if let date = inputFormat.date(from: model.releaseDate) {
                return outputFormat.string(from: date)
            } else {
                return model.releaseDate
            }
        }()  // TODO: Make this prettier
        copyrightString = model.copyright
        if let name = model.genres.first?.name {
            genreString = name
        } else {
            genreString = "None"
        }
        
        albumId = model.id
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            self.updateArtwork(with: model.artworkUrl100)
        }
    }
    
    func updateArtwork(with urlString: String) {
        if let image = Self.thumbnailCache.object(forKey: albumId as NSString) {
            artImage.value = image
        } else {
            UIImage.fetchImage(from: urlString) { [unowned self] image in
                if let image = image {
                    self.artImage.value = image
                    Self.thumbnailCache.setObject(image, forKey: self.albumId as NSString)
                }
            }
        }
    }
}
