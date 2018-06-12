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

// TODO: Make refreshControl private
// TODO: Make reloadData and isReloadingData private
// TODO: Comment

/**
 *  Base collectionViewCell class for Posts and Likes tabs in ProfileViewController.
 */
class ProfileViewCollectionView: UICollectionViewCell, CustomImageViewDelegate {
    
    /**
     * PrismPost object just for ProfileViewCollectionView, consits of normal PrismPost, and isPostReposted attributes,
     * which is set to true if the user reposted the post
     */
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
    // TODO: Convert this to 1 line after testing with images
    fileprivate var flowLayout: ProfileViewCollectionViewLayout {
        let layout = ProfileViewCollectionViewLayout()
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
    
    /**
     *  Initializes `collectionView` and `refreshControl`
     *
     *  - parameters:
     *      - none
     *
     *  - returns:
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
        collectionView.isScrollEnabled = false
        collectionView.register(ProfileViewPostsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.addContentInset(collectionViewInset)
        collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: getCollectionViewHeight())
        addSubview(collectionView)
        
        // initialize refreshControel
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }
    
    /**
     *  Gets called when `refreshControl` is refreshing. Reloads data all of the firebase data, by making a call to
     *      *refreshData()* method
     *
     *  - parameters:
     *      - none
     *
     *  - returns:
     */
    fileprivate func refreshControlAction() {
        print("refreshing")
    }
    
    /**
     *  If `isReloadingData` is true, new data pulled from firebase is appended to `prismPostArrayListNew`, then checked
     *      if it's the same as current posts in `prismPostArrayList`. If `prismPostArrayListNew` is different from
     *      current posts, then `prismPostArrayListNew` is copied to `prismPostArrayList` and `collectionView` is reloaded.
     *  If `isReloadingData` is false, the data pulled from firebase is directly appended to `prismPostArrayList` and
     *      `collectionView` is reloaded
     *
     *  - parameters:
     *      - isReloadingData: Bool. True if reloading data, false if loading data for the first time
     *
     *  - returns:
     */
    fileprivate func refreshData(_ isReloadingData: Bool) {
        
    }
    
    /**
     *  Protocol method from CustomImageView. Gets called when image was succesfully loaded. Checks the original image
     *      size and computes the proper imageSize for the collectionViewCell and stores the size in `imageSizes` dict.
     *      Invalidates the collectionViewLayout so the UI can be updated accordingly
     *
     *  - parameters:
     *      - postID: String. postID of the prismPost being loaded
     *      - imageSize: CGSize: Orignial size of the image loaded from the prismPost
     *
     *  - returns:
     */
    internal func imageLoaded(postID: String, imageSize: CGSize) {
        let maxWidthInPixels: CGFloat = collectionViewCellWidth() * UIScreen.main.scale
        let maxHeightInPixels: CGFloat = (maxWidthInPixels * imageSize.height)/imageSize.width
        let maxWidthInPoints: CGFloat = maxWidthInPixels / UIScreen.main.scale
        let maxHeightInPoints: CGFloat = maxHeightInPixels / UIScreen.main.scale
        imageSizes[postID] = CGSize(width: maxWidthInPoints.rounded(.up), height: maxHeightInPoints.rounded(.up))
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    /**
     *  Computes the height for the `collectionView`
     *
     *  - parameters:
     *      - none
     *
     *  - returns:
     *      - Height of the collectionView as CGFloat.
     */
    private func getCollectionViewHeight() -> CGFloat {
        let height = Constraints.screenHeight() - Constraints.navigationBarHeight() - Constraints.statusBarHeight()
        if prismUser != nil && prismUser.getUid() == CurrentUser.prismUser.getUid() {
            return height - 50
        }
        return height
    }
    
    /**
     *  Updates the height of the `collectionView
     *
     *  - parameters:
     *      - none
     *
     *  - returns:
     */
    public func updateCollectionViewHeight() {
        print(getCollectionViewHeight())
        collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: getCollectionViewHeight())
    }
    
    /**
     *  Computes cell width for the `collectionView`. 3 colums
     *
     *  Cell horizontal layout: |-4-[-4-[Image]-4-][-4-[Image]-4-][-4-[Image]-4-]-4-|
     *
     *  - parameters:
     *      - none
     *
     *  - returns:
     *      - the width of each cell as CGFloat
     */
    private func collectionViewCellWidth() -> CGFloat {
        return ((Constraints.screenWidth() - (collectionViewInset * 2))/3) - 8
    }
    
    /**
     *  Converts array of PrismPosts objects to `ProfileViewPrismPosts`
     *
     *  - parameters:
     *      - posts: Array of PrismPosts that need to be converted to `ProfileViewPrismPosts`
     *      - isPostReposted: Bool, refresnting true if the post was reposted by the user, else false
     *
     *  - returns:
     *      - array of ProfileViewPrismPost, [ProfileViewPrismPost]
     */
    fileprivate func convertPrismPostsToProfileViewPrismPosts(posts: [PrismPost], isPostReposted: Bool) -> [ProfileViewPrismPost] {
        var profileViewPrismPosts = [ProfileViewPrismPost]()
        for post in posts {
            profileViewPrismPosts.append(ProfileViewPrismPost(prismPost: post, isPostReposted: isPostReposted))
        }
        return profileViewPrismPosts
    }
    
    /**
     *  Called when the collectionView scroll is finished scroll animation is complete. Checks if data needs to be
     *      reloaded and if data is currently being reloading. If reloadData is true and isReloadingData is false,
     *      isReloadingData is set to true, reloadData is set to false, and `refreshControlAction()` is called, which
     *      which refreshes data
     */
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if reloadData && !isReloadingData {
            isReloadingData = true
            reloadData = false
            refreshControlAction()
        }
    }
}

extension ProfileViewCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, ProfileViewCollectionViewLayoutDelegate {
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
    
    /**
     *  First checks if the size of the image has been computed and stored in `imageSizes` dict, if so its returned.
     *      Else a defualt height of 150 is returned
     */
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let postId = prismPostArrayList[indexPath.item].prismPost.getPostId()
        if imageSizes.keys.contains(postId) {
            return imageSizes[postId]!.height + 8
        }
        return 150
    }
    
}

/**
 *  CollectionViewCell for Posts Tab in ProfileViewController. Overrides the *refreshData()* method to load uploaded and
 *      reposted posts from the user. Also overrides the *refreshControlAction()*
 */
class ProfileViewPostsCollectionView: ProfileViewCollectionView {
    override func refreshData(_ isReloadingData: Bool) {
        /// Stores the snapshot from firebase of the repostedPosts. Key = String (Reposted Time), Value = Int64 (PostID)
        var repostedPostsMap = [String: Int64]()
        /// Stores the snapshot from firebase of the uploadedPosts. Key = String (Uploaded Time), Value = Int64 (PostID)
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
                    // Converts array of prismPostId's to PrismPost objects
                    let uploadedPosts = DatabaseAction.getListOfPrismPosts(allPostRefSnapshot: dataSnapshot, usersSnapshot: usersSnapshot, mapOfPostIds: uploadedPostsMap)
                    let repostedPosts = DatabaseAction.getListOfPrismPosts(allPostRefSnapshot: dataSnapshot, usersSnapshot: usersSnapshot, mapOfPostIds: repostedPostsMap)
                    // Converts array of PrismPost objects to ProfileViewPrismPost objects
                    let uploadedProfileViewPosts = self.convertPrismPostsToProfileViewPrismPosts(posts: uploadedPosts, isPostReposted: false)
                    let repostedProfileViewPosts = self.convertPrismPostsToProfileViewPrismPosts(posts: repostedPosts, isPostReposted: true)
                    // If data is being reloaded, store it in prismPostArrayListNew, else store it prismPostArrayList
                    if isReloadingData {
                        self.prismPostArrayListNew.append(contentsOf: uploadedProfileViewPosts)
                        self.prismPostArrayListNew.append(contentsOf: repostedProfileViewPosts)
                    } else {
                        self.prismPostArrayList.append(contentsOf: uploadedProfileViewPosts)
                        self.prismPostArrayList.append(contentsOf: repostedProfileViewPosts)
                    }
                    // If data is being reloaded, check if new data is different from curent data, if so replace it
                    //   with new data
                    if isReloadingData && self.prismPostArrayListNew != self.prismPostArrayList {
                        self.prismPostArrayList = self.prismPostArrayListNew
                    }
                    
                    self.collectionView.reloadData()
                    self.prismPostArrayListNew.removeAll()
                    self.refreshControl.endRefreshing()
                    self.isReloadingData = false
                })
            }
        }, withCancel: { (error) in
            // TODO: Log Error
        })
    }
    
    override fileprivate func refreshControlAction() {
        print("refreshing uploaded/reposted PrismPosts")
        refreshData(true)
    }
}

/**
 *  CollectionViewCell for Likes Tab in ProfileViewController. Overrides the *refreshData()* method to load liked posts
 *      from the user. Also overrides the *refreshControlAction()*
 */
class ProfileViewLikesCollectionView: ProfileViewCollectionView {
    override func refreshData(_ isReloadingData: Bool) {
        /// Stores the snapshot from firebase of the likedPosts. Key = String (Reposted Time), Value = Int64 (PostID)
        var likedPostsMap = [String: Int64]()
        usersReference.observeSingleEvent(of: .value, with: { (usersSnapshot) in
            if usersSnapshot.exists() {
                let userSnapshot: DataSnapshot = usersSnapshot.childSnapshot(forPath: self.prismUser.getUid())
                if userSnapshot.hasChild(Key.DB_REF_USER_LIKES) {
                    likedPostsMap.update(other: userSnapshot.childSnapshot(forPath: Key.DB_REF_USER_LIKES).value as! [String: Int64])
                }
                
                self.databaseReference.observeSingleEvent(of: .value, with: { (dataSnapshot) in
                    // Converts array of prismPostId's to PrismPost objects
                    let likedPosts = DatabaseAction.getListOfPrismPosts(allPostRefSnapshot: dataSnapshot, usersSnapshot: usersSnapshot, mapOfPostIds: likedPostsMap)
                    // Converts array of PrismPost objects to ProfileViewPrismPost objects
                    let likedProfileViewPosts = self.convertPrismPostsToProfileViewPrismPosts(posts: likedPosts, isPostReposted: false)
                    // If data is being reloaded, store it in prismPostArrayListNew, else store it prismPostArrayList
                    if isReloadingData {
                        self.prismPostArrayListNew.append(contentsOf: likedProfileViewPosts)
                    } else {
                        self.prismPostArrayList.append(contentsOf: likedProfileViewPosts)
                    }
                    // If data is being reloaded, check if new data is different from curent data, if so replace it
                    //   with new data
                    if isReloadingData && self.prismPostArrayListNew != self.prismPostArrayList{
                        self.prismPostArrayList = self.prismPostArrayListNew
                        self.collectionView.reloadData()
                    } else {
                        self.collectionView.reloadData()
                    }
                    
                    self.prismPostArrayListNew.removeAll()
                    self.refreshControl.endRefreshing()
                    self.isReloadingData = false
                })
            }
        }, withCancel: { (error) in
            // TODO: Log Error
        })
    }
    
    override fileprivate func refreshControlAction() {
        print("refreshing likes PrismPosts")
        refreshData(true)
    }
}
