//
//  LikesAndRepostsTableViewCell.swift
//  Prism
//
//  Created by Shiv Shah on 5/27/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit
import Material
import MaterialComponents


//protocol NotificationsTableViewCellDelegate: class {
//    func postImageSelected(_ prismPost: PrismPost)
//    func profileViewSelected(_ prismPost: PrismPost)
//}

class LikesAndRepostsTableViewCell: TableViewCell {
    
    
    private var prismUserProfilePicture: CustomImageView!
    private var profilePictureSize: CGFloat = PrismPostConstraints.PROFILE_PICTURE_HEIGHT.rawValue
    var fullName: UILabel!
    var userName: UILabel!
    var followersButton: MDCFlatButton!
    
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
        initializePrismUserProfilePicture()
        initializeFullName()
        initializeUserName()
        initializeFollowersButton()

        // Set Profile View
        let topRightView = UIStackView()
        topRightView.alignment = .top
        topRightView.distribution = .fillEqually
        topRightView.axis = .vertical
        topRightView.addArrangedSubview(userName)
        topRightView.addArrangedSubview(fullName)

        
        let separatorLine = UIImageView()
        separatorLine.backgroundColor = .white
        let separatorLineHeight = 0.25
        
        contentView.addSubview(separatorLine)
        contentView.addSubview(prismUserProfilePicture)
        contentView.addSubview(topRightView)
        contentView.addSubview(followersButton)

        contentView.addConstraintsWithFormat(format: "V:|-8-[v0(48)]-7-[v1(\(separatorLineHeight))]|", views: prismUserProfilePicture, separatorLine)
        contentView.addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: topRightView)
        contentView.addConstraintsWithFormat(format: "V:|-24-[v0]-24-|", views: followersButton)

        contentView.addConstraintsWithFormat(format: "H:|-8-[v0(48)]-16-[v1]-[v2]-8-|", views: prismUserProfilePicture, topRightView, followersButton)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorLine)
    

        contentView.backgroundColor = .collectionViewBackground
    }
    private func initializePrismUserProfilePicture() {
        prismUserProfilePicture = CustomImageView()
        prismUserProfilePicture.contentMode = .scaleAspectFit
        prismUserProfilePicture.clipsToBounds = true
        prismUserProfilePicture.translatesAutoresizingMaskIntoConstraints = false
        prismUserProfilePicture.tintColor = .white
        prismUserProfilePicture.image = #imageLiteral(resourceName: "ic_magnify_48dp").withRenderingMode(.alwaysTemplate)
        prismUserProfilePicture.layer.cornerRadius = profilePictureSize/2
        self.addBorderToProfilePic()
        prismUserProfilePicture.isUserInteractionEnabled = true
        // tap gesture
        let prismUserProfilePictureTapGesture = UITapGestureRecognizer(target: self, action: #selector(prismUserProfilePictureTapGestureAction(_:)))
        prismUserProfilePicture.addGestureRecognizer(prismUserProfilePictureTapGesture)
        
    }
    
    private func initializeFullName() {
        fullName = UILabel()
        fullName.textColor = UIColor.white
        fullName.font = mediumFont
        fullName.text = "Shiv Shah"
        fullName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initializeUserName() {
        userName = UILabel()
        userName.text = "shivshah"
        userName.textColor = UIColor.white
        userName.font = mediumFont
        userName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addBorderToProfilePic() {
        prismUserProfilePicture.layer.borderWidth = 1
        prismUserProfilePicture.layer.borderColor = UIColor.white.cgColor
    }
    
    @objc func prismUserProfilePictureTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Prism User Profile Picture")
    }
    
    private func initializeFollowersButton(){
        followersButton = MDCFlatButton()
        followersButton.setBackgroundColor(UIColor.blue)
        followersButton.setTitle("Follow", for: UIControlState.normal)
        followersButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        followersButton.addTarget(self, action: #selector(followersButtonPressed(sender:)), for: UIControlEvents.touchUpInside)

//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
//        button.center = view.center
//        button.setTitle("Press", for: UIControlState.normal)
//        button.setTitleColor(UIColor.blue, for: UIControlState.normal)
//        button.setTitleColor(UIColor.cyan, for: UIControlState.highlighted)
//        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: UIControlEvents.touchUpInside)
//        view.addSubview(button)
        
    }
    
    @objc func followersButtonPressed(sender: UIButton) {
        sender.setTitle("Pressed", for: UIControlState.normal)
        print("button pressed!!")
    }
    
    
    
}
