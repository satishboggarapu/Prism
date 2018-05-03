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

class ProfileViewController: UIViewController {

    private var backButton: FABButton!
    private var editAccountButton: FABButton!
    private var profileNavigationView: UIView!
    private var profileView: UIView!
    private var menuBar: ProfileViewMenuBar!
    private var collectionView: UICollectionView!

    var prismPost: PrismPost!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        initializeProfileView()
        initializeMenuBar()
        initializeCollectionView()

        view.addConstraintsWithFormat(format: "H:|[v0]|", views: profileView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addConstraintsWithFormat(format: "V:|[v0][v1(50)][v2]|", views: profileView, menuBar, collectionView)
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.barTintColor = .statusBarBackground

        // left button
        backButton = FABButton()
        backButton.backgroundColor = .clear
        backButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        backButton.setTitle("", for: .normal)
        backButton.setImage(Icons.ARROW_BACK_24?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setImage(Icons.ARROW_BACK_24?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        backButton.imageView?.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        // right button
        editAccountButton = FABButton()
        editAccountButton.backgroundColor = .clear
        editAccountButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
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
        profileImage.layer.cornerRadius = 36/2
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

    private func initializeMenuBar() {
        menuBar = ProfileViewMenuBar()
        menuBar.homeController = self
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuBar)
    }

    private func initializeCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.backgroundColor = .blue
        collectionView?.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView!)
    }

    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }

    @objc private func editAccountButtonAction() {

    }

}

extension ProfileViewController {
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print(prismPostArrayList.count)
//        if indexPath.item == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedPosts", for: indexPath) as! PrismPostCollectionView
//            cell.viewController = self
//            cell.delegate = self
////            cell.prismPostArrayList = self.prismPostArrayList
//            return cell
//        }
//        else if indexPath.item == 3 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Settings", for: indexPath) as!
//                    SettingsCollectionView
//            return cell
//        }
//        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .loginBackground
//            cell.backgroundColor = (indexPath.item == 0) ? .red : .blue
            return cell
//        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: view.frame.height - 50)
    }
}
