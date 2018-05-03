//
//  SettingsCollectionView.swift
//  Prism
//
//  Created by Shiv Shah on 4/5/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Material
import MaterialComponents
import Firebase

class SettingsCollectionView: UICollectionViewCell {

    // MARK: UIElements
    var profileView: UIView!
    var bottomView: UIView!
    var profileImage: CustomImageView!
    var fullName: UILabel!
    var viewYourProfileText: UILabel!
    var profilePictureSize: CGFloat = 64
    var boldFont: UIFont = SourceSansFont.bold(with: 17)
    var mediumFont: UIFont = SourceSansFont.light(with: 17)
    var thinFont: UIFont = SourceSansFont.extraLight(with: 12)
    var tableView: UITableView!
    var settingsLabelTexts: [String]!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.collectionViewBackground
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        initializeProfileView()
        initializeProfilePicture()
        initializeFullName()
        initializeViewYourProfileText()
        initializeTableView()
        
        // Set Profile View
        let topRightView = UIStackView()
        topRightView.alignment = .top
        topRightView.distribution = .fillEqually
        topRightView.axis = .vertical
        topRightView.addArrangedSubview(fullName)
        topRightView.addArrangedSubview(viewYourProfileText)
        
        profileView.addSubview(profileImage)
        profileView.addSubview(topRightView)
        profileView.addConstraintsWithFormat(format: "H:|-16-[v0(\(profilePictureSize))]-16-[v1]|", views: profileImage, topRightView)
        profileView.addConstraintsWithFormat(format: "V:|-16-[v0(\(profilePictureSize))]-16-|", views: profileImage)
        profileView.addConstraintsWithFormat(format: "V:|-24-[v0]-24-|", views: topRightView)
        profileView.backgroundColor = UIColor(hex: 0x1a1a1a)
        self.addSubview(profileView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: profileView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: tableView)
        addConstraintsWithFormat(format: "V:|-8-[v0]-[v1]|", views: profileView, tableView)
    }
    
    private func initializeProfileView() {
        profileView = UIView()
        // tap gesture
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapGestureAction(_:)))
        profileView.addGestureRecognizer(profileTapGesture)
    }
    
    private func initializeFullName() {
        fullName = UILabel()
        fullName.text = "Shiv Shah"
        fullName.textColor = UIColor.white
        fullName.font = mediumFont
        fullName.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initializeViewYourProfileText() {
        viewYourProfileText = UILabel()
        viewYourProfileText.text = "View your profile"
        viewYourProfileText.textColor = UIColor.white
        viewYourProfileText.font = mediumFont
        viewYourProfileText.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initializeProfilePicture() {
        profileImage = CustomImageView()
        loadProfileImage()
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profilePictureSize/2
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initializeTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(hex: 0x1a1a1a)
        addSubview(tableView)
        settingsLabelTexts = ["App Settings", "Notification Settings", "Account Settings", "Help", "About", "Logout"]
    }
    
    @objc func profileTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on profile View")
    }
    
    
    public func loadProfileImage() {
        let profilePicture = CurrentUser.prismUser.getProfilePicture().getLowResDefaultProfilePic()
//        if profilePicture != nil {
            profileImage.image = profilePicture
//        } else {
//            let imageUrl = CurrentUser.prismUser.getProfilePicture().profilePicUriString
//            profileImage.loadImageUsingUrlString
//            self.addBorderToProfilePic()
//        }
    }
}

extension SettingsCollectionView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsTableViewCell(style: .default, reuseIdentifier: "cell")
        cell.settingsLabel.text = settingsLabelTexts[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    
}



