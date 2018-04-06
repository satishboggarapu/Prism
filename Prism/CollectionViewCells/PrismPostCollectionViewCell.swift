//
// Created by Satish Boggarapu on 3/7/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material
import AVFoundation

class PrismPostCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    var profileView: UIView!
    var bottomView: UIView!
    var profileImage: CustomImageView!
    var userName: UILabel!
    var postDate: UILabel!
    var postImage: CustomImageView!
    var likes: UILabel!
    var likeButton: UIButton!
    var shareButton: UIButton!
    var moreButton: UIButton!
    var reposts: UILabel!
    var backgroundImageView = UIImageView()
    var heartImageView: UIImageView!
    var separatorView: UIView!

    // MARK: Attributes
    var viewController = MainViewController()
    var prismPost: PrismPost!
    var isPostLiked: Bool!
    var isPostReposted: Bool!
    var shouldDisplayBorderForProfilePic: Bool = false

    // Mark: Constraints
    var cellVerticalConstraint: [NSLayoutConstraint]!
    var topMargin: CGFloat = PrismPostConstraints.TOP_MARGIN.rawValue
    var defaultMargin: CGFloat = PrismPostConstraints.DEFAULT_MARGIN.rawValue
    var profilePictureSize: CGFloat = PrismPostConstraints.PROFILE_PICTURE_HEIGHT.rawValue
    var buttonSize: CGFloat = PrismPostConstraints.BUTTON_HEIGHT.rawValue
    var dividerHeight: CGFloat = PrismPostConstraints.DIVIDER_HEIGHT.rawValue
    var boldFont: UIFont = RobotoFont.bold(with: 17)
    var mediumFont: UIFont = RobotoFont.light(with: 15)
    var thinFont: UIFont = RobotoFont.thin(with: 12)
    let imageMaxWidth: CGFloat = PrismPostConstraints.IMAGE_MAX_WIDTH
    let imageMaxHeight: CGFloat = PrismPostConstraints.IMAGE_MAX_HEIGHT
    let leftMargin: CGFloat = PrismPostConstraints.LEFT_MARGIN


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Initialize all UIElements
        initializeBackgroundImageView()
        initializeProfileView()
        initializeProfilePicture()
        initializeUserName()
        initializePostDate()
        initializePostImage()
        initializeHeartImageView()
        initializeLikes()
        initializeLikeButton()
        initializeShareButton()
        initializeMoreButton()
        initializeReposts()
        initializeSeparatorView()

        // Set Profile View
        let topRightView = UIView()
        topRightView.addSubview(userName)
        topRightView.addSubview(postDate)
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": userName]))
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": postDate]))
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": userName, "v1": postDate]))
        profileView.addSubview(profileImage)
        profileView.addSubview(topRightView)
        profileView.addConstraintsWithFormat(format: "H:|[v0(\(profilePictureSize))]-\(defaultMargin)-[v1]|", views: profileImage, topRightView)
        profileView.addConstraintsWithFormat(format: "V:|[v0(\(profilePictureSize))]|", views: profileImage)
        profileView.addConstraintsWithFormat(format: "V:|-\(defaultMargin / 2)-[v0]-\(defaultMargin / 2)-|", views: topRightView)

        // Set Bottom View
        bottomView = UIView()
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
        bottomView.addConstraintsWithFormat(format: "H:|[v0]-\(defaultMargin)-[v1(\(buttonSize))]-\(defaultMargin)-[v2(\(buttonSize))]-\(defaultMargin)-[v3(\(buttonSize))]-\(topMargin)-[v4]|", views: likes, likeButton, shareButton, moreButton, reposts)

        // Add elements to the cell view
        self.addSubview(profileView)
        self.addSubview(postImage)
        self.insertSubview(heartImageView, aboveSubview: postImage)
        self.addSubview(bottomView)
        self.addSubview(separatorView)
        addConstraintsWithFormat(format: "H:[v0]", views: profileView)
        addConstraint(NSLayoutConstraint(item: profileView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:|-\(leftMargin)-[v0]-\(leftMargin)-|", views: postImage)
        addConstraint(NSLayoutConstraint(item: postImage, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:[v0(\(PrismPostConstraints.HEART_IMAGEVIEW_HEIGHT.rawValue))]", views: heartImageView)
        addConstraint(NSLayoutConstraint(item: heartImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "V:[v0(\(PrismPostConstraints.HEART_IMAGEVIEW_HEIGHT.rawValue))]", views: heartImageView)
        addConstraint(NSLayoutConstraint(item: heartImageView, attribute: .centerY, relatedBy: .equal, toItem: postImage, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:[v0]", views: bottomView)
        addConstraint(NSLayoutConstraint(item: bottomView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)

        let views: [String: UIView] = ["v0": profileView,
                                      "v1": postImage,
                                      "v2": bottomView,
                                      "v3": separatorView]
        cellVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(topMargin)-[v0]-\(topMargin)-[v1(<=\(imageMaxHeight))]-\(topMargin)-[v2]-\(topMargin)-[v3(\(dividerHeight))]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        addConstraints(cellVerticalConstraint)

    }


    // MARK: Initializer Methods for UIElements

    private func initializeBackgroundImageView() {
        // cell background
        self.insertSubview(backgroundImageView, at: 0)
        addConstraintsWithFormat(format: "H:|[v0]|", views: backgroundImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: backgroundImageView)

        // blur effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
        backgroundImageView.addConstraintsWithFormat(format: "H:|[v0]|", views: blurEffectView)
        backgroundImageView.addConstraintsWithFormat(format: "V:|[v0]|", views: blurEffectView)
    }

    private func initializeProfileView() {
        profileView = UIView()
        // tap gesture
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapGestureAction(_:)))
        profileView.addGestureRecognizer(profileTapGesture)
    }

    private func initializeProfilePicture() {
        profileImage = CustomImageView()
//        profilePicture.image = Icons.SPLASH_SCREEN_ICON
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profilePictureSize/2
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initializeUserName() {
        userName = UILabel()
//        userName.text = "sboggarapu"
        userName.textColor = UIColor.white
        userName.font = boldFont
        userName.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initializePostDate() {
        postDate = UILabel()
//        postDate.text = "3 days ago"
        postDate.textColor = UIColor.white
        postDate.font = thinFont
        postDate.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initializePostImage() {
        postImage = CustomImageView()
//        postImage.image = UIImage(named: "image1.jpeg")
        postImage.contentMode = .scaleAspectFit
        postImage.clipsToBounds = true
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.isUserInteractionEnabled = true

        // tap gesture
        let postImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(postImageTapGestureAction(_:)))
        postImageTapGesture.numberOfTapsRequired = 2
        postImage.addGestureRecognizer(postImageTapGesture)
    }

    private func initializeHeartImageView() {
        heartImageView = UIImageView()
        heartImageView.image = Icons.LIKE_FILL_48?.withRenderingMode(.alwaysTemplate)
        heartImageView.tintColor = UIColor.white
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.clipsToBounds = true
        heartImageView.alpha = 0
    }

    private func initializeLikes() {
        likes = UILabel()
//        likes.text = "1 like"
        likes.textColor = UIColor.white
        likes.font = mediumFont
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.isUserInteractionEnabled = true

        // tap gesture
        let likesTapGesture = UITapGestureRecognizer(target: self, action: #selector(likesLabelTapGestureAction(_:)))
        likes.addGestureRecognizer(likesTapGesture)
    }

    private func initializeLikeButton() {
        likeButton = UIButton()
        likeButton.setImage(Icons.LIKE_OUTLINE_36?.withRenderingMode(.alwaysTemplate), for: .normal)
        likeButton.setImage(Icons.LIKE_FILL_36?.withRenderingMode(.alwaysTemplate), for: .selected)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.tintColor = UIColor.white
        likeButton.setTitle("", for: .normal)
        likeButton.addTarget(self, action: #selector(likesButtonAction(_:)), for: .touchUpInside)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initializeShareButton() {
        shareButton = UIButton()
        shareButton.setImage(Icons.SPLASH_SCREEN_ICON?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.tintColor = UIColor.white
        shareButton.setTitle("", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction(_:)), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initializeMoreButton() {
        moreButton = UIButton()
        moreButton.setImage(Icons.MORE_VERTICAL_DOTS_36?.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.imageView?.contentMode = .scaleAspectFit
        moreButton.tintColor = UIColor.white
        moreButton.setTitle("", for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonAction(_:)), for: .touchUpInside)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func initializeReposts() {
        reposts = UILabel()
//        reposts.text = "0 reposts"
        reposts.textColor = UIColor.white
        reposts.font = mediumFont
        reposts.translatesAutoresizingMaskIntoConstraints = false
        reposts.isUserInteractionEnabled = true

        // tap gesture
        let repostsTapGesture = UITapGestureRecognizer(target: self, action: #selector(repostsLabelTapGestureAction(_:)))
        reposts.addGestureRecognizer(repostsTapGesture)
    }

    private func initializeSeparatorView() {
        separatorView = UIView()
        separatorView.backgroundColor = UIColor.collectionViewCellDivider
    }


    // MARK: Setter Methods

    public func loadProfileImage() {
        let profilePicture = prismPost.getPrismUser().getProfilePicture().getLowResDefaultProfilePic()
        if profilePicture != nil {
            profileImage.image = profilePicture
        } else {
            let imageUrl = prismPost.getPrismUser().getProfilePicture().profilePicUriString
            profileImage.loadImageUsingUrlString(imageUrl, postID: prismPost.getUid())
            self.addBorderToProfilePic()
        }
    }

    public func loadPostImage() {
        let imageUrl = prismPost.getImage()
        let postId = prismPost.getPostId()
        postImage.loadImageUsingUrlString(imageUrl, postID: postId) { (result, image) in
            if result {
                self.backgroundImageView.image = image
            }
        }
    }

    public func setUsernameText() {
        userName.text = prismPost.getPrismUser().getUsername()
    }

    public func setPostDateText() {
        postDate.text = Helper.getFancyDateDifferenceString(time: prismPost.getTimestamp() * -1)
    }

    public func setLikesText() {
        likes.text = Helper.getLikesCountString(count: prismPost.getLikes())
    }

    public func setRepostsText() {
        reposts.text = Helper.getRepostsCountString(count: prismPost.getReposts())
    }

    public func toggleLikeButton() {
        likeButton.isSelected = CurrentUser.hasLiked(prismPost)
        likeButton.tintColor = (likeButton.isSelected) ? UIColor.materialBlue : UIColor.white
    }
    
    public func toggleShareButton() {
        shareButton.isSelected = CurrentUser.hasReposted(prismPost)
        shareButton.tintColor = (shareButton.isSelected) ? UIColor.materialBlue : UIColor.white
    }

    private func addBorderToProfilePic() {
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.white.cgColor
    }


    // MARK: Getter Methods




    // MARK: Tap Gesture Methods

    @objc func profileTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on profile View")
    }

    @objc func postImageTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Post Image View")
    }

    @objc func likesLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Likes Label")
    }

    @objc func repostsLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Reposts Label")
    }

    @objc func likesButtonAction(_ sender: UIButton) {
        print("Tapped on Like Button")
        // TODO; Disable user interaction while animating so the user doesnt spam  the button and make a lot of firebase requests
        // TODO: Scale down the heartImageView so that is looks good for panorama pictures also
        animateLikeButton()
        animateHeartImageView(isSelected: !sender.isSelected)
        // TODO: Attach backend
    }

    @objc func shareButtonAction(_ sender: UIButton) {
        print("Tapped on Share Button")
    }

    @objc func moreButtonAction(_ sender: UIButton) {
        print("Tapped on More Button")
        animateMoreButton()
        // TODO: Popup view
    }

    // MARK: Animation Functions

    private func animateLikeButton() {

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.likeButton.isSelected = !self.likeButton.isSelected
            self.likeButton.tintColor = (self.likeButton.isSelected) ? UIColor.materialBlue : UIColor.white
        })

        let scaleAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation1.fromValue = 1
        scaleAnimation1.toValue = 0
        scaleAnimation1.beginTime = CACurrentMediaTime()
        scaleAnimation1.duration = 0.1
        scaleAnimation1.isRemovedOnCompletion = true
        scaleAnimation1.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        likeButton.layer.add(scaleAnimation1, forKey: "scaleAnimation1")
        CATransaction.commit()

        let scaleAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation2.fromValue = 0
        scaleAnimation2.toValue = 1
        scaleAnimation2.beginTime = CACurrentMediaTime() + 0.1
        scaleAnimation2.duration = 0.1
        scaleAnimation2.isRemovedOnCompletion = true
        scaleAnimation2.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        self.likeButton.layer.add(scaleAnimation2, forKey: "scaleAnimation2")

        let scaleAnimation3: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation3.fromValue = 1
        scaleAnimation3.toValue = 0.75
        scaleAnimation3.beginTime = CACurrentMediaTime() + 0.2
        scaleAnimation3.duration = 0.1
        scaleAnimation3.isRemovedOnCompletion = true
        scaleAnimation3.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        self.likeButton.layer.add(scaleAnimation3, forKey: "scaleAnimation3")

        let scaleAnimation4: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation4.fromValue = 0.75
        scaleAnimation4.toValue = 1
        scaleAnimation4.beginTime = CACurrentMediaTime() + 0.3
        scaleAnimation4.duration = 0.1
        scaleAnimation4.isRemovedOnCompletion = true
        scaleAnimation4.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        self.likeButton.layer.add(scaleAnimation4, forKey: "scaleAnimation4")
    }

    private func animateHeartImageView(isSelected: Bool) {
        if isSelected {
            heartImageView.image = Icons.LIKE_FILL_48?.withRenderingMode(.alwaysTemplate)
        } else {
            heartImageView.image = Icons.LIKE_OUTLINE_48?.withRenderingMode(.alwaysTemplate)
        }
        heartImageView.tintColor = UIColor.white
        heartImageView.alpha = 0.75

        CATransaction.begin()
        CATransaction.setCompletionBlock ({
            UIView.animate(withDuration: 0.1, delay: 0.1, animations: {
                self.heartImageView.alpha = 0
            })
        })
        let scaleAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation1.fromValue = 0.75
        scaleAnimation1.toValue = 1.25
        scaleAnimation1.beginTime = CACurrentMediaTime()
        scaleAnimation1.duration = 0.15
        scaleAnimation1.isRemovedOnCompletion = true
        scaleAnimation1.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        heartImageView.layer.add(scaleAnimation1, forKey: "scaleAnimation1")

        let scaleAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation2.fromValue = 1.25
        scaleAnimation2.toValue = 0.75
        scaleAnimation2.beginTime = CACurrentMediaTime() + 0.15
        scaleAnimation2.duration = 0.15
        scaleAnimation2.isRemovedOnCompletion = true
        scaleAnimation2.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        heartImageView.layer.add(scaleAnimation2, forKey: "scaleAnimation2")

        let scaleAnimation3: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation3.fromValue = 0.75
        scaleAnimation3.toValue = 1.0
        scaleAnimation3.beginTime = CACurrentMediaTime() + 0.3
        scaleAnimation3.duration = 0.1
        scaleAnimation3.isRemovedOnCompletion = true
        scaleAnimation3.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        heartImageView.layer.add(scaleAnimation3, forKey: "scaleAnimation3")
        CATransaction.commit()
    }

    private func animateMoreButton() {
        let scaleAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation1.fromValue = 1.0
        scaleAnimation1.toValue = 0.25
        scaleAnimation1.beginTime = CACurrentMediaTime()
        scaleAnimation1.duration = 0.15
        scaleAnimation1.isRemovedOnCompletion = true
        scaleAnimation1.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        moreButton.layer.add(scaleAnimation1, forKey: "scaleAnimation1")

        let scaleAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation2.fromValue = 0.25
        scaleAnimation2.toValue = 1.25
        scaleAnimation2.beginTime = CACurrentMediaTime() + 0.15
        scaleAnimation2.duration = 0.1
        scaleAnimation2.isRemovedOnCompletion = true
        scaleAnimation2.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        moreButton.layer.add(scaleAnimation2, forKey: "scaleAnimation2")

        let scaleAnimation3: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation3.fromValue = 1.25
        scaleAnimation3.toValue = 0.75
        scaleAnimation3.beginTime = CACurrentMediaTime() + 0.25
        scaleAnimation3.duration = 0.1
        scaleAnimation3.isRemovedOnCompletion = true
        scaleAnimation3.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        moreButton.layer.add(scaleAnimation3, forKey: "scaleAnimation3")

        let scaleAnimation4: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation4.fromValue = 0.75
        scaleAnimation4.toValue = 1.0
        scaleAnimation4.beginTime = CACurrentMediaTime() + 0.35
        scaleAnimation4.duration = 0.05
        scaleAnimation4.isRemovedOnCompletion = true
        scaleAnimation4.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        moreButton.layer.add(scaleAnimation4, forKey: "scaleAnimation4")
    }
}

extension UIImageView {
    public func imageFromURL(urlString: String) {

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            print("getting image")
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                print("setting image")
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })

        }).resume()
    }
}
