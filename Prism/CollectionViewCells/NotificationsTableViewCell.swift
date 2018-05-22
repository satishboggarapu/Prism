//
//  NotificationsTableViewCell.swift
//  Prism
//
//  Created by Shiv Shah on 5/10/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit
import Material


//protocol NotificationsTableViewCellDelegate: class {
//    func postImageSelected(_ prismPost: PrismPost)
//    func profileViewSelected(_ prismPost: PrismPost)
//}

class NotificationsTableViewCell: TableViewCell {
    
    var usernameLabel: UILabel!
    var timeLabel: UILabel!
    var notificationActionLabel: UILabel!
    var andOthersLabel: UILabel!

    var prismPostImage: CustomImageView!
    var prismUserProfilePicture: CustomImageView!

    var prismNotification: PrismNotification!

//    weak var delegate: NotificationsTableViewCellDelegate?



    
    // Font
    var thickFont: UIFont = SourceSansFont.light(with: 16)
    var thinFont: UIFont = SourceSansFont.extraLight(with: 16)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        initializeTimeLabel()
        initializeUsernameLabel()
        initializeAndOthersLabel()
        initializeNotificationActionLabel()
        initializePrismUserProfilePicture()
        initializePrismPostImage()
//        contentView.backgroundColor = UIColor(hex: 0x1a1a1a)
        
        // Set top text view
        let topTextView = UIStackView()
        topTextView.alignment = .top
        topTextView.distribution = .fill
        topTextView.axis = .horizontal
        topTextView.addArrangedSubview(usernameLabel)
        topTextView.addArrangedSubview(andOthersLabel)

        // Set bottom text view
        let bottomTextView = UIStackView()
        bottomTextView.alignment = .top
        bottomTextView.distribution = .fill
        bottomTextView.axis = .horizontal
        bottomTextView.addArrangedSubview(notificationActionLabel)
        bottomTextView.addArrangedSubview(timeLabel)
        
        // Set text View
        let textView = UIStackView()
        textView.alignment = .top
        textView.distribution = .fillEqually
        textView.axis = .vertical
        textView.addArrangedSubview(topTextView)
        textView.addArrangedSubview(bottomTextView)

        contentView.addSubview(textView)
        contentView.addSubview(prismUserProfilePicture)
        contentView.addSubview(prismPostImage)
        contentView.addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: textView)
        contentView.addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: prismUserProfilePicture)
        contentView.addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: prismPostImage)

        contentView.addConstraintsWithFormat(format: "H:|-8-[v0]-8-[v1]-[v2]-8-|", views: prismUserProfilePicture, textView, prismPostImage)


        
        contentView.backgroundColor = .collectionViewBackground
        

        
    }


    
    private func initializeUsernameLabel() {
        usernameLabel = UILabel()
        usernameLabel.textColor = UIColor.white
        usernameLabel.font = thickFont
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = "shivshah"
        usernameLabel.isUserInteractionEnabled = true
        // tap gesture
        let usernameLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(usernameLabelTapGestureAction(_:)))
        usernameLabel.addGestureRecognizer(usernameLabelTapGesture)
        
    }
    
    private func initializeAndOthersLabel() {
        andOthersLabel = UILabel()
        andOthersLabel.textColor = UIColor.white
        andOthersLabel.font = thickFont
        andOthersLabel.translatesAutoresizingMaskIntoConstraints = false
        andOthersLabel.text = " and 2 others"
        //        contentView.addSubview(usernameLabel)
        
        andOthersLabel.isUserInteractionEnabled = true
        // tap gesture
        let andOthersLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(andOthersLabelTapGestureAction(_:)))
        andOthersLabel.addGestureRecognizer(andOthersLabelTapGesture)
        
    }
    
    private func initializeNotificationActionLabel() {
        notificationActionLabel = UILabel()
        notificationActionLabel.textColor = UIColor.white
        notificationActionLabel.font = thinFont
        notificationActionLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationActionLabel.text = "liked • "
//        contentView.addSubview(notificationActionLabel)
        
        notificationActionLabel.isUserInteractionEnabled = true
        // tap gesture
        let notificationActionLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(notificationActionLabelTapGestureAction(_:)))
        notificationActionLabel.addGestureRecognizer(notificationActionLabelTapGesture)
    }
    
    private func initializeTimeLabel() {
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = thinFont
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "2 days ago"
//        contentView.addSubview(timeLabel)
        
        timeLabel.isUserInteractionEnabled = true
        // tap gesture
        let timeLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(timeLabelTapGestureAction(_:)))
        timeLabel.addGestureRecognizer(timeLabelTapGesture)
    }
    
    private func initializePrismPostImage() {
        prismPostImage = CustomImageView()
        prismPostImage.contentMode = .scaleAspectFit
        prismPostImage.clipsToBounds = true
        prismPostImage.translatesAutoresizingMaskIntoConstraints = false
        prismPostImage.isUserInteractionEnabled = true
        prismPostImage.image = #imageLiteral(resourceName: "ic_magnify_48dp").withRenderingMode(.alwaysTemplate)
//        contentView.addSubview(prismPostImage)
        
        prismPostImage.isUserInteractionEnabled = true
        // tap gesture
        let prismPostImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(prismPostImageTapGestureAction(_:)))
        prismPostImage.addGestureRecognizer(prismPostImageTapGesture)
        
    }
    private func initializePrismUserProfilePicture() {
        prismUserProfilePicture = CustomImageView()
        prismUserProfilePicture.contentMode = .scaleAspectFit
        prismUserProfilePicture.clipsToBounds = true
        prismUserProfilePicture.translatesAutoresizingMaskIntoConstraints = false
        prismUserProfilePicture.tintColor = .white
        prismUserProfilePicture.image = #imageLiteral(resourceName: "ic_magnify_48dp").withRenderingMode(.alwaysTemplate)
//        contentView.addSubview(prismUserProfilePicture)
        
        prismUserProfilePicture.isUserInteractionEnabled = true
        // tap gesture
        let prismUserProfilePictureTapGesture = UITapGestureRecognizer(target: self, action: #selector(prismUserProfilePictureTapGestureAction(_:)))
        prismUserProfilePicture.addGestureRecognizer(prismUserProfilePictureTapGesture)
        
    }
    
    // MARK: Setter Methods

//    public func loadProfileImage() {
//        let profilePicture = prismPost.getPrismUser().getProfilePicture().getLowResDefaultProfilePic()
//        if profilePicture != nil {
//            profileImage.image = profilePicture
//        } else {
//            let imageUrl = prismPost.getPrismUser().getProfilePicture().profilePicUriString
//            profileImage.loadImageUsingUrlString(imageUrl, postID: prismPost.getUid())
//            self.addBorderToProfilePic()
//        }
//    }
    
    public func loadPostImage() {
        let imageUrl = prismNotification.getImage()
        let postId = prismNotification.getPostId()
        prismPostImage.loadImageUsingUrlString(imageUrl, postID: postId) { (result, image) in
            if result && self.prismNotification.getNotificationAction() != "followed you • " {
                self.prismPostImage.image = image
            }
        }
    }

    
    
    
    // MARK: Getter Methods

    
    
    // MARK: Tap Gesture Methods

    
    @objc func timeLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Time Label")
    }
    @objc func usernameLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Username Label")
    }
    @objc func andOthersLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on And Others Label")
    }
    @objc func notificationActionLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Notification Action Label")
    }
    @objc func prismPostImageTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Prism Post Image")
    }
    @objc func prismUserProfilePictureTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Prism User Profile Picture")
    }
    
}
