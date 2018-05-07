//
//  SettingsTableViewCell.swift
//  Prism
//
//  Created by Shiv Shah on 4/27/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit
import Material


class SettingsTableViewCell: UITableViewCell {
    
    var settingsIcon: UIImageView!
    var settingsLabel: UILabel!
    var boldFont: UIFont = SourceSansFont.bold(with: 17)
    var mediumFont: UIFont = SourceSansFont.light(with: 17)
    var thinFont: UIFont = SourceSansFont.extraLight(with: 12)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        initializeSettingsLabel()
        initializeSettingsIcon()
        
        contentView.addConstraintsWithFormat(format: "H:|-16-[v0(24)]-16-[v1]|", views: settingsIcon, settingsLabel)
        contentView.addConstraintsWithFormat(format: "V:|-12-[v0(24)]-12-|", views: settingsIcon)
        contentView.addConstraintsWithFormat(format: "V:|-12-[v0]-12-|", views: settingsLabel)
        contentView.backgroundColor = UIColor(hex: 0x1a1a1a)
    }
    
    private func initializeSettingsLabel() {
        settingsLabel = UILabel()
        settingsLabel.textColor = UIColor.white
        settingsLabel.font = mediumFont
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(settingsLabel)
    }
    
    private func initializeSettingsIcon() {
        settingsIcon = UIImageView()
        settingsIcon.contentMode = .scaleAspectFit
        settingsIcon.clipsToBounds = true
        settingsIcon.translatesAutoresizingMaskIntoConstraints = false
        settingsIcon.image = Icons.NOTIFICATIONS_24?.withRenderingMode(.alwaysTemplate)
        settingsIcon.tintColor = .white
        contentView.addSubview(settingsIcon)
        
    }
}
