//
// Created by Satish Boggarapu on 3/7/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

// Image - max height 60%
//       - max width 90%

import UIKit
import Material

class FeedPostCell: UICollectionViewCell {

    // MARK: UIElements
    var profilePicture: UIImageView!
    var userName: UILabel!
    var postDate: UILabel!
    var postImage: UIImageView!
    var likes: UILabel!
    var likeButton: UIButton!
    var shareButton: UIButton!
    var moreButton: UIButton!
    var reposts: UILabel!

    var heartImageView: UIImageView!

    // MARK: UIViews
    var topView: UIView!

    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.collectionViewCellDivider
        return view
    }()


    var profilePictureSize: CGFloat = 48
    var buttonSize: CGFloat = 28
    var boldFont: UIFont = RobotoFont.bold(with: 17)
    var mediumFont: UIFont = RobotoFont.light(with: 15)
    var thinFont: UIFont = RobotoFont.thin(with: 12)
    let imageMaxWidth: CGFloat = Constraints.screenWidth() * 0.9
    let imageMaxHeight: CGFloat = Constraints.screenHeight() * 0.6

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        // topView
        // TODO: Set tag for the view
        topView = UIView()

        let topRightView = UIView()

        initializeProfilePicture()
        initializeUserName()
        initializePostDate()

        topRightView.addSubview(userName)
        topRightView.addSubview(postDate)
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": userName]))
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": postDate]))
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": userName, "v1": postDate]))

        topView.addSubview(profilePicture)
        topView.addSubview(topRightView)
        topView.addConstraintsWithFormat(format: "H:|[v0(\(profilePictureSize))]-8-[v1]|", views: profilePicture, topRightView)
        topView.addConstraintsWithFormat(format: "V:|[v0(\(profilePictureSize))]|", views: profilePicture)
        topView.addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: topRightView)

        initializePostImage()

        initializeLikes()
        initializeLikeButton()
        initializeShareButton()
        initializeMoreButton()
        initializeReposts()
        let bottomView = UIView()
        bottomView.addSubview(likes)
        bottomView.addSubview(likeButton)
        bottomView.addSubview(shareButton)
        bottomView.addSubview(moreButton)
        bottomView.addSubview(reposts)
        bottomView.addConstraintsWithFormat(format: "V:|[v0]|", views: likes)
        bottomView.addConstraintsWithFormat(format: "V:|[v0(\(buttonSize))]|", views: likeButton)
        bottomView.addConstraintsWithFormat(format: "V:|[v0(\(buttonSize))]|", views: shareButton)
        bottomView.addConstraintsWithFormat(format: "V:|[v0(\(buttonSize))]|", views: moreButton)
        bottomView.addConstraintsWithFormat(format: "V:|[v0]|", views: reposts)
        bottomView.addConstraintsWithFormat(format: "H:|[v0]-16-[v1(\(buttonSize))]-8-[v2(\(buttonSize))]-8-[v3(\(buttonSize))]-16-[v4]|", views: likes, likeButton, shareButton, moreButton, reposts)

        self.addSubview(topView)
        self.addSubview(postImage)
        self.insertSubview(heartImageView, aboveSubview: postImage)
        self.addSubview(bottomView)
        self.addSubview(separatorView)
        
        addConstraintsWithFormat(format: "H:[v0]", views: topView)
        addConstraint(NSLayoutConstraint(item: topView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:|[v0]|", views: postImage)
        addConstraint(NSLayoutConstraint(item: postImage, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:[v0(100)]", views: heartImageView)
        addConstraint(NSLayoutConstraint(item: heartImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "V:[v0(100)]", views: heartImageView)
        addConstraint(NSLayoutConstraint(item: heartImageView, attribute: .centerY, relatedBy: .equal, toItem: postImage, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:[v0]", views: bottomView)
        addConstraint(NSLayoutConstraint(item: bottomView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        addConstraintsWithFormat(format: "V:|-16-[v0]-16-[v1(<=\(imageMaxHeight))]-16-[v2]-16-[v3(1)]|", views: topView, postImage, bottomView, separatorView)

//        // tap gesture for likesLabel
//        let likesTapGesture = UITapGestureRecognizer(target: self, action: #selector(likesLabelTapGestureAction(_:)))
//        likes.addGestureRecognizer(likesTapGesture)

    }

    private func initializeProfilePicture() {
        profilePicture = UIImageView()
        profilePicture.image = UIImage(icon: .SPLASH_SCREEN_ICON)
        profilePicture.contentMode = .scaleAspectFit
        profilePicture.layer.cornerRadius = profilePictureSize/2
        profilePicture.clipsToBounds = true
        profilePicture.translatesAutoresizingMaskIntoConstraints = false

        // border code
//        profilePicture.layer.borderWidth = 2
//        profilePicture.layer.borderColor = UIColor.white.cgColor
    }

    private func initializeUserName() {
        userName = UILabel()
        userName.text = "sboggarapu"
        userName.textColor = UIColor.white
        userName.font = boldFont
        userName.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initializePostDate() {
        postDate = UILabel()
        postDate.text = "3 days ago"
        postDate.textColor = UIColor.white
        postDate.font = thinFont
        postDate.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initializePostImage() {
        postImage = UIImageView()
//        postImage.image = UIImage(icon: .SPLASH_SCREEN_ICON)
        postImage.image = UIImage(named: "image1.jpeg")
        postImage.contentMode = .scaleAspectFit
        postImage.clipsToBounds = true
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.isUserInteractionEnabled = true

        heartImageView = UIImageView()
        heartImageView.image = UIImage(icon: .LIKE_FILL_36).withRenderingMode(.alwaysTemplate)
        heartImageView.tintColor = UIColor.white
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.clipsToBounds = true
        heartImageView.alpha = 0

    }

    private func initializeLikes() {
        likes = UILabel()
        likes.text = "1 like"
        likes.textColor = UIColor.white
        likes.font = mediumFont
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.isUserInteractionEnabled = true
//        self.addSubview(likes)
    }

    private func initializeLikeButton() {
        likeButton = UIButton()
        likeButton.setImage(UIImage(icon: .LIKE_OUTLINE_36).withRenderingMode(.alwaysTemplate), for: .normal)
        likeButton.setImage(UIImage(icon: .LIKE_FILL_36).withRenderingMode(.alwaysTemplate), for: .selected)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.tintColor = UIColor.white
//        likeButton.imageView.tintC
        likeButton.setTitle("", for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(likeButton)
    }

    private func initializeShareButton() {
        shareButton = UIButton()
        shareButton.setImage(UIImage(icon: .SPLASH_SCREEN_ICON).withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.tintColor = UIColor.white
        shareButton.setTitle("", for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(shareButton)
    }

    private func initializeMoreButton() {
        moreButton = UIButton()
        moreButton.setImage(UIImage(icon: .MORE_VERTICAL_DOTS_36).withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.imageView?.contentMode = .scaleAspectFit
        moreButton.tintColor = UIColor.white
        moreButton.setTitle("", for: .normal)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(moreButton)
    }

    private func initializeReposts() {
        reposts = UILabel()
        reposts.text = "0 reposts"
        reposts.textColor = UIColor.white
        reposts.font = mediumFont
        reposts.translatesAutoresizingMaskIntoConstraints = false
        reposts.isUserInteractionEnabled = true
//        self.addSubview(reposts)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getImageSize(image: UIImage) {

    }

}