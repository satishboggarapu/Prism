//
//  FeedViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 9/26/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import PinLayout
import MaterialComponents
import Firebase
import AVFoundation

class FeedViewController: UIViewController {
    
    // MARK: UIElements
    private var collectionView: UICollectionView!
    private var activityIndicator: MDCActivityIndicator!
    private var refreshControl: UIRefreshControl!
    
    // MARK: Attributes
    private var prismPostArrayList: [PrismPost]! = [PrismPost]()
    private var imageSizes: [String: CGSize] = [String: CGSize]()
    private var lastRefreshTime: Date = Date()
    private var reloadVisibleCells: Bool = true
    private var isPullingData: Bool = false
    private var lastCollectionViewContentOffset: CGFloat = 0

    // MARK: Database Attributes
    private var auth: Auth!
    private var storageReference: StorageReference!
    private var databaseReferenceAllPosts: DatabaseReference!
    private var usersReference: DatabaseReference!
    private var userReference: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.loginBackground
        
        setupNavigationBar()
        setupCollectionView()
        setupRefreshControl()
        setupActivityIndicator()

        // Database Initialization
        auth = Auth.auth()
        storageReference = Default.STORAGE_REFERENCE
        databaseReferenceAllPosts = Default.ALL_POSTS_REFERENCE
        usersReference = Default.USERS_REFERENCE
        userReference = Default.USERS_REFERENCE.child((auth.currentUser?.uid)!)

        refreshData(false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.pin.all()
        activityIndicator.pin.vCenter().hCenter()
    }
    
    /*
     *  Initialize and setup app icon and name in navigation bar.
     */
    private func setupNavigationBar() {

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .statusBarBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.hidesBarsOnSwipe = true
        
        let navigationView = NavigationView()
        navigationView.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        
        let signOutButton = UIBarButtonItem(title: "SignOut", style: .done, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationView)
        navigationItem.rightBarButtonItem = signOutButton
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.collectionViewBackground1
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = true
        // TODO: Remove this
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
        collectionView.register(PrismPostCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = MDCActivityIndicator()
        activityIndicator.indicatorMode = .indeterminate
        activityIndicator.radius = 20
        activityIndicator.strokeWidth = 4
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = [.materialBlue]
        view.insertSubview(activityIndicator, aboveSubview: collectionView)
    }

    private func refreshData(_ isRefreshing: Bool) {
        activityIndicator.startAnimating()
        refreshData() { (result) in
            if result {
                self.populateUserDetailsForAllPosts() { (result) in
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                    if isRefreshing { self.refreshControl.endRefreshing() }
                }
            } else {
                print("error loading data")
                // TODO: Log Error
            }
        }
    }

    @objc private func refreshControlAction(_ refreshControl: UIRefreshControl) {
        if isLastRefreshMoreThenFourSeconds() {
            lastRefreshTime = Date()
            CurrentUser.refreshUserProfile()
            prismPostArrayList.removeAll()
            refreshData(true)
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    private func loadMorePosts(_ index: Int) {
        if index == prismPostArrayList.count - 1 && !isPullingData {
            isPullingData = true
            fetchMorePosts() { (result) in
                if result {
                    self.populateUserDetailsForAllPosts() { (result) in
                        if result {
                            let count = self.prismPostArrayList.count - index
                            var indexPaths = [IndexPath]()
                            for i in stride(from: 1, to: count, by: 1) {
                                indexPaths.append(IndexPath(item: index + i, section: 0))
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
    }

    // MARK: Accessory Methods

    private func getCellSize(_ index: Int) -> CGSize {
        let postId: String = prismPostArrayList[index].getPostId()!
        var imageHeightInPoints: CGFloat = 150
        if imageSizes.keys.contains(postId) {
            let maxWidthInPixels: CGFloat = PrismPostConstraints.IMAGE_MAX_WIDTH * UIScreen.main.scale
            let maxHeightInPixels: CGFloat = PrismPostConstraints.IMAGE_MAX_HEIGHT * UIScreen.main.scale
            let imageViewMaxFrame = AVMakeRect(aspectRatio: imageSizes[postId]!, insideRect: CGRect(origin: CGPoint.zero, size: CGSize(width: maxWidthInPixels, height: maxHeightInPixels)))
            imageHeightInPoints = imageViewMaxFrame.height / UIScreen.main.scale
        }
        let height: CGFloat = PrismPostConstraints.CELL_HEIGHT_WITHOUT_POST_IMAGE + imageHeightInPoints
        let width: CGFloat = Constraints.screenWidth()
        return CGSize(width: width, height: height)
    }

    /**
     * Checks if the last time refreshed data has been more then 4 seconds
     */
    private func isLastRefreshMoreThenFourSeconds() -> Bool {
        return Date().seconds(from: lastRefreshTime) >= 4
    }


}

// MARK: Firebase Methods
extension FeedViewController {
    /**
     *  Clears the data structure and pulls ALL_POSTS info again from cloud
     *  Queries the ALL_POSTS data sorted by the post timestamp and pulls n
     *  number of posts and loads them into an ArrayList of postIds and
     *  a HashMap of PrismObjects
     */
    private func refreshData(completionHandler: @escaping ((_ exist : Bool) -> Void)) {
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
    private func populateUserDetailsForAllPosts(completionHandler: @escaping ((_ exist : Bool) -> Void)) {
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

    private func fetchMorePosts(completionHandler: @escaping ((_ exit: Bool) -> Void)) {
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

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prismPostArrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PrismPostCollectionViewCell
        let prismPost = prismPostArrayList[indexPath.item]

        cell.prismPost = prismPost
        cell.delegate = self
        cell.postImage.delegate = self
        cell.loadPostImage()
        cell.loadProfileImage()
        cell.setUsernameText()
        cell.setPostDateText()
        cell.setLikesText()
        cell.setRepostsText()
        cell.toggleLikeButton()
        cell.toggleRepostButton()
//        cell.viewController = viewController

        loadMorePosts(indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension FeedViewController: CustomImageViewDelegate {
    func imageLoaded(postID: String, imageSize: CGSize) {
        imageSizes[postID] = imageSize
        collectionView.collectionViewLayout.invalidateLayout()
        if reloadVisibleCells {
            reloadVisibleCells = false
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        }
    }
}

extension FeedViewController: PrismPostCollectionViewCellDelegate {
    func deletePost(_ prismPost: PrismPost) {
        print("delete post from collectionView")
//        let index = prismPostArrayList.index(of: prismPost)
//        if index != nil {
//            prismPostArrayList.remove(at: index!)
//            collectionView.deleteItems(at: [IndexPath(item: index!, section: 0)])
//        }
    }

    func postImageSelected(_ prismPost: PrismPost) {
        let index = prismPostArrayList.index(of: prismPost)
//        if index != nil {
//            delegate?.prismPostSelected(IndexPath(item: index!, section: 0))
//        }
    }

    func profileViewSelected(_ prismPost: PrismPost) {
//        delegate?.profileViewSelected(prismPost)
    }
}
