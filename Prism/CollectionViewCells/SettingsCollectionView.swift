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
    var profilePictureSize: CGFloat = PrismPostConstraints.PROFILE_PICTURE_HEIGHT.rawValue
    var boldFont: UIFont = RobotoFont.bold(with: 17)
    var mediumFont: UIFont = RobotoFont.light(with: 15)
    var thinFont: UIFont = RobotoFont.thin(with: 12)
    
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
        // Set Profile View
        let topRightView = UIView()
        topRightView.addSubview(fullName)
        topRightView.addSubview(viewYourProfileText)
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": fullName]))
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": viewYourProfileText]))
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": fullName, "v1": viewYourProfileText]))
        profileView.addSubview(profileImage)
        profileView.addSubview(topRightView)
        profileView.addConstraintsWithFormat(format: "H:|[v0(\(profilePictureSize))]-8-[v1]|", views: profileImage, topRightView)
        profileView.addConstraintsWithFormat(format: "V:|[v0(\(profilePictureSize))]|", views: profileImage)
        profileView.addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: topRightView)
        profileView.backgroundColor = UIColor(hex: 0x1a1a1a)
        self.addSubview(profileView)
        addConstraintsWithFormat(format: "H:[v0]", views: profileView)
        addConstraint(NSLayoutConstraint(item: profileView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
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
        fullName.font = boldFont
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

