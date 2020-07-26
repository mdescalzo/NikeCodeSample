//
//  UIImage+Extensions.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/25/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     Utility function to fetch a UIImage from a url string
     */
    class func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let imageUrl = URL(string: urlString),
            let imageData = try? Data(contentsOf: imageUrl) {
                completion(UIImage(data: imageData))
        } else {
            completion(nil)
        }
    }
}
