//
// Created by Satish Boggarapu on 3/7/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material

class FeedPostCell: UICollectionViewCell {

    // MARK: UIElements
    var topView: UIView!
    var profilePicture: UIImageView!
    var userName: UILabel!
    var postDate: UILabel!


    var postImage: UIImageView!
    var likes: UILabel!
    var likeButton: UIButton!
    var shareButton: UIButton!
    var moreButton: UIButton!
    var reposts: UILabel!


    var boldFont: UIFont = RobotoFont.bold(with: 17)
    var thinFont: UIFont = RobotoFont.thin(with: 12)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        // topView
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

        

//        self.addSubview(topRightView)
//        addConstraintsWithFormat(format: "H:[v0]", views: topRightView)
//        addConstraintsWithFormat(format: "V:|-16-[v0]", views: topRightView)
//        addConstraint(NSLayoutConstraint(item: topRightView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))


//        initializePostImage()
//        initializeLikes()
//        initializeLikeButton()
//        initializeShareButton()
//        initializeMoreButton()
//        initializeReposts()


    }

    private func initializeProfilePicture() {
        profilePicture = UIImageView()
        profilePicture.image = UIImage(icon: .SPLASH_SCREEN_ICON).withRenderingMode(.alwaysTemplate)
        profilePicture.contentMode = .scaleAspectFit
        profilePicture.layer.cornerRadius = profilePicture.frame.width/2
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.white.cgColor
        profilePicture.clipsToBounds = true
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
//        topView.addSubview(profilePicture)
    }

    private func initializeUserName() {
        userName = UILabel()
        userName.text = "sboggarapu"
        userName.textColor = UIColor.white
        userName.font = boldFont
        userName.translatesAutoresizingMaskIntoConstraints = false
//        topView.addSubview(userName)
    }

    private func initializePostDate() {
        postDate = UILabel()
        postDate.text = "3 days ago"
        postDate.textColor = UIColor.white
        postDate.font = thinFont
        postDate.translatesAutoresizingMaskIntoConstraints = false
//        topView.addSubview(postDate)
    }

    private func initializePostImage() {
        postImage = UIImageView()
        postImage.image = UIImage(icon: .SPLASH_SCREEN_ICON).withRenderingMode(.alwaysTemplate)
        postImage.contentMode = .scaleAspectFill
        postImage.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(postImage)
    }

    private func initializeLikes() {
        likes = UILabel()
        likes.text = "1 like"
        likes.textColor = UIColor.white
        likes.font = thinFont
        likes.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(likes)
    }

    private func initializeLikeButton() {
        likeButton = UIButton()
        likeButton.setImage(UIImage(icon: .SPLASH_SCREEN_ICON), for: .normal)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.setTitle("", for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(likeButton)
    }

    private func initializeShareButton() {
        shareButton = UIButton()
        shareButton.setImage(UIImage(icon: .SPLASH_SCREEN_ICON), for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.setTitle("", for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(shareButton)
    }

    private func initializeMoreButton() {
        moreButton = UIButton()
        moreButton.setImage(UIImage(icon: .SPLASH_SCREEN_ICON), for: .normal)
        moreButton.imageView?.contentMode = .scaleAspectFit
        moreButton.setTitle("", for: .normal)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(moreButton)
    }

    private func initializeReposts() {
        reposts = UILabel()
        reposts.text = "0 reposts"
        reposts.textColor = UIColor.white
        reposts.font = thinFont
        reposts.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(reposts)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}