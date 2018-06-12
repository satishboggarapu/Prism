//
//  ProfileViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 5/1/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import MaterialComponents
import Material

// TODO: Change view if not current user

public enum ProfileViewType {
    case CURRENT_USER
    case NORMAL_USER
}

class ProfileViewController: UIViewController {

    /**
     *  UIElements
     */
    private var backButton: FABButton!
    private var editAccountButton: FABButton!
    private var profileNavigationView: UIView!
    private var profileView: UIView!
    private var menuBar: ProfileViewMenuBar!
    private var collectionView: UICollectionView!

    /**
     *
     */
    private var profileViewType: ProfileViewType!
    var prismPost: PrismPost!
    private var lastPanGesturePosition: CGPoint!
    private var fadeProfileView: Bool!
    var collectionViewLastContentOffsets: [CGPoint] = [CGPoint(x: -4, y: -4), CGPoint(x: -4, y: -4)]
    private var collectionViewLastRefreshTime: [Date] = [Date().addingTimeInterval(-4), Date().addingTimeInterval(-4)]
    private var cellSize: CGSize!
    private var isRefreshing: [Bool] = [false, false]
    private var timer = Timer()
    var panGesture: UIPanGestureRecognizer!
    
    private var collectionViewSize: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .statusBarBackground
        fadeProfileView = false

        // panGesture inizilization
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture)

        // setup UIElements
        setupNavigationBar()
        initializeProfileView()
        
        if prismPost.getPrismUser().getUid() == CurrentUser.prismUser.getUid() {
            setupViewForCurrentUser()
        } else {
            setupViewForNormalUser()
        }
    }
    
    /**
     *
     */
    private func setupViewForCurrentUser() {
        profileViewType = ProfileViewType.CURRENT_USER
        collectionViewSize = 2
        
        initializeMenuBar()
        initializeCollectionView()
        
        // UIElements constraints
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: profileView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|[v0][v1(50)][v2]|", views: profileView, menuBar, collectionView)
    }
    
    /**
     *
     */
    private func setupViewForNormalUser() {
        profileViewType = ProfileViewType.NORMAL_USER
        collectionViewSize = 1
        
        initializeCollectionView()
        
        // UIElements constraints
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: profileView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|[v0]-[v1]|", views: profileView, collectionView)
    }
    
    /**
     *
     */
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.barTintColor = .statusBarBackground
        
        let buttonContentEdgeInset: CGFloat = 8

        // left button
        backButton = FABButton()
        backButton.backgroundColor = .clear
        backButton.addContentEdgeInset(buttonContentEdgeInset)
        backButton.setTitle("", for: .normal)
        backButton.setImage(Icons.ARROW_BACK_24?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setImage(Icons.ARROW_BACK_24?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        backButton.imageView?.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        // right button
        editAccountButton = FABButton()
        editAccountButton.backgroundColor = .clear
        editAccountButton.addContentEdgeInset(buttonContentEdgeInset)
        editAccountButton.setTitle("", for: .normal)
        editAccountButton.setImage(Icons.ACCOUNT_EDIT_24?.withRenderingMode(.alwaysTemplate), for: .normal)
        editAccountButton.setImage(Icons.ACCOUNT_EDIT_24?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        editAccountButton.imageView?.tintColor = .white
        editAccountButton.addTarget(self, action: #selector(editAccountButtonAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editAccountButton)

        // title view
        profileNavigationView = UIView()
        profileNavigationView.backgroundColor = .clear
        profileNavigationView.alpha = 0.0
        navigationItem.titleView = profileNavigationView

        let profileImage = CustomImageView()
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = 18
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false

        let profilePicture = prismPost.getPrismUser().getProfilePicture().getLowResDefaultProfilePic()
        if profilePicture != nil {
            profileImage.image = profilePicture
        } else {
            let imageUrl = prismPost.getPrismUser().getProfilePicture().profilePicUriString
            profileImage.loadImageUsingUrlString(imageUrl, postID: prismPost.getUid())
            profileImage.layer.borderWidth = 1
            profileImage.layer.borderColor = UIColor.white.cgColor
        }

        let username = UILabel()
        username.textColor = UIColor.white
        username.text = prismPost.getPrismUser().getUsername()
        username.font = SourceSansFont.bold(with: 17)
        username.translatesAutoresizingMaskIntoConstraints = false

        profileNavigationView.addSubview(profileImage)
        profileNavigationView.addSubview(username)

        profileNavigationView.addConstraintsWithFormat(format: "V:[v0(36)]", views: profileImage)
        profileNavigationView.addConstraint(NSLayoutConstraint(item: profileImage, attribute: .centerY, relatedBy: .equal, toItem: profileNavigationView, attribute: .centerY, multiplier: 1, constant: 0))
        profileNavigationView.addConstraintsWithFormat(format: "V:[v0]", views: username)
        profileNavigationView.addConstraint(NSLayoutConstraint(item: username, attribute: .centerY, relatedBy: .equal, toItem: profileNavigationView, attribute: .centerY, multiplier: 1, constant: 0))
        profileNavigationView.addConstraintsWithFormat(format: "H:|-[v0(36)]-[v1]", views: profileImage, username)


    }

    /**
     *
     */
    private func initializeProfileView() {
        profileView = UIView()
        profileView.backgroundColor = .statusBarBackground
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileView)

        let username = UILabel()
        username.text = prismPost.getPrismUser().getUsername()
        username.textColor = .white
        username.font = SourceSansFont.bold(with: 20)
        username.textAlignment = .center
        username.translatesAutoresizingMaskIntoConstraints = false
        profileView.addSubview(username)

        let fullName = UILabel()
        fullName.text = prismPost.getPrismUser().getFullName()
        fullName.textColor = .white
        fullName.font = SourceSansFont.light(with: 15)
        fullName.textAlignment = .center
        fullName.translatesAutoresizingMaskIntoConstraints = false
        profileView.addSubview(fullName)

        let profileImage = CustomImageView()
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = 125/2
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileView.addSubview(profileImage)

        let profilePicture = prismPost.getPrismUser().getProfilePicture().getLowResDefaultProfilePic()
        if profilePicture != nil {
            profileImage.image = profilePicture
        } else {
            let imageUrl = prismPost.getPrismUser().getProfilePicture().profilePicUriString
            profileImage.loadImageUsingUrlString(imageUrl, postID: prismPost.getUid())
            profileImage.layer.borderWidth = 2
            profileImage.layer.borderColor = UIColor.white.cgColor
        }

        let followersCount = UILabel()
        followersCount.text = String(prismPost.getPrismUser().getFollowerCount())
        followersCount.textColor = .white
        followersCount.textAlignment = .center
        followersCount.font = SourceSansFont.bold(with: 16)

        let postsCount = UILabel()
        postsCount.text = "--"
        postsCount.textColor = .white
        postsCount.textAlignment = .center
        postsCount.font = SourceSansFont.bold(with: 16)

        let followingCount = UILabel()
        followingCount.text = String(prismPost.getPrismUser().getFollowingCount())
        followingCount.textColor = .white
        followingCount.textAlignment = .center
        followingCount.font = SourceSansFont.bold(with: 16)

        let followersLabel = UILabel()
        followersLabel.text = "followers"
        followersLabel.textColor = .white
        followersLabel.textAlignment = .center
        followersLabel.font = SourceSansFont.light(with: 14)

        let postsLabel = UILabel()
        postsLabel.text = "posts"
        postsLabel.textColor = .white
        postsLabel.textAlignment = .center
        postsLabel.font = SourceSansFont.light(with: 14)

        let followingLabel = UILabel()
        followingLabel.text = "following"
        followingLabel.textColor = .white
        followingLabel.textAlignment = .center
        followingLabel.font = SourceSansFont.light(with: 14)

        let countView = UIView()
        countView.backgroundColor = .clear
        countView.addSubview(followersCount)
        countView.addSubview(postsCount)
        countView.addSubview(followingCount)
        countView.addConstraintsWithFormat(format: "V:|[v0]|", views: followersCount)
        countView.addConstraintsWithFormat(format: "V:|[v0]|", views: postsCount)
        countView.addConstraintsWithFormat(format: "V:|[v0]|", views: followingCount)
        countView.addConstraintsWithFormat(format: "H:|[v0(\(followersLabel.intrinsicContentSize.width))]-[v1(\(postsLabel.intrinsicContentSize.width))]-[v2(\(followingLabel.intrinsicContentSize.width))]|", views: followersCount, postsCount, followingCount)
        profileView.addSubview(countView)

        let labelView = UIView()
        labelView.backgroundColor = .clear
        labelView.addSubview(followersLabel)
        labelView.addSubview(postsLabel)
        labelView.addSubview(followingLabel)
        labelView.addConstraintsWithFormat(format: "V:|[v0]|", views: followersLabel)
        labelView.addConstraintsWithFormat(format: "V:|[v0]|", views: postsLabel)
        labelView.addConstraintsWithFormat(format: "V:|[v0]|", views: followingLabel)
        labelView.addConstraintsWithFormat(format: "H:|[v0]-[v1]-[v2]|", views: followersLabel, postsLabel, followingLabel)
        profileView.addSubview(labelView)

        profileView.addConstraintsWithFormat(format: "H:|[v0]|", views: username)
        profileView.addConstraintsWithFormat(format: "H:|[v0]|", views: fullName)
        profileView.addConstraintsWithFormat(format: "H:[v0(125)]", views: profileImage)
        profileView.addConstraintsWithFormat(format: "H:[v0]", views: countView)
        profileView.addConstraintsWithFormat(format: "H:[v0]", views: labelView)
        profileView.addConstraintsWithFormat(format: "V:|-[v0]-4-[v1]-[v2(125)]-[v3]-4-[v4]|", views: username, fullName, profileImage, countView, labelView)
        profileView.addConstraint(NSLayoutConstraint(item: profileImage, attribute: .centerX, relatedBy: .equal, toItem: profileView, attribute: .centerX, multiplier: 1, constant: 0))
        profileView.addConstraint(NSLayoutConstraint(item: countView, attribute: .centerX, relatedBy: .equal, toItem: profileView, attribute: .centerX, multiplier: 1, constant: 0))
        profileView.addConstraint(NSLayoutConstraint(item: labelView, attribute: .centerX, relatedBy: .equal, toItem: profileView, attribute: .centerX, multiplier: 1, constant: 0))


    }
    
    /**
     *
     */
    private func initializeMenuBar() {
        menuBar = ProfileViewMenuBar()
        menuBar.homeController = self
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuBar)
    }

    /**
     *
     */
    private func initializeCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(ProfileViewPostsCollectionView.self, forCellWithReuseIdentifier: "posts")
        collectionView?.register(ProfileViewLikesCollectionView.self, forCellWithReuseIdentifier: "likes")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.backgroundColor = .blue
        collectionView?.isPagingEnabled = true
        collectionView?.contentInset = UIEdgeInsets.zero

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView!)
    }

    /**
     *
     */
    @objc private func panGestureAction(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: self.view)
        let visibleCell = collectionView.indexPathsForVisibleItems.first!
        
        switch gesture.state {
            case .began:
                break
            case .changed:
                let gestureOffset = lastPanGesturePosition.y - point.y
                let maxY = profileView.frame.height
                
                if gestureOffset > 0 { // finger moving up
                    // if bar is not at the top then move the bar first
                    if (isPrismUserCurrentUser() && menuBar.frame.origin.y > 0 && collectionViewLastContentOffsets[visibleCell.item].y >=  -4) ||
                        (!isPrismUserCurrentUser() && collectionView.frame.origin.y > 0 && collectionViewLastContentOffsets[visibleCell.item].y >=  -4) {
                        updateMenuBarConstraintsAndProfileViewUI(point)
                    } else {
                        updateCollectionViewScrollInset(point)
                    }
                } else if gestureOffset < 0 {
                    if (isPrismUserCurrentUser() && collectionViewLastContentOffsets[visibleCell.item].y == -4 && menuBar.frame.origin.y < maxY) ||
                        (!isPrismUserCurrentUser() && collectionViewLastContentOffsets[visibleCell.item].y == -4 && collectionView.frame.origin.y < maxY) {
                        updateMenuBarConstraintsAndProfileViewUI(point)
                    } else {
                        updateCollectionViewScrollInset(point)
                    }
                }
            case .ended:
                // refresh control code
                let cell = collectionView.cellForItem(at: visibleCell) as! ProfileViewCollectionView
                var contentOffset = collectionViewLastContentOffsets[visibleCell.item]
                if collectionViewLastContentOffsets[visibleCell.item].y <= -120 {
                    contentOffset = CGPoint(x: -4, y: -60.5)
                    cell.refreshControl.beginRefreshing()
                    cell.reloadData = true
                    cell.isReloadingData = false
                    collectionViewLastRefreshTime[visibleCell.item] = Date()
                    collectionViewLastContentOffsets[visibleCell.item] = CGPoint(x: -4, y: -4)
                } else if collectionViewLastContentOffsets[visibleCell.item].y < -4 {
                    contentOffset = CGPoint(x: -4, y: -4)
                    cell.refreshControl.endRefreshing()
                    collectionViewLastContentOffsets[visibleCell.item] = CGPoint(x: -4, y: -4)
                }
                cell.collectionView.setContentOffset(contentOffset, animated: true)
            default:
                break
        }
        lastPanGesturePosition = point
    }
    
    /**
     *
     */
    private func updateMenuBarConstraintsAndProfileViewUI(_ point: CGPoint) {
        var offset = lastPanGesturePosition.y - point.y
        var newY = collectionView.frame.origin.y - offset
        if isPrismUserCurrentUser() {
            newY = menuBar.frame.origin.y - offset
        }
        let maxY = profileView.frame.height
        if offset > 0 && newY < 0 {
            offset += newY
        } else if offset < 0 && newY > maxY {
            offset -= maxY - newY
        }
        if isPrismUserCurrentUser() { menuBar.frame.origin.y -= offset }
        collectionView.frame.origin.y -= offset
        profileView.frame.origin.y -= offset/2
        if offset > 0 && ((isPrismUserCurrentUser() && collectionView.frame.height < view.frame.height-50) || (!isPrismUserCurrentUser() && collectionView.frame.height < view.frame.height)){
            collectionView.frame.size.height += offset
            collectionView.collectionViewLayout.invalidateLayout()
        }
        
        let alpha = 1 - (newY/maxY)
        profileNavigationView.alpha = alpha
        
        if newY <= 50 && !fadeProfileView {
            fadeProfileView = true
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.profileView.alpha = 0
            }, completion: nil)
        } else if newY > 50 && fadeProfileView {
            fadeProfileView = false
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.profileView.alpha = 1
            }, completion: nil)
        }
    }
    
    /**
     *
     */
    private func updateCollectionViewScrollInset(_ point: CGPoint) {
        let gestureOffset = lastPanGesturePosition.y - point.y
        let visibleCell = collectionView.indexPathsForVisibleItems.first!
        let cell = collectionView.cellForItem(at: visibleCell) as! ProfileViewCollectionView
        let collectionViewHeight = collectionView.frame.height
        let maxOffset = cell.collectionView.contentSize.height - collectionViewHeight + 4
        let newContentOffsetY = collectionViewLastContentOffsets[visibleCell.item].y + gestureOffset
        let maxY = profileView.frame.height
        var contentOffset = collectionViewLastContentOffsets[visibleCell.item]
        if gestureOffset < 0 && !cell.isReloadingData {
            if (isPrismUserCurrentUser() && (menuBar.frame.origin.y == 0 || menuBar.frame.origin.y < maxY)) ||
                (!isPrismUserCurrentUser() && (collectionView.frame.origin.y == 0 || collectionView.frame.origin.y < maxY)) {
                contentOffset.y = (newContentOffsetY < -4) ? -4 : newContentOffsetY
            } else if isGesutreInsideCollectionView(point) && isLastRefreshMoreThenFourSeconds(visibleCell.item) {
                contentOffset.y = newContentOffsetY
            }
        } else if gestureOffset > 0 && cell.collectionView.contentSize.height > collectionViewHeight {
            contentOffset.y = (newContentOffsetY > maxOffset) ? maxOffset : newContentOffsetY
            if contentOffset.y > -4 && ((isPrismUserCurrentUser() && menuBar.frame.origin.y == maxY) ||
                                        (!isPrismUserCurrentUser() && collectionView.frame.origin.y == maxY)) {
                contentOffset.y = -4
            }
        } else if gestureOffset > 0 && contentOffset.y < -4 {
            contentOffset.y = (newContentOffsetY < -4) ? newContentOffsetY : -4
        }
        cell.collectionView.setContentOffset(contentOffset, animated: false)
        collectionViewLastContentOffsets[visibleCell.item] = contentOffset
    }

    /**
     *
     */
    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }

    /**
     *
     */
    @objc private func editAccountButtonAction() {

    }
    
    /**
     *
     */
    private func isGesutreInsideCollectionView(_ point: CGPoint) -> Bool {
        return point.y > collectionView.frame.origin.y
    }
    
    /**
     *
     */
    private func isLastRefreshMoreThenFourSeconds(_ index: Int) -> Bool {
        return Date().seconds(from: collectionViewLastRefreshTime[index]) >= 4
    }
    
    private func isPrismUserCurrentUser() -> Bool {
        return profileViewType == ProfileViewType.CURRENT_USER
    }

}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if profileViewType == ProfileViewType.CURRENT_USER {
            menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if profileViewType == ProfileViewType.CURRENT_USER {
            let index = targetContentOffset.pointee.x / view.frame.width
            let indexPath = IndexPath(item: Int(index), section: 0)
            menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posts", for: indexPath) as! ProfileViewPostsCollectionView
            cell.viewController = self
            cell.prismUser = prismPost.getPrismUser()
            cell.updateCollectionViewHeight()
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likes", for: indexPath) as! ProfileViewLikesCollectionView
            cell.viewController = self
            cell.prismUser = prismPost.getPrismUser()
            cell.updateCollectionViewHeight()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .loginBackground
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
