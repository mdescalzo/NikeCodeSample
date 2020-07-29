//
//  DetailViewController.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/22/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: AlbumViewModel? {
        didSet {
            guard viewModel != nil else { return }
            
            viewModel?.artImage.bind { [unowned self] image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
            DispatchQueue.main.async {
                self.imageView.image = self.viewModel?.artImage.value
                self.nameLabel.detailLabel.text = self.viewModel?.nameString
                self.artistLabel.detailLabel.text = self.viewModel?.artistString
                self.genreLabel.detailLabel.text = self.viewModel?.genreString
                self.releaseLabel.detailLabel.text = self.viewModel?.releaseDateString
                self.copyrightLabel.detailLabel.text = self.viewModel?.copyrightString
                
                if let artist = self.viewModel?.artistString {
                    self.linkButton.setTitle("Visit \(artist) on iTunes", for: .normal)
                } else {
                    self.linkButton.setTitle("Visit artist on iTunes", for: .normal)
                }
            }
        }
    }

    private let labelTextColor = UIColor.systemGray
    
    private let linkButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(handleLinkButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ self.nameLabel,
                                                    self.artistLabel,
                                                    self.genreLabel,
                                                    self.releaseLabel,
                                                    self.copyrightLabel, ])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 3.0
        
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.layer.shadowColor = UIColor.gray.cgColor
        imageview.layer.shadowRadius = 6.0
        imageview.layer.shadowOpacity = 0.5
        
        return imageview
    }()
    
    private lazy var nameLabel: DetailRowView = {
        let label = DetailRowView()
        label.infoLabel.textAlignment = .right
        label.infoLabel.text = "Album:"
        label.infoLabel.textColor = self.labelTextColor
        return label
    }()
    private lazy var artistLabel: DetailRowView = {
        let label = DetailRowView()
        label.infoLabel.textAlignment = .right
        label.infoLabel.text = "Artist:"
        label.infoLabel.textColor = self.labelTextColor
        return label
    }()
    private lazy var genreLabel: DetailRowView = {
        let label = DetailRowView()
        label.infoLabel.textAlignment = .right
        label.infoLabel.text = "Genre:"
        label.infoLabel.textColor = self.labelTextColor
        return label
    }()
    private lazy var releaseLabel: DetailRowView = {
        let label = DetailRowView()
        label.infoLabel.textAlignment = .right
        label.infoLabel.text = "Release:"
        label.infoLabel.textColor = self.labelTextColor
        return label
    }()
    
    private lazy var copyrightLabel: DetailRowView = {
        let label = DetailRowView()
        label.infoLabel.textAlignment = .right
        label.infoLabel.text = "Copyright:"
        label.infoLabel.textColor = self.labelTextColor
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .secondarySystemBackground
        } else {
            self.view.backgroundColor = .lightGray
        }
        
        configureSubviews()
    }
    
    private func configureSubviews() {
        
        let subViews = [ "button" : linkButton, "stack": stack, "image": imageView ]
        
        for aview in subViews.values {
            aview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(aview)
        }
        
//        if #available(iOS 11, *) {
//            let guide = view.safeAreaLayoutGuide
//            NSLayoutConstraint.activate([
//                imageView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
//                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: linkButton.bottomAnchor, multiplier: 1.0)
//            ])
//        } else {
//            let topSpacing: CGFloat = 8.0
//            let bottonSpacing: CGFloat = 20.0
//            NSLayoutConstraint.activate([
//                imageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: topSpacing),
//                bottomLayoutGuide.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: bottonSpacing)
//            ])
//        }
        
        self.view.addConstraint(NSLayoutConstraint(item: imageView,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: view,
                                                   attribute: .centerX,
                                                   multiplier: 1.0,
                                                   constant: 0.0))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[stack]-(20)-|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: subViews))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[image(200)]-(30)-[stack]",
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
        
        self.view.addConstraint(NSLayoutConstraint(item: imageView,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: imageView,
                                                   attribute: .height,
                                                   multiplier: 1.0,
                                                   constant: 0.0))

    }
    
    @objc private func handleLinkButtonTap() {
        guard let urlString = viewModel?.artistUrlString,
            let url = URL(string: urlString) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
