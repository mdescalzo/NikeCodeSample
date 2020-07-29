//
//  AlbumCell.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/22/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
        
    var viewModel: AlbumViewModel? {
        didSet {
            if let model = viewModel {
                nameLabel.text = model.nameString
                artistLabel.text = model.artistString
                thumbnailView.image = model.artImage.value
                model.artImage.bind { [unowned self] image in
                    DispatchQueue.main.async {
                        self.thumbnailView.image = image
                    }
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .gray
        
        return label
    }()

    private let thumbnailView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
                
        let views = [ "thumbnail" : thumbnailView, "name": nameLabel, "artist": artistLabel ]
        
        for view in views.values {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[thumbnail]-(8)-[name]-(0)-|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[thumbnail]-(16)-[artist]-(0)-|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[thumbnail]-(0)-|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(3)-[name]-(0)-[artist]-(6)-|",
                                                                  options: [],
                                                                  metrics: nil,
                                                                  views: views))
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
    }
    
    override func prepareForReuse() {
        artistLabel.text = ""
        nameLabel.text = ""
        thumbnailImage = nil
        imageView?.image = nil
        viewModel = nil
        super.prepareForReuse()
    }

}
