//
// Created by Satish Boggarapu on 3/7/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import AVFoundation
import Material
import MaterialComponents
import Firebase
import SDWebImage

class PrismPostCollectionView: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.collectionViewBackground
        cv.dataSource = self
        cv.delegate = self
        cv.bounces = false
        return cv
    }()

    var imageSizes: [CGSize] = []
    var loadingSpinner = MDCActivityIndicator()
    var imagesLoaded: Int = 0

    private var lastCollectionViewContentOffset: CGFloat = 0
    var viewController = MainViewController()

    // Database shit
    public var prismPostArrayList: [PrismPost]! = [PrismPost]()
    

    /*
     * Globals
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
        
        loadingSpinner.startAnimating()
        refreshData() { (result) in
            if result {
                print(self.prismPostArrayList.count)
                self.populateUserDetailsForAllPosts() { (result) in
                    if result {
//                        self.loadProfilePictures()
                        self.loadImages()
                    } else {
                        print("error loading data")
                    }
                }
//                self.collectionView.reloadData()
            } else {
                print("error loading data")
            }
        }
    }

    private func loadImages() {
        let imageManager = SDWebImageManager()
        let myGroup = DispatchGroup()
        
//        myGroup.enter()
//        loadProfilePictures() { (result) in
//            myGroup.leave()
//        }
        
        for i in 0...prismPostArrayList.count-1 {
            if !prismPostArrayList[i].getPrismUser().getProfilePicture().isDefault {
                myGroup.enter()
                let profilePictureUrl = URL(string: prismPostArrayList[i].getPrismUser().getProfilePicture().profilePicUriString)
                imageManager.loadImage(with: profilePictureUrl, options: .continueInBackground, progress: nil, completed: { (image, data, error, cacheType, finished, url) in
                    if error != nil {
                        print(error!, "error")
                        return
                    }
                    self.cacheImage(key: self.prismPostArrayList[i].getUid(), data: data!) { (result) in
//                        print("finished pulling and caching profile picture \(i)")
                        myGroup.leave()
                    }
                })
            }
            // loads post image
            let postImageUrl = URL(string: prismPostArrayList[i].getImage())
            myGroup.enter()
            imageManager.loadImage(with: postImageUrl, options: .continueInBackground, progress: nil, completed: { (image, data, error, cacheType, finished, url) in
                if error != nil {
                    print(error!, "error")
                    return
                }
                self.imageSizes.append((UIImage(data: data!)?.size)!)
                self.cacheImage(key: self.prismPostArrayList[i].getPostId(), data: data!) { (result) in
//                    print("finished pulling and caching post picture \(i)")
                    myGroup.leave()
                }
                
            })
        }
        
        myGroup.notify(queue: .main) {
            print("finished all requests")
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionView.reloadData()
                self.loadingSpinner.stopAnimating()
            })

        }
    }
    
    private func loadProfilePictures(completionHandler: @escaping ((_ exist : Bool) -> Void)) {
        let imageManager = SDWebImageManager()
        let myGroup = DispatchGroup()
        for i in 0...prismPostArrayList.count-1 {
            if !prismPostArrayList[i].getPrismUser().getProfilePicture().isDefault {
                myGroup.enter()
                let profilePictureUrl = URL(string: prismPostArrayList[i].getPrismUser().getProfilePicture().profilePicUriString)
                imageManager.loadImage(with: profilePictureUrl, options: .continueInBackground, progress: nil, completed: { (image, data, error, cacheType, finished, url) in
                    if error != nil {
                        print(error!, "error")
                        return
                    }
                    self.cacheImage(key: self.prismPostArrayList[i].getUid(), data: data!) { (result) in
//                        print("finished pulling and caching profile picture \(i)")
                        myGroup.leave()
                    }
                })
            }
        }
        
        myGroup.notify(queue: .main) {
            completionHandler(true)
        }
    }
    
    private func cacheImage(key: String, data: Data, completionHandler: @escaping ((_ exist : Bool) -> Void)) {
        let imageCache = SDImageCache()
        imageCache.store(UIImage(data: data), forKey: key, completion: {
            completionHandler(true)
//            print("image cached")
        })
    }
    
    private func removeImageFromCache(key: String) {
        let imageCache = SDImageCache()
        imageCache.removeImage(forKey: key, withCompletion: {
//            print("Image removed from cache")
        })
    }

    private func setupView() {
        backgroundColor = .collectionViewBackground
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)

        collectionView.register(PrismPostCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        loadingSpinner = MDCActivityIndicator()
        //        loadingSpinner.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
//        loadingSpinner.center = self.center
        loadingSpinner.indicatorMode = .indeterminate
        loadingSpinner.radius = 20
        loadingSpinner.strokeWidth = 4
        loadingSpinner.sizeToFit()
        loadingSpinner.cycleColors = [UIColor.materialBlue]
        self.insertSubview(loadingSpinner, aboveSubview: collectionView)
        addConstraintsWithFormat(format: "H:[v0(40)]", views: loadingSpinner)
        addConstraint(NSLayoutConstraint(item: loadingSpinner, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraintsWithFormat(format: "V:[v0(40)]", views: loadingSpinner)
        addConstraint(NSLayoutConstraint(item: loadingSpinner, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        cell.loadPostImage()
        cell.loadProfileImage()
        cell.setUsernameText()
        cell.setPostDateText()
        cell.setLikesText()
        cell.setRepostsText()
        cell.toggleLikeButton()
        cell.toggleShareButton()
        cell.viewController = viewController

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func getCellSize(indexPath: IndexPath) -> CGSize {
        let maxWidthInPixels: CGFloat = Constraints.screenWidth() * 0.90 * UIScreen.main.scale
        let maxHeightInPixels: CGFloat = Constraints.screenHeight() * 0.6 * UIScreen.main.scale
        let imageViewMaxFrame = AVMakeRect(aspectRatio: imageSizes[indexPath.item],
                                           insideRect: CGRect(origin: CGPoint.zero, size: CGSize(width: maxWidthInPixels, height: maxHeightInPixels)))
        let imageHeightInPoints = imageViewMaxFrame.height / UIScreen.main.scale
        let height: CGFloat = 16 + 48 + 8 + imageHeightInPoints + 8 + 28 + 16 + 1
        let width: CGFloat = Constraints.screenWidth()
        return CGSize(width: width, height: height)
    }


    // MARK: Accessory Methods for TapGesture's
    
    private func getTappedCellIndexForGesture(gesture: UITapGestureRecognizer) -> IndexPath? {
        let position = gesture.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: position) {
            return indexPath
        }
        return nil
    }

    private func getTappedCellIndexForButton(button: UIButton) -> IndexPath? {
        var position = button.convert(button.frame.origin, from: collectionView)
        position = CGPoint(x: (-1*position.x), y: (-1*position.y))
        if let indexPath = collectionView.indexPathForItem(at: position) {
            return indexPath
        }
        return nil
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
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                for postSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    let prismPost = Helper.constructPrismPostObject(postSnapshot: postSnapshot)
                    self.prismPostArrayList.append(prismPost)
                }
                completionHandler(true)
            }
            else{
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
            }
            else{
                print("no data")
                completionHandler(false)
            }
        })
    }
    
    fileprivate func fetchMorePosts() {
        print("Inside fetchMorePosts")
        let lastPostTimestamp = prismPostArrayList.last?.getTimestamp()
        let query = databaseReferenceAllPosts.queryOrdered(byChild: Key.POST_TIMESTAMP).queryStarting(atValue: lastPostTimestamp! + 1).queryLimited(toFirst: UInt(Default.IMAGE_LOAD_COUNT))
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists(){
                for postSnapshot in snapshot.children{
                    let prismPost = Helper.constructPrismPostObject(postSnapshot: postSnapshot as! DataSnapshot)
                    self.prismPostArrayList.append(prismPost)
                }
//                self.populateUserDetailsForAllPosts()
            }else{
                print("no data")
            }
        })
    }
}
