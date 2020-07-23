//
//  DetailRowView.swift
//  NikeCodeSample
//
//  Created by Mark Descalzo on 7/23/20.
//  Copyright © 2020 Mark Descalzo. All rights reserved.
//

import UIKit

class DetailRowView : UIView {
    let infoLabel = UILabel()
    let detailLabel = UILabel()
        
    /**
     Space between the two labels
     */
    var alley: CGFloat = 8.0
    var ratio: CGFloat = 0.3
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {

        detailLabel.numberOfLines = 0
        
        let metrics = [ "alley" : alley, "ratio" : ratio ]
        let subViews = [ "info" : infoLabel, "detail": detailLabel ]
        
        for aview in subViews.values {
            aview.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(aview)
        }

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[info]-(alley)-[detail]-|",
                                                           options: .alignAllFirstBaseline,
                                                           metrics: metrics,
                                                           views: subViews))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[info]",
                                                           options: .alignAllFirstBaseline,
                                                           metrics: metrics,
                                                           views: subViews))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[detail]-|",
                                                           options: .alignAllFirstBaseline,
                                                           metrics: metrics,
                                                           views: subViews))
        self.addConstraint(NSLayoutConstraint.init(item: infoLabel,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .width,
                                                   multiplier: ratio,
                                                   constant: 0.0))
    }
}
