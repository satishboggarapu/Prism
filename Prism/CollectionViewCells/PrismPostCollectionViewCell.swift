//
// Created by Satish Boggarapu on 3/7/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material
import MaterialComponents
import AVFoundation
import PinLayout

protocol PrismPostCollectionViewCellDelegate: class {
    func deletePost(_ prismPost: PrismPost)
    func postImageSelected(_ prismPost: PrismPost)
    func profileViewSelected(_ prismPost: PrismPost)
}

class PrismPostCollectionViewCell: UICollectionViewCell {

    // MARK: UIElements
    var topRightView: UIView!
    var profileView: UIView!
    var bottomView: UIView!
    var profileImage: CustomImageView!
    var userName: UILabel!
    var postDate: UILabel!
    var postImage: CustomImageView!
    var likes: UILabel!
    var likeButton: UIButton!
    var repostButton: UIButton!
    var moreButton: UIButton!
    var reposts: UILabel!
    var backgroundImageView: UIImageView!
    var blurEffectView: UIVisualEffectView!
    var heartImageView: UIImageView!
    var separatorView: UIView!

    // MARK: Attributes
    weak var delegate: PrismPostCollectionViewCellDelegate?
    var prismPost: PrismPost!

    // Mark: Constraints
    private var profilePictureSize: CGFloat = PrismPostConstraints.PROFILE_PICTURE_HEIGHT.rawValue
    private var buttonSize: CGFloat = PrismPostConstraints.BUTTON_HEIGHT.rawValue
    private var dividerHeight: CGFloat = PrismPostConstraints.DIVIDER_HEIGHT.rawValue
    private var boldFont: UIFont = SourceSansFont.bold(with: 17)
    private var mediumFont: UIFont = SourceSansFont.light(with: 15)
    private var thinFont: UIFont = SourceSansFont.light(with: 12)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let profileViewWidth: CGFloat = profilePictureSize + 8 + userName.intrinsicContentSize.width
        let bottomViewWidth: CGFloat = likes.intrinsicContentSize.width + buttonSize * 3 + 8 * 4
        let imageHeight: CGFloat = frame.height - profilePictureSize - buttonSize - dividerHeight - 8 * 4

        // self
        backgroundImageView.pin.all()
        profileView.pin.hCenter().top(to: edge.top).marginTop(8).height(profilePictureSize).width(profileViewWidth)
        postImage.pin.horizontally().top(to: profileView.edge.bottom).marginHorizontal(8).marginTop(8).height(imageHeight)
        bottomView.pin.hCenter().top(to: postImage.edge.bottom).marginTop(8).width(bottomViewWidth).height(buttonSize)
        separatorView.pin.horizontally().top(to: bottomView.edge.bottom).bottom(to: edge.bottom).marginTop(8).height(dividerHeight)
        heartImageView.pin.hCenter(to: postImage.edge.hCenter).vCenter(to: postImage.edge.vCenter).height(PrismPostConstraints.HEART_IMAGEVIEW_HEIGHT.rawValue).width(PrismPostConstraints.HEART_IMAGEVIEW_HEIGHT.rawValue)
        // backgroundImageView
        blurEffectView.pin.all()
        // profileView
        profileImage.pin.vertically().left(to: profileView.edge.left).height(profilePictureSize).width(profilePictureSize)
        topRightView.pin.vertically().left(to: profileImage.edge.right).right(to: profileView.edge.right).marginVertical(4).marginLeft(8)
        // topRightView
        userName.pin.horizontally().top(to: topRightView.edge.top).sizeToFit()
        postDate.pin.horizontally().top(to: userName.edge.bottom).bottom(to: topRightView.edge.bottom).sizeToFit()
        // bottomView
        likes.pin.vCenter().left(to: bottomView.edge.left).sizeToFit()
        likeButton.pin.vCenter().left(to: likes.edge.right).marginLeft(8).height(buttonSize).width(buttonSize)
        repostButton.pin.vCenter().left(to: likeButton.edge.right).marginLeft(8).height(buttonSize).width(buttonSize)
        moreButton.pin.vCenter().left(to: repostButton.edge.right).marginLeft(8).height(buttonSize).width(buttonSize)
        reposts.pin.vCenter().left(to: moreButton.edge.right).right(to: bottomView.edge.right).sizeToFit()
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
        initializeRepostButton()
        initializeMoreButton()
        initializeReposts()
        initializeSeparatorView()

        // Set Profile View
        topRightView = UIView()
        topRightView.addSubview(userName)
        topRightView.addSubview(postDate)
        profileView.addSubview(profileImage)
        profileView.addSubview(topRightView)

        // Set Bottom View
        bottomView = UIView()
        bottomView.addSubview(likes)
        bottomView.addSubview(likeButton)
        bottomView.addSubview(repostButton)
        bottomView.addSubview(moreButton)
        bottomView.addSubview(reposts)

        // Add elements to the cell view
        addSubview(profileView)
        addSubview(postImage)
        insertSubview(heartImageView, aboveSubview: postImage)
        addSubview(bottomView)
        addSubview(separatorView)
    }


    // MARK: Initializer Methods for UIElements

    private func initializeBackgroundImageView() {
        // cell background
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFit
        insertSubview(backgroundImageView, at: 0)

        // blur effect
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    } 

    private func initializeProfileView() {
        profileView = UIView()
        // tap gesture
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapGestureAction(_:)))
        profileView.addGestureRecognizer(profileTapGesture)
    }

    private func initializeProfilePicture() {
        profileImage = CustomImageView()
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profilePictureSize/2
        profileImage.clipsToBounds = true
    }

    private func initializeUserName() {
        userName = UILabel()
        userName.textColor = UIColor.white
        userName.font = boldFont
    }

    private func initializePostDate() {
        postDate = UILabel()
        postDate.textColor = UIColor.white
        postDate.font = thinFont
    }

    private func initializePostImage() {
        postImage = CustomImageView()
        postImage.contentMode = .scaleAspectFit
        postImage.clipsToBounds = true
        postImage.isUserInteractionEnabled = true

        // tap gesture
        let postImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(postImageTapGestureAction(_:)))
        postImageTapGesture.numberOfTapsRequired = 1
        postImage.addGestureRecognizer(postImageTapGesture)

        let postImageDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(postImageDoubleTapGestureAction(_:)))
        postImageDoubleTapGesture.numberOfTapsRequired = 2
        postImage.addGestureRecognizer(postImageDoubleTapGesture)
    }

    private func initializeHeartImageView() {
        heartImageView = UIImageView()
        heartImageView.image = Icons.LIKE_HEART?.withRenderingMode(.alwaysTemplate)
        heartImageView.tintColor = UIColor.white
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.clipsToBounds = true
        heartImageView.alpha = 0
    }

    private func initializeLikes() {
        likes = UILabel()
        likes.textColor = UIColor.white
        likes.font = mediumFont
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
    }

    private func initializeRepostButton() {
        repostButton = UIButton()
        repostButton.setImage(Icons.REPOST_36?.withRenderingMode(.alwaysTemplate), for: .normal)
        repostButton.imageView?.contentMode = .scaleAspectFit
        repostButton.tintColor = UIColor.white
        repostButton.setTitle("", for: .normal)
        repostButton.addTarget(self, action: #selector(repostButtonAction(_:)), for: .touchUpInside)
    }

    private func initializeMoreButton() {
        moreButton = UIButton()
        moreButton.setImage(Icons.MORE_VERTICAL_DOTS_36?.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.imageView?.contentMode = .scaleAspectFit
        moreButton.tintColor = UIColor.white
        moreButton.setTitle("", for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonAction(_:)), for: .touchUpInside)
    }

    private func initializeReposts() {
        reposts = UILabel()
        reposts.textColor = UIColor.white
        reposts.font = mediumFont
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
        let profilePicture = prismPost.getPrismUser()?.getProfilePicture().getLowResDefaultProfilePic()
        if profilePicture != nil {
            profileImage.image = profilePicture
        } else {
            if let imageUrl = prismPost.getPrismUser()?.getProfilePicture().profilePicUriString {
                profileImage.loadImageUsingUrlString(imageUrl, postID: prismPost.getUid())
                self.addBorderToProfilePic()
            }
        }
    }

    public func loadPostImage() {
        let imageUrl = prismPost.getImage()
        let postId = prismPost.getPostId()
        postImage.loadImageUsingUrlString(imageUrl, postID: postId!) { (result, image) in
            if result {
                self.backgroundImageView.image = image
            }
        }
    }

    public func setUsernameText() {
        userName.text = prismPost.getPrismUser()?.getUsername()
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
    
    public func toggleRepostButton() {
        repostButton.isSelected = CurrentUser.hasReposted(prismPost)
        repostButton.tintColor = (repostButton.isSelected) ? UIColor.materialBlue : UIColor.white
    }

    private func addBorderToProfilePic() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
    }


    // MARK: Getter Methods




    // MARK: Tap Gesture Methods

    @objc func profileTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("profileTapGesture")
        delegate?.profileViewSelected(prismPost)
    }

    @objc func postImageTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Post Image View")
        delegate?.postImageSelected(prismPost)
    }

    @objc func postImageDoubleTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Double Tapped on Post Image View")
    }

    @objc func likesLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Likes Label")
    }

    @objc func repostsLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Reposts Label")
    }

    @objc func likesButtonAction(_ sender: UIButton) {
        // TODO; Disable user interaction while animating so the user doesnt spam  the button and make a lot of firebase requests
        // TODO: Scale down the heartImageView so that is looks good for panorama pictures also
        animateLikeButton()
        animateHeartImageView(isSelected: !sender.isSelected)
        // TODO: Likes Backend
//        if CurrentUser.hasLiked(prismPost) {
//            DatabaseAction.performUnlike(prismPost)
//            CurrentUser.unlikePost(prismPost)
//            prismPost.setLikes(likes: prismPost.getLikes()-1)
//        } else {
//            DatabaseAction.performLike(prismPost)
//            CurrentUser.likePost(prismPost)
//            prismPost.setLikes(likes: prismPost.getLikes()+1)
//        }
//        setLikesText()
    }

    @objc func repostButtonAction(_ sender: UIButton) {
        if !CurrentUser.hasReposted(prismPost) {
            let alertController = CustomAlertDialog(title: Default.REPOST_MESSAGE, cancelButtonText: Default.BUTTON_CANCEL, okayButtonText: Default.BUTTON_REPOST)
            alertController.okayButton.addTarget(self, action: #selector(repostAlertDialogButtonAction), for: .touchUpInside)
            alertController.providesPresentationContextTransitionStyle = true
            alertController.definesPresentationContext = true
            alertController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            alertController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            animateRepostButton()
            // repost post
            // TODO: Repost Backend
//            DatabaseAction.performUnrepost(prismPost)
//            CurrentUser.unrepostPost(prismPost)
//            prismPost.setReposts(reposts: prismPost.getReposts() - 1)
//            setRepostsText()
        }

    }

    @objc func repostAlertDialogButtonAction() {
        animateRepostButton()
        // unrepost post
        // TODO: Repost Backend
//        DatabaseAction.performRepost(prismPost)
//        CurrentUser.repostPost(prismPost)
//        prismPost.setReposts(reposts: prismPost.getReposts() + 1)
//        setRepostsText()
    }

    @objc func moreButtonAction(_ sender: UIButton) {
        animateMoreButton()

        let moreDialog = MoreDialog(prismPost: prismPost)
        moreDialog.delegate = self
        moreDialog.providesPresentationContextTransitionStyle = true
        moreDialog.definesPresentationContext = true
        moreDialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        moreDialog.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.window?.rootViewController?.present(moreDialog, animated: true, completion: nil)
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
            heartImageView.image = Icons.LIKE_HEART?.withRenderingMode(.alwaysTemplate)
        } else {
            heartImageView.image = Icons.UNLIKE_HEART?.withRenderingMode(.alwaysTemplate)
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

    private func animateRepostButton() {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.repostButton.isSelected = !self.repostButton.isSelected
            self.repostButton.tintColor = (self.repostButton.isSelected) ? UIColor.materialBlue : UIColor.white
        })

        let scaleAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation1.fromValue = 1
        scaleAnimation1.toValue = 0
        scaleAnimation1.beginTime = CACurrentMediaTime()
        scaleAnimation1.duration = 0.1
        scaleAnimation1.isRemovedOnCompletion = true
        scaleAnimation1.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        repostButton.layer.add(scaleAnimation1, forKey: "scaleAnimation1")
        CATransaction.commit()

        let scaleAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation2.fromValue = 0
        scaleAnimation2.toValue = 1
        scaleAnimation2.beginTime = CACurrentMediaTime() + 0.1
        scaleAnimation2.duration = 0.1
        scaleAnimation2.isRemovedOnCompletion = true
        scaleAnimation2.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        self.repostButton.layer.add(scaleAnimation2, forKey: "scaleAnimation2")

        let scaleAnimation3: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation3.fromValue = 1
        scaleAnimation3.toValue = 0.75
        scaleAnimation3.beginTime = CACurrentMediaTime() + 0.2
        scaleAnimation3.duration = 0.1
        scaleAnimation3.isRemovedOnCompletion = true
        scaleAnimation3.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        self.repostButton.layer.add(scaleAnimation3, forKey: "scaleAnimation3")

        let scaleAnimation4: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation4.fromValue = 0.75
        scaleAnimation4.toValue = 1
        scaleAnimation4.beginTime = CACurrentMediaTime() + 0.3
        scaleAnimation4.duration = 0.1
        scaleAnimation4.isRemovedOnCompletion = true
        scaleAnimation4.timingFunction = CAMediaTimingFunction(controlPoints: 0.34, 0.01, 0.69, 1.37)
        self.repostButton.layer.add(scaleAnimation4, forKey: "scaleAnimation4")
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

extension PrismPostCollectionViewCell: MoreDialogDelegate {
    func moreDialogReportButtonAction() {
        // TODO: Report Button Action
    }

    func moreDialogShareButtonAction() {
        // TODO: Share Button Action
    }

    func moreDialogDeleteButtonAction() {
        DatabaseAction.deletePost(prismPost, completionHandler: { (result) in
            if result {
                self.delegate?.deletePost(self.prismPost)
            }
        })
    }
}
