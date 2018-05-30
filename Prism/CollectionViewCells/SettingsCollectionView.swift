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
    var profileImage: CustomImageView!
    var fullName: UILabel!
    var viewYourProfileText: UILabel!
    var profilePictureSize: CGFloat = 64
    var boldFont: UIFont = SourceSansFont.bold(with: 17)
    var mediumFont: UIFont = SourceSansFont.light(with: 17)
    var thinFont: UIFont = SourceSansFont.extraLight(with: 12)
    var tableView: UITableView!
    var settingsLabelTexts: [String]!
    var settingsPageIcons: [UIImage]!
    
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

        self.addSubview(profileView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: profileView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: tableView)
        tableView.layoutIfNeeded()
        
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-[v1(\(tableView.contentSize.height))]", views: profileView, tableView)
    }
    
    private func initializeProfileView() {
        profileView = UIView()
        profileView.backgroundColor = .statusBarBackground
        profileView.dropShadow()
        // tap gesture
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapGestureAction(_:)))
        profileView.addGestureRecognizer(profileTapGesture)
    }
    
    private func initializeFullName() {
        fullName = UILabel()
        fullName.textColor = UIColor.white
        fullName.font = mediumFont
        setFullName()
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
        addBorderToProfilePic()
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
        tableView.backgroundColor = .statusBarBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.dropShadow()
        addSubview(tableView)
        settingsLabelTexts = ["App Settings", "Notification Settings", "Account Settings", "Help", "About", "Logout"]
        settingsPageIcons = [Icons.SETTINGS_24, Icons.NOTIFICATIONS_24?.withRenderingMode(.alwaysTemplate), Icons.ACCOUNT_SETTINGS_24?.withRenderingMode(.alwaysTemplate), Icons.HELP_24?.withRenderingMode(.alwaysTemplate), Icons.ABOUT_24, Icons.LOGOUT_24?.withRenderingMode(.alwaysTemplate)] as! [UIImage]
    }
    
    @objc func profileTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on profile View")
    }
    
    
    private func loadProfileImage() {
        let profilePicture = CurrentUser.prismUser.getProfilePicture().getLowResDefaultProfilePic()
        print(profilePicture)
        if profilePicture != nil {
            profileImage.image = profilePicture
        } else {
            profileImage.loadImageUsingUrlString(CurrentUser.prismUser.getProfilePicture().profilePicUriString, postID: CurrentUser.prismUser.getUid())
        }
    }
    
    private func addBorderToProfilePic(){
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setFullName(){
        fullName.text = CurrentUser.prismUser.getFullName()
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
        cell.settingsIcon.image = settingsPageIcons[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
    }
}



