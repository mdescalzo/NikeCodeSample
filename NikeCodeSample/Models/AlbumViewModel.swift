//
//  AlbumViewModel.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/25/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

/**
 Class to manage the visual elements of Album Models
 */
class AlbumViewModel {
    
    // UIImage cache to prevent the need for repeated lookups
    private static var thumbnailCache = NSCache<NSString,UIImage>()
    
    let artImage = Box(UIImage(named: "blue-vinyl"))
    let nameString: String
    let artistString: String
    let releaseDateString: String
    let copyrightString: String
    let genreString: String
    let artistUrlString: String
    
    private let albumId: String
    
    /**
     Designated initializer used to build a view model from an album model
     
     - Parameter model: Data model used to build the view model
     */
    required init?(model: AlbumModel) {
        guard model.id.count > 0 else { return nil }
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
        }()
        copyrightString = model.copyright ?? "None"
        if let name = model.genres.first?.name {
            genreString = name
        } else {
            genreString = "None"
        }
        
        albumId = model.id
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let this = self else { return }
            this.updateArtwork(with: model.artworkUrl100)
        }
    }
    
    private func updateArtwork(with urlString: String) {
        if let image = Self.thumbnailCache.object(forKey: albumId as NSString) {
            artImage.value = image
        } else {
            UIImage.fetchImage(from: urlString) { [weak self] image in
                guard let this = self else { return }
                if let image = image {
                    this.artImage.value = image
                    Self.thumbnailCache.setObject(image, forKey: this.albumId as NSString)
                }
            }
        }
    }
}
