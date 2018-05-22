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

    var collectionView: UICollectionView!
    var viewController: ProfileViewController!
    var prismUser: PrismUser!
    var prismPostArrayList = [PrismPost]()
    var imageSizes = [String: CGSize]()

    var flowLayout: PinterestLayout {
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

//        refreshData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        addSubview(collectionView)
        // collectionView constraints
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)

    }

    func refreshData() {
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
                    self.prismPostArrayList.append(contentsOf: uploadedPosts)
                    self.prismPostArrayList.append(contentsOf: repostedPosts)
                    self.loadImages()
                })
            }
        }, withCancel: { (error) in

        })
    }

    func loadImages() {
        let group = DispatchGroup()
        for post in prismPostArrayList {
            group.enter()
            let url = URL(string: post.getImage())
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    group.leave()
                }
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: post.getPostId() as NSString)

                let maxWidthInPixels: CGFloat = ((self.frame.width-20)/3) * UIScreen.main.scale
                let maxHeightInPixels: CGFloat = (maxWidthInPixels * imageToCache!.size.height)/imageToCache!.size.width
                let maxWidthInPoints: CGFloat = maxWidthInPixels / UIScreen.main.scale
                let maxHeightInPoints: CGFloat = maxHeightInPixels / UIScreen.main.scale
                self.imageSizes[post.getPostId()] = CGSize(width: maxWidthInPoints, height: maxHeightInPoints)
                group.leave()
            }).resume()
        }

        group.wait()
        collectionView.reloadData()
    }

    func imageLoaded(postID: String, imageSize: CGSize) {
        let maxWidthInPixels: CGFloat = ((self.frame.width-20)/3) * UIScreen.main.scale
        let maxHeightInPixels: CGFloat = (maxWidthInPixels * imageSize.height)/imageSize.width
        let maxWidthInPoints: CGFloat = maxWidthInPixels / UIScreen.main.scale
        let maxHeightInPoints: CGFloat = maxHeightInPixels / UIScreen.main.scale
//        print(maxWidthInPoints, maxHeightInPoints, ((self.frame.width-20)/3))
//        imageSizes[postID] = CGSize(width: maxWidthInPoints, height: maxHeightInPoints)
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
        cell.prismPost = prismPostArrayList[indexPath.item]
        cell.loadPostImage()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let postId = prismPostArrayList[indexPath.item].getPostId()
        if imageSizes.keys.contains(postId) {
            print(imageSizes[postId]!.height)
            return imageSizes[postId]!.height
        }
        return 100
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let postId = prismPostArrayList[indexPath.item].getPostId()
//        if imageSizes.keys.contains(postId) {
//            return CGSize(width: imageSizes[postId]!.width, height: imageSizes[postId]!.height)
//        }
//        return CGSize(width: (self.frame.width-20)/3, height: 100)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
}
