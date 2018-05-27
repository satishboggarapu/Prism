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
    var actionIconView: UIImageView!
    var actionImage: UIImage!

    var prismNotification: PrismNotification!
    var profilePictureSize: CGFloat = PrismPostConstraints.PROFILE_PICTURE_HEIGHT.rawValue
    var actionIconSize: CGFloat = 24


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
        initializeActionIcon()
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
        
        let textView = UIStackView()
        textView.alignment = .top
        textView.distribution = .fillEqually
        textView.axis = .vertical
        textView.addArrangedSubview(topTextView)
        textView.addArrangedSubview(bottomTextView)
        
        contentView.addSubview(textView)
        contentView.addSubview(prismUserProfilePicture)
        contentView.addSubview(prismPostImage)
        contentView.addSubview(actionIconView)
        
        let separatorLine = UIImageView()
        separatorLine.backgroundColor = .white
        contentView.addSubview(separatorLine)
        
        contentView.addConstraintsWithFormat(format: "V:|-12-[v0]-12-|", views: textView)
        contentView.addConstraintsWithFormat(format: "V:|-8-[v0(48)]-7-[v1(1)]|", views: prismUserProfilePicture, separatorLine)
        contentView.addConstraintsWithFormat(format: "V:|-8-[v0(48)]-8-|", views: prismPostImage)
        contentView.addConstraintsWithFormat(format: "V:|-36-[v0(24)]-|", views: actionIconView)

        
        contentView.addConstraintsWithFormat(format: "H:|-8-[v0(48)]-8-[v1]-[v2(48)]-8-|", views: prismUserProfilePicture, textView, prismPostImage)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: separatorLine)
        contentView.addConstraintsWithFormat(format: "H:|-36-[v0(24)]-|", views: actionIconView)

        
        
        
        
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
    
    private func initializeActionIcon() {
        actionIconView = UIImageView()
        actionIconView.layer.masksToBounds = false
        actionIconView.contentMode = .center
        actionIconView.layer.backgroundColor = UIColor.black.cgColor
        actionIconView.layer.cornerRadius = actionIconSize/2
        actionIconView.clipsToBounds = true
        actionIconView.layer.borderWidth = 1
        actionIconView.layer.borderColor = UIColor.white.cgColor
        actionIconView.tintColor = .white
        actionIconView.image = #imageLiteral(resourceName: "ic_heart_24dp").withRenderingMode(.alwaysTemplate)



    }
    
    private func initializePrismPostImage() {
        prismPostImage = CustomImageView()
        prismPostImage.contentMode = .scaleAspectFill
        prismPostImage.clipsToBounds = true
        prismPostImage.translatesAutoresizingMaskIntoConstraints = false
        prismPostImage.isUserInteractionEnabled = true
//        prismPostImage.image = #imageLiteral(resourceName: "ic_magnify_48dp").withRenderingMode(.alwaysTemplate)
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
//        prismUserProfilePicture.image = #imageLiteral(resourceName: "ic_magnify_48dp").withRenderingMode(.alwaysTemplate)
        prismUserProfilePicture.layer.cornerRadius = profilePictureSize/2


//        contentView.addSubview(prismUserProfilePicture)
        self.addBorderToProfilePic()
        prismUserProfilePicture.isUserInteractionEnabled = true
        // tap gesture
        let prismUserProfilePictureTapGesture = UITapGestureRecognizer(target: self, action: #selector(prismUserProfilePictureTapGestureAction(_:)))
        prismUserProfilePicture.addGestureRecognizer(prismUserProfilePictureTapGesture)
        
    }
    
    // MARK: Setter Methods

    public func loadProfileImage() {
        let profilePicture = prismNotification.getPrismUser().getProfilePicture().getLowResDefaultProfilePic()
        if profilePicture != nil {
            prismUserProfilePicture.image = profilePicture
        } else {
            prismUserProfilePicture.loadImageUsingUrlString(prismNotification.getPrismUser().getProfilePicture().profilePicUriString, postID: prismNotification.getPrismUser().getUid())
        }
    }
    
    public func loadAndOthers() {
        let notificationQuantity = prismNotification.getPrismPost().getLikes()
        if notificationQuantity == 0{
            andOthersLabel.text = ""
        }
        else if notificationQuantity == 1{
            andOthersLabel.text = " and 1 other"
        }
        else {
            andOthersLabel.text = " and \(notificationQuantity) others"
        }
    }
    
    public func loadPostImage() {
        if prismNotification.getNotificationAction() != "followed you • " {
            let imageUrl = prismNotification.getPrismPost().getImage()
            let postId = prismNotification.getPostId()
            prismPostImage.loadImageUsingUrlString(imageUrl, postID: postId)
        }
    }
    
    private func addBorderToProfilePic() {
        prismUserProfilePicture.layer.borderWidth = 1
        prismUserProfilePicture.layer.borderColor = UIColor.white.cgColor
    }
    
//    public func setActionImage(){
//        let notificationAction = prismNotification.getNotificationAction()
//        if notificationAction.contains("_like"){
//            actionImage = #imageLiteral(resourceName: "ic_heart_24dp").invertedImage()
//        }
//        else if notificationAction.contains("_repost"){
//            actionImage = #imageLiteral(resourceName: "ic_camera_iris_24dp").invertedImage()
//
//        }
//        else if notificationAction.contains("_follow"){
//            actionImage = #imageLiteral(resourceName: "ic_plus_circle_24dp").invertedImage()
//        }
//        actionIconView.image = actionImage
//    }
    

    
    
    
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

extension UIImage {
    func invertedImage() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let ciImage = CoreImage.CIImage(cgImage: cgImage)
        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let context = CIContext(options: nil)
        guard let outputImage = filter.outputImage else { return nil }
        guard let outputImageCopy = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: outputImageCopy)
    }
}
