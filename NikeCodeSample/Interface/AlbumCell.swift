//
//  AlbumCell.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/22/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

enum CellState {
    case loading
    case viewing
}

class AlbumCell: UITableViewCell {
    
    var state: CellState = .loading {
        didSet {
            DispatchQueue.main.async {
                switch self.state {
                case .loading:
                    self.spinner.startAnimating()
                    self.thumbnailView.isHidden = true
                case .viewing:
                    self.spinner.stopAnimating()
                    self.thumbnailView.isHidden = false
                }
            }
        }
    }

    var thumbnailImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.thumbnailView.image = self.thumbnailImage
            }
        }
    }
    
    let nameLabel = UILabel()
    let artistLabel = UILabel()
    let spinner = UIActivityIndicatorView()

    private let thumbnailView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        
        let views = [ "thumbnail" : thumbnailView, "name": nameLabel, "artist": artistLabel, "spinner": spinner  ]
        
        for view in views.values {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[thumbnail]-(8)-[name]-(0)-|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[thumbnail]-(16)-[artist]-(0)-|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[thumbnail]-(0)-|", options: [], metrics: nil, views: views))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[spinner]-(8)-[name]-(0)-|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[spinner]-(16)-[artist]-(0)-|", options: [], metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[spinner]-(0)-|", options: [], metrics: nil, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(3)-[name]-(3)-[artist]-(3)-|", options: [], metrics: nil, views: views))
        contentView.addConstraint(NSLayoutConstraint(item: thumbnailView,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: thumbnailView,
                                                     attribute: .height,
                                                     multiplier: 1.0,
                                                     constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .height,
                                                     multiplier: 0.55,
                                                     constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: artistLabel,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .height,
                                                     multiplier: 0.45,
                                                     constant: 0.0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        artistLabel.text = ""
        nameLabel.text = ""
        thumbnailImage = nil
        imageView?.image = nil
        super.prepareForReuse()
    }

}
