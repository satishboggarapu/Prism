//
//  PrismPostDetailViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 4/10/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material

class PrismPostDetailViewController: UIViewController {

    var image: UIImage!
    var imageView: CustomImageView!
    var prismPost: PrismPost!
    var prismPostCell: PrismPostCollectionViewCell!

    private var scrollView: UIScrollView!
    private var backButton: UIButton!
    private var moreButton: UIButton!
    private var profileView: UIView!
    private var profileImage: CustomImageView!
    private var username: UILabel!
    private var postTime: UILabel!
    private var likeButton: UIButton!
    private var repostButton: UIButton!
    private var likesLabel: UILabel!
    private var repostsLabel: UILabel!

    private var lastCollectionViewContentOffset: CGFloat = 0
    private var offset: CGFloat = 0

    var profilePictureSize: CGFloat = 48
    var boldFont: UIFont = RobotoFont.bold(with: 17)
    var mediumFont: UIFont = RobotoFont.light(with: 15)
    var thinFont: UIFont = RobotoFont.thin(with: 12)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .statusBarBackground

        initializeScrollView()
        initializeImageView()
        initializeProfileView()

        scrollView.contentSize = CGSize(width: self.view.frame.width, height: imageView.frame.height + 22)

        initializeBackButton()
        initializeMoreButton()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initializeScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)
    }

    private func initializeImageView() {
        let height = Helper.getImageHeightForPrismPostDetailViewController(image)
        imageView = CustomImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: height)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }

    private func initializeBackButton() {
        backButton = UIButton()
        backButton.setTitle("", for: .normal)
        backButton.setImage(Icon.arrowBack?.tint(with: .white), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)

        view.addConstraintsWithFormat(format: "H:|-4-[v0(40)]", views: backButton)
        view.addConstraintsWithFormat(format: "V:|-24-[v0(40)]", views: backButton)
    }
    
    private func initializeMoreButton() {
        moreButton = UIButton()
        moreButton.setTitle("", for: .normal)
        moreButton.setImage(Icons.MORE_VERTICAL_DOTS_24?.tint(with: .white), for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        view.addSubview(moreButton)
        
        view.addConstraintsWithFormat(format: "H:[v0(40)]-4-|", views: moreButton)
        view.addConstraintsWithFormat(format: "V:|-24-[v0(40)]", views: moreButton)
    }

    private func initializeProfileView() {
        profileView = UIView()
        profileView.frame = CGRect(x: 0, y: imageView.frame.maxY, width: self.view.frame.width, height: 72)
        profileView.backgroundColor = .statusBarBackground
        scrollView.addSubview(profileView)

        initializeProfileImage()
        initializeUsername()
        initializePostTime()
        initializeLikeButton()
        initializeRepostButton()
        initializeLikesLabel()
        initializeRepostsLabel()

        let buttonStackViewWidth: CGFloat = 92

        let labelStackView = UIStackView()
        let width = self.view.frame.width - profileImage.frame.maxX - buttonStackViewWidth - 24
        labelStackView.frame = CGRect(x: profileImage.frame.maxX + 8, y: 12, width: width, height: 40)
        labelStackView.alignment = .top
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        profileView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(username)
        labelStackView.addArrangedSubview(postTime)

        let buttonStackView = UIStackView()
        buttonStackView.frame = CGRect(x: labelStackView.frame.maxX + 8, y: 10, width: buttonStackViewWidth, height: 36)
        buttonStackView.alignment = .top
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        profileView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(repostButton)

        let countsStackView = UIStackView()
        countsStackView.frame = CGRect(x: buttonStackView.frame.origin.x, y: buttonStackView.frame.maxY, width: buttonStackViewWidth, height: 20)
        countsStackView.alignment = .top
        countsStackView.axis = .horizontal
        countsStackView.distribution = .fillEqually
        countsStackView.spacing = 10
        profileView.addSubview(countsStackView)
        countsStackView.addArrangedSubview(likesLabel)
        countsStackView.addArrangedSubview(repostsLabel)

    }

    private func initializeProfileImage() {
        profileImage = CustomImageView()
        profileImage.frame = CGRect(x: 8, y: 8, width: profilePictureSize, height: profilePictureSize)
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profilePictureSize/2
        profileImage.clipsToBounds = true
        profileView.addSubview(profileImage)

        loadProfileImage()
    }

    private func initializeUsername() {
        username = UILabel()
        username.textColor = .white
        username.font = boldFont
        username.text = prismPost.getPrismUser().getUsername()
    }

    private func initializePostTime() {
        postTime = UILabel()
        postTime.textColor = .white
        postTime.font = thinFont
        postTime.text = Helper.getFancyDateDifferenceString(time: prismPost.getTimestamp() * -1)
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

    private func initializeLikesLabel() {
        likesLabel = UILabel()
        likesLabel.textColor = .white
        likesLabel.font = mediumFont
        likesLabel.textAlignment = .center
        likesLabel.text = String(prismPost.getLikes())

        toggleLikeButton()
    }

    private func initializeRepostsLabel() {
        repostsLabel = UILabel()
        repostsLabel.textColor = .white
        repostsLabel.font = mediumFont
        repostsLabel.textAlignment = .center
        repostsLabel.text = String(prismPost.getReposts())

        toggleRepostButton()
    }


    
    @objc func backButtonAction() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreButtonAction() {
        let moreDialog = MoreDialog(prismPost: prismPost)
        moreDialog.delegate = self
        moreDialog.providesPresentationContextTransitionStyle = true
        moreDialog.definesPresentationContext = true
        moreDialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        moreDialog.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(moreDialog, animated: true, completion: nil)
    }

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

    private func addBorderToProfilePic() {
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
    }

    public func toggleLikeButton() {
        likeButton.isSelected = CurrentUser.hasLiked(prismPost)
        likeButton.tintColor = (likeButton.isSelected) ? UIColor.materialBlue : UIColor.white
    }

    public func toggleRepostButton() {
        repostButton.isSelected = CurrentUser.hasReposted(prismPost)
        repostButton.tintColor = (repostButton.isSelected) ? UIColor.materialBlue : UIColor.white
    }

    @objc func likesButtonAction(_ sender: UIButton) {
        animateLikeButton()
        if CurrentUser.hasLiked(prismPost) {
            DatabaseAction.performUnlike(prismPost)
            CurrentUser.unlikePost(prismPost)
            prismPostCell.prismPost.setLikes(likes: prismPost.getLikes()-1)
        } else {
            DatabaseAction.performLike(prismPost)
            CurrentUser.likePost(prismPost)
            prismPostCell.prismPost.setLikes(likes: prismPost.getLikes()+1)
        }
        prismPostCell.toggleLikeButton()
        prismPostCell.setLikesText()
        likesLabel.text = String(prismPost.getLikes())
    }

    @objc func repostButtonAction(_ sender: UIButton) {
        if !CurrentUser.hasReposted(prismPost) {
            let alertController = CustomAlertDialog(title: Default.REPOST_MESSAGE, cancelButtonText: Default.BUTTON_CANCEL, okayButtonText: Default.BUTTON_REPOST)
            alertController.okayButton.addTarget(self, action: #selector(repostAlertDialogButtonAction), for: .touchUpInside)
            alertController.providesPresentationContextTransitionStyle = true
            alertController.definesPresentationContext = true
            alertController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            alertController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            present(alertController, animated: true, completion: nil)
        } else {
            animateRepostButton()
            // repost post
            DatabaseAction.performUnrepost(prismPost)
            CurrentUser.unrepostPost(prismPost)
            prismPostCell.prismPost.setReposts(reposts: prismPost.getReposts() - 1)
            repostsLabel.text = String(prismPost.getReposts())

            prismPostCell.toggleRepostButton()
            prismPostCell.setRepostsText()
        }
    }

    @objc func repostAlertDialogButtonAction() {
        animateRepostButton()
        // unrepost post
        DatabaseAction.performRepost(prismPost)
        CurrentUser.repostPost(prismPost)
        prismPostCell.prismPost.setReposts(reposts: prismPost.getReposts() + 1)
        repostsLabel.text = String(prismPost.getReposts())

        prismPostCell.toggleRepostButton()
        prismPostCell.setRepostsText()
    }

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

}

extension PrismPostDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y

        if self.lastCollectionViewContentOffset > scrollView.contentOffset.y {
            // scrolled up
//            if offset < 50 {
//                profileView.frame = CGRect(x: 0, y: (imageView.frame.maxY - 10), width: self.view.frame.width, height: 72)
//            }
        } else if self.lastCollectionViewContentOffset < scrollView.contentOffset.y {
            // scrolled down
//            if offset > scrollView.contentSize.height - self.view.frame.height - 20 - 30 {
//                profileView.frame.origin = CGPoint(x: 0, y: imageView.frame.maxY + offset)
//            }
            if offset < 54 && profileView != nil {
                profileView.frame = CGRect(x: 0, y: (imageView.frame.maxY - offset), width: self.view.frame.width, height: 72)
            }
        }
        self.lastCollectionViewContentOffset = scrollView.contentOffset.y
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if profileView != nil {
            UIView.animate(withDuration: 0.25, animations: {
                self.profileView.frame = CGRect(x: 0, y: (self.imageView.frame.maxY - 53), width: self.view.frame.width, height: 72)
            })
        }
    }
}

extension PrismPostDetailViewController: MoreDialogDelegate {
    func moreDialogReportButtonAction() {

    }

    func moreDialogShareButtonAction() {

    }

    func moreDialogDeleteButtonAction() {
//        DatabaseAction.deletePost(prismPost, completionHandler: { (result) in
//            if result {
//                self.delegate?.deletePost(self.prismPost)
//            }
//        })
    }
}

extension PrismPostDetailViewController: ZoomingViewController {

    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }

    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> CustomImageView? {
        return imageView
    }

}
