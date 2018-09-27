//
//  NavigationView.swift
//  Prism
//
//  Created by Satish Boggarapu on 9/26/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

class NavigationView: UIView {
    
    var iconImageView: UIImageView!
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        iconImageView = UIImageView(image: Icons.SPLASH_SCREEN_ICON)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 0, y: 4, width: 34, height: 34)
        addSubview(iconImageView)
        
        titleLabel =  UILabel()
        titleLabel.frame = CGRect(x: 44, y: 4, width: 100, height: 34)
        titleLabel.text = "Prism"
        titleLabel.font = SourceSansFont.bold(with: 22)
        titleLabel.textColor = UIColor.white
        addSubview(titleLabel)
    }
    
}
