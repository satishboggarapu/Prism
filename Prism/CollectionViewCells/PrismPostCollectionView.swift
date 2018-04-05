//
// Created by Satish Boggarapu on 3/7/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import AVFoundation
import Material
import MaterialComponents
import Firebase

class PrismPostCollectionView: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CustomImageViewDelegate {


    var viewController = MainViewController()
    private var collectionView: UICollectionView!
    private var activityIndicator = MDCActivityIndicator()

    private var imageSizes: [String: CGSize] = [String: CGSize]()
    private var pullingData: Bool = false
    private var lastCollectionViewContentOffset: CGFloat = 0

    // Database shit
    public var prismPostArrayList: [PrismPost]! = [PrismPost]()

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

        activityIndicator.startAnimating()
        refreshData() { (result) in
            if result {
                print(self.prismPostArrayList.count)
                self.populateUserDetailsForAllPosts() { (result) in
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            } else {
                print("error loading data")
            }
        }
    }

    private func setupView() {
        backgroundColor = .collectionViewBackground

        // initialize collectionView
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.collectionViewBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.register(PrismPostCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(collectionView)
        // collectionView constraints
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)

        // initialize activity indicator
        activityIndicator = MDCActivityIndicator()
        activityIndicator.indicatorMode = .indeterminate
        activityIndicator.radius = 20
        activityIndicator.strokeWidth = 4
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = [UIColor.materialBlue]
        self.insertSubview(activityIndicator, aboveSubview: collectionView)
        // activityIndicator constraints
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // pull more posts if available
//        let scrollViewOffsetValue: CGFloat = (scrollView.contentSize.height - scrollView.frame.size.height) * 0.80
//        if (scrollView.contentOffset.y >= scrollViewOffsetValue) && prismPostArrayList.count > 0 && !pullingData { }

        // TODO: optimize the newPostButton animation
        if self.lastCollectionViewContentOffset > scrollView.contentOffset.y {
            // scrolled up
            viewController.toggleNewPostButton(hide: false)
        } else if self.lastCollectionViewContentOffset < scrollView.contentOffset.y {
            // scrolled down
            viewController.toggleNewPostButton(hide: true)
        }
        self.lastCollectionViewContentOffset = scrollView.contentOffset.y
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prismPostArrayList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PrismPostCollectionViewCell
        let prismPost = prismPostArrayList[indexPath.item]

        cell.prismPost = prismPost
        cell.postImage.delegate = self
        cell.loadPostImage()
        cell.loadProfileImage()
        cell.setUsernameText()
        cell.setPostDateText()
        cell.setLikesText()
        cell.setRepostsText()
        cell.toggleLikeButton()
        cell.toggleShareButton()
        cell.viewController = viewController

        // load more posts
        // TODO: Create a function for this
        if indexPath.item == prismPostArrayList.count - 1 && !pullingData {
            pullingData = true
            fetchMorePosts() { (result) in
                if result {
                    self.populateUserDetailsForAllPosts() { (result) in
                        if result {
                            let count = self.prismPostArrayList.count - indexPath.item
                            var indexPaths = [IndexPath]()
                            for i in stride(from: 1, to: count, by: 1) {
                                indexPaths.append(IndexPath(item: indexPath.item + i, section: 0))
                            }
                            self.collectionView.performBatchUpdates({ () -> Void in
                                self.collectionView.insertItems(at: indexPaths)

                            }, completion: nil)
                        } else {
                            // TODO: Error
                        }
                    }
                } else {
                    // TODO: Error
                }
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func getCellSize(indexPath: IndexPath) -> CGSize {
        // TODO: Clean this up
        // TODO: Create enum for the UIElements size
        let postID: String = prismPostArrayList[indexPath.item].getPostId()
        var imageHeightInPoints: CGFloat = 150
        if imageSizes.keys.contains(postID) {
            let maxWidthInPixels: CGFloat = Constraints.screenWidth() * 0.925 * UIScreen.main.scale
            let maxHeightInPixels: CGFloat = Constraints.screenHeight() * 0.65 * UIScreen.main.scale
            let imageViewMaxFrame = AVMakeRect(aspectRatio: imageSizes[postID]!,
                    insideRect: CGRect(origin: CGPoint.zero, size: CGSize(width: maxWidthInPixels, height: maxHeightInPixels)))
            imageHeightInPoints = imageViewMaxFrame.height / UIScreen.main.scale
        }
        let height: CGFloat = 16 + 48 + 8 + imageHeightInPoints + 8 + 28 + 16 + 1
        let width: CGFloat = Constraints.screenWidth()
        return CGSize(width: width, height: height)
    }
    
    func imageLoaded(postID: String, imageSize: CGSize) {
        imageSizes[postID] = imageSize
        collectionView.collectionViewLayout.invalidateLayout()
    }
}



// MARK: Firebase Functions

extension PrismPostCollectionView {
    /**
     *  Clears the data structure and pulls ALL_POSTS info again from cloud
     *  Queries the ALL_POSTS data sorted by the post timestamp and pulls n
     *  number of posts and loads them into an ArrayList of postIds and
     *  a HashMap of PrismObjects
     */
    fileprivate func refreshData(completionHandler: @escaping ((_ exist : Bool) -> Void)) {
        print("Inside refreshData")
        prismPostArrayList.removeAll()
        let query = databaseReferenceAllPosts.queryOrdered(byChild: Key.POST_TIMESTAMP).queryLimited(toFirst: UInt(Default.IMAGE_LOAD_COUNT))
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for postSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    let prismPost = Helper.constructPrismPostObject(postSnapshot: postSnapshot)
                    self.prismPostArrayList.append(prismPost)
                }
                completionHandler(true)
            } else {
                print("No More Posts available")
                completionHandler(false)
            }
        })
    }
    
    /**
     * Once all posts are loaded into the prismPostHashMap,
     * this method iterates over each post, grabs firebaseUser's details
     * for the post like "profilePicUriString" and "username" and
     * updates the prismPost objects in that hashMap and then
     * updates the RecyclerViewAdapter so the UI gets updated
     */
    fileprivate func populateUserDetailsForAllPosts(completionHandler: @escaping ((_ exist : Bool) -> Void)) {
        print("Inside populateUserDetailsForAllPosts")
        usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for post in self.prismPostArrayList {
                    let userSnapshot = snapshot.childSnapshot(forPath: post.getUid())
                    let prismUser = Helper.constructPrismUserObject(userSnapshot: userSnapshot) as PrismUser
                    post.setPrismUser(prismUser: prismUser)
                }
                completionHandler(true)
            } else {
                print("no data")
                completionHandler(false)
            }
        })
    }
    
    fileprivate func fetchMorePosts(completionHandler: @escaping ((_ exit: Bool) -> Void)) {
        print("Inside fetchMorePosts")
        let lastPostTimestamp = prismPostArrayList.last?.getTimestamp()
        let query = databaseReferenceAllPosts.queryOrdered(byChild: Key.POST_TIMESTAMP).queryStarting(atValue: lastPostTimestamp! + 1).queryLimited(toFirst: UInt(Default.IMAGE_LOAD_COUNT))
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists(){
                for postSnapshot in snapshot.children{
                    let prismPost = Helper.constructPrismPostObject(postSnapshot: postSnapshot as! DataSnapshot)
                    self.prismPostArrayList.append(prismPost)
                }
                completionHandler(true)
            }else{
                print("no data")
                completionHandler(false)
            }
        })
    }
}
