//
// Created by Satish Boggarapu on 3/3/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit
import Material

public enum NavigationBarType {
    case MainView
    case OtherProfile
    case OwnProfile
    case ImageView
    case LikeOrFollowView

}

class NavigationBar: UIView {

    // MARK: UIElements
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
    var leftButton: UIButton!
    var rightButton: UIButton!

    init(type: NavigationBarType) {
        super.init(frame: CGRect.init())
        commonInit(type: type)
    }

    // Init function for code mode
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(type: .MainView)
    }

    // Init function for interface mode
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func commonInit(type: NavigationBarType) {
        self.backgroundColor = UIColor.navigationBarColor
        switch type {
            case .MainView:
                initializeMainViewMode()
            case .OtherProfile:
                 initializeOtherProfileMode()
            case .OwnProfile:
                initializeOwnProfileMode()
            case .ImageView:
                initializeImageViewMode()
            case .LikeOrFollowView:
                initializeLikeOrFollowViewMode()
        }
    }

    private func initializeMainViewMode() {
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = Icons.SPLASH_SCREEN_ICON
        self.addSubview(iconImageView)

        titleLabel = UILabel()
        titleLabel.text = "Prism"
        titleLabel.font = SourceSansFont.bold(with: 22)
        titleLabel.textColor = UIColor.white
        self.addSubview(titleLabel)

        // constraints
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]-8-[v1]|", views: iconImageView, titleLabel)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: iconImageView)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: titleLabel)
    }

    private func initializeOtherProfileMode() {
        
    }
    
    private func initializeOwnProfileMode() {
        
    }

    private func initializeImageViewMode() {
        
    }

    private func initializeLikeOrFollowViewMode() {
        
    }

}
