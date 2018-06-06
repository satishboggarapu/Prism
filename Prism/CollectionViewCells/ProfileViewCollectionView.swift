//
//  ProfileViewCollectionView.swift
//  Prism
//
//  Created by Satish Boggarapu on 5/28/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import AVFoundation
import Material
import MaterialComponents
import Firebase

class ProfileViewCollectionView: UICollectionViewCell, CustomImageViewDelegate {
    
    struct ProfileViewPrismPost: Equatable {
        var prismPost: PrismPost
        var isPostReposted: Bool
        
        static func ==(lhs: ProfileViewPrismPost, rhs: ProfileViewPrismPost) -> Bool {
            return lhs.prismPost == rhs.prismPost && lhs.isPostReposted == rhs.isPostReposted
        }
    }
    
    
    
    /*
     * Attributes
     */
    var collectionView: UICollectionView!
    var viewController: ProfileViewController!
    var prismUser: PrismUser!
    var refreshControl: UIRefreshControl!
    fileprivate var prismPostArrayList = [ProfileViewPrismPost]()
    fileprivate var prismPostArrayListNew = [ProfileViewPrismPost]()
    fileprivate var imageSizes = [String: CGSize]()
    fileprivate var imageSizesNew = [String: CGSize]()
    fileprivate var collectionViewInset: CGFloat = 4
    fileprivate var flowLayout: PinterestLayout {
        let layout = PinterestLayout()
        layout.delegate = self
        return layout
    }
    
    var reloadData: Bool = false
    var isReloadingData: Bool = false
    
    /*
     * Database References
     */
    fileprivate var auth: Auth!
    fileprivate var databaseReference: DatabaseReference!
    fileprivate var storageReference: StorageReference!
    fileprivate var databaseReferenceAllPosts: DatabaseReference!
    fileprivate var usersReference: DatabaseReference!
    fileprivate var userReference: DatabaseReference!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        // Database Initialization
        auth = Auth.auth()
        storageReference = Default.STORAGE_REFERENCE
        databaseReference = Default.ALL_POSTS_REFERENCE
        userReference = Default.USERS_REFERENCE.child((auth.currentUser?.uid)!)
        databaseReferenceAllPosts = Default.ALL_POSTS_REFERENCE
        usersReference = Default.USERS_REFERENCE
        
        // Pull Firebase data and populate collectionView
        refreshData(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     *
     */
    private func setupView() {
        backgroundColor = .collectionViewBackground
        
        // initialize collectionView
        let layout = flowLayout
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.collectionViewBackground1
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.clipsToBounds = false
        collectionView.register(ProfileViewPostsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.addContentInset(collectionViewInset)
        let height = Constraints.screenHeight() - Constraints.navigationBarHeight() - Constraints.statusBarHeight() - 50
        collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: height)
        addSubview(collectionView)
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
//        refreshControl.addTarget(self, action: #selector(refreshControlAction(_ :)), for: .allEvents)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    @objc func refreshControlAction() {
        print("refreshing")
    }
    
    /*
     *
     */
    fileprivate func refreshData(_ isReloadingData: Bool) {
        
    }
    
    func imageLoaded(postID: String, imageSize: CGSize) {
        let maxWidthInPixels: CGFloat = collectionViewCellWidth() * UIScreen.main.scale
        let maxHeightInPixels: CGFloat = (maxWidthInPixels * imageSize.height)/imageSize.width
        let maxWidthInPoints: CGFloat = maxWidthInPixels / UIScreen.main.scale
        let maxHeightInPoints: CGFloat = maxHeightInPixels / UIScreen.main.scale
        imageSizes[postID] = CGSize(width: maxWidthInPoints.rounded(.up), height: maxHeightInPoints.rounded(.up))
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func collectionViewCellWidth() -> CGFloat {
        // Structure of collectionView row
        // |-4-[-4-[Image]-4-][-4-[Image]-4-][-4-[Image]-4-]-4-|
        return ((Constraints.screenWidth() - (collectionViewInset * 2))/3) - 8
    }
    
    func disableScrolling() {
        collectionView.isScrollEnabled = false
    }
    
    func enableScrolling() {
        collectionView.isScrollEnabled = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            viewController.panGesture.isEnabled = true
            disableScrolling()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if reloadData && !isReloadingData {
            isReloadingData = true
            reloadData = false
            refreshControlAction()
        }
    }
}

extension ProfileViewCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prismPostArrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileViewPostsCollectionViewCell
        cell.prismPostImage.delegate = self
        cell.prismPost = prismPostArrayList[indexPath.item].prismPost
//        cell.loadPostImage()
        cell.prismPostImage.backgroundColor = .red
        cell.repostIcon.isHidden = !prismPostArrayList[indexPath.item].isPostReposted
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let postId = prismPostArrayList[indexPath.item].prismPost.getPostId()
        if imageSizes.keys.contains(postId) {
            return imageSizes[postId]!.height + 8
        }
        return 150
    }
    
}

class ProfileViewPostsCollectionView: ProfileViewCollectionView {
    override func refreshData(_ isReloadingData: Bool) {
        var repostedPostsMap = [String: Int64]()
        var uploadedPostsMap = [String: Int64]()
        usersReference.observeSingleEvent(of: .value, with: { (usersSnapshot) in
            if usersSnapshot.exists() {
                let userSnapshot: DataSnapshot = usersSnapshot.childSnapshot(forPath: self.prismUser.getUid())
                
                if userSnapshot.hasChild(Key.DB_REF_USER_UPLOADS) {
                    uploadedPostsMap.update(other: userSnapshot.childSnapshot(forPath: Key.DB_REF_USER_UPLOADS).value as! [String: Int64])
                }
                
                if userSnapshot.hasChild(Key.DB_REF_USER_REPOSTS) {
                    repostedPostsMap.update(other: userSnapshot.childSnapshot(forPath: Key.DB_REF_USER_REPOSTS).value as! [String: Int64])
                }
                
                self.databaseReference.observeSingleEvent(of: .value, with: { (dataSnapshot) in
                    let uploadedPosts = DatabaseAction.getListOfPrismPosts(allPostRefSnapshot: dataSnapshot, usersSnapshot: usersSnapshot, mapOfPostIds: uploadedPostsMap)
                    let repostedPosts = DatabaseAction.getListOfPrismPosts(allPostRefSnapshot: dataSnapshot, usersSnapshot: usersSnapshot, mapOfPostIds: repostedPostsMap)
                    for post in uploadedPosts {
                        if isReloadingData {
                            self.prismPostArrayListNew.append(ProfileViewPrismPost(prismPost: post, isPostReposted: false))
                        } else {
                            self.prismPostArrayList.append(ProfileViewPrismPost(prismPost: post, isPostReposted: false))
                        }
                    }
                    for post in repostedPosts {
                        if isReloadingData {
                            self.prismPostArrayListNew.append(ProfileViewPrismPost(prismPost: post, isPostReposted: true))
                        } else {
                            self.prismPostArrayList.append(ProfileViewPrismPost(prismPost: post, isPostReposted: true))
                        }
                    }
                    if isReloadingData {
                        if self.prismPostArrayListNew != self.prismPostArrayList {
                            self.prismPostArrayList = self.prismPostArrayListNew
                            self.collectionView.reloadData()
                        }
                    } else {
                        self.collectionView.reloadData()
                    }
                    self.prismPostArrayListNew.removeAll()
                    self.refreshControl.endRefreshing()
                    self.isReloadingData = false
//                    self.collectionView.setContentOffset(CGPoint(x: -4, y: -4), animated: true)
//                    self.viewController.collectionViewLastContentOffsets[0] = CGPoint(x: -4, y: -4)
                })
            }
        }, withCancel: { (error) in
            
        })
    }
    
    override func refreshControlAction() {
        print("refreshing uploaded/reposted PrismPosts")
        refreshData(true)
    }
}

class ProfileViewLikesCollectionView: ProfileViewCollectionView {
    override func refreshData(_ isReloadingData: Bool) {
        var likedPostsMap = [String: Int64]()
        usersReference.observeSingleEvent(of: .value, with: { (usersSnapshot) in
            if usersSnapshot.exists() {
                let userSnapshot: DataSnapshot = usersSnapshot.childSnapshot(forPath: self.prismUser.getUid())
                
                if userSnapshot.hasChild(Key.DB_REF_USER_LIKES) {
                    likedPostsMap.update(other: userSnapshot.childSnapshot(forPath: Key.DB_REF_USER_LIKES).value as! [String: Int64])
                }
                
                self.databaseReference.observeSingleEvent(of: .value, with: { (dataSnapshot) in
                    let likedPosts = DatabaseAction.getListOfPrismPosts(allPostRefSnapshot: dataSnapshot, usersSnapshot: usersSnapshot, mapOfPostIds: likedPostsMap)
                    for post in likedPosts {
                        if isReloadingData {
                            self.prismPostArrayListNew.append(ProfileViewPrismPost(prismPost: post, isPostReposted: false))
                        } else {
                            self.prismPostArrayList.append(ProfileViewPrismPost(prismPost: post, isPostReposted: false))
                        }
                    }
                    if isReloadingData {
                        if self.prismPostArrayListNew != self.prismPostArrayList {
                            self.prismPostArrayList = self.prismPostArrayListNew
                            self.collectionView.reloadData()
                        }
                    } else {
                        self.collectionView.reloadData()
                    }
                    self.prismPostArrayListNew.removeAll()
                    self.refreshControl.endRefreshing()
                    self.isReloadingData = false
//                    self.collectionView.setContentOffset(CGPoint(x: -4, y: -4), animated: true)
//                    self.viewController.collectionViewLastContentOffsets[1] = CGPoint(x: -4, y: -4)
                })
            }
        }, withCancel: { (error) in
            
        })
    }
    
    override func refreshControlAction() {
        print("refreshing likes PrismPosts")
        refreshData(true)
    }
}
