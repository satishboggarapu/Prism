//
// Created by Satish Boggarapu on 5/4/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import AVFoundation
import Material
import MaterialComponents
import Firebase

class ProfileViewPostsCollectionView: UICollectionViewCell, CustomImageViewDelegate {
    
    struct ProfileViewPrismPost {
        var prismPost: PrismPost
        var isPostReposted: Bool
    }

    /*
     * Attributes
     */
    var collectionView: UICollectionView!
    var viewController: ProfileViewController!
    var prismUser: PrismUser!
    private var prismPostArrayList = [ProfileViewPrismPost]()
    private var imageSizes = [String: CGSize]()
    private var collectionViewInset: CGFloat = 4
    private var flowLayout: PinterestLayout {
        let layout = PinterestLayout()
        layout.delegate = self
        return layout
    }

    /*
     * Database References
     */
    private var auth: Auth!
    private var databaseReference: DatabaseReference!
    private var storageReference: StorageReference!
    private var databaseReferenceAllPosts: DatabaseReference!
    private var usersReference: DatabaseReference!
    private var userReference: DatabaseReference!

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
        refreshData()
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
        collectionView.register(ProfileViewPostsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.addContentInset(collectionViewInset)
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)

    }

    /*
     *
     */
    private func refreshData() {
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
                    for post in uploadedPosts { self.prismPostArrayList.append(ProfileViewPrismPost(prismPost: post, isPostReposted: false)) }
                    for post in repostedPosts { self.prismPostArrayList.append(ProfileViewPrismPost(prismPost: post, isPostReposted: true)) }
                    self.collectionView.reloadData()
                })
            }
        }, withCancel: { (error) in

        })
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
}

extension ProfileViewPostsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate {
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
        return 100
    }
}
