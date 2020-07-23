//
//  DetailViewController.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/22/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var albumViewModel: AlbumModel? {
        didSet {
            guard let model = albumViewModel else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(urlString: model.artworkUrl100)
                self.nameLabel.text = model.name
                self.artistLabel.text = model.artistName
                
                self.releaseLabel.text = model.releaseDate
                self.copyrightLabel.text = model.copyright
            }
        }
    }
    
    private let linkButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(handleLinkButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ self.imageView,
                                                    self.nameLabel,
                                                    self.artistLabel,
                                                    self.genreLabel,
                                                    self.releaseLabel,
                                                    self.copyrightLabel, ])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        return stack
    }()
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let artistLabel = UILabel()
    private let genreLabel = UILabel()
    private let releaseLabel = UILabel()
    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground

        configureSubviews()
    }
    
    private func configureSubviews() {
        
        let subViews = [ "button" : linkButton, "stack": stackView ]
        
        for aview in subViews.values {
            aview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(aview)
        }
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[stack]-(20)-|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: subViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(70)-[stack]-(20)-[button]",
                                                                options: [],
                                                                metrics: nil,
                                                                views: subViews))

        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[button]-(20)-|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: subViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[button]-(20)-|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: subViews))
    }

   @objc private func handleLinkButtonTap() {
    guard let model = albumViewModel,
        let url = URL(string: model.artistUrl) else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
