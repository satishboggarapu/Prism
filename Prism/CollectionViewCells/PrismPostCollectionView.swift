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
    

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.collectionViewBackground
        cv.dataSource = self
        cv.delegate = self
        cv.bounces = false
//        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        return cv
    }()

    var imageSizes: [String: CGSize] = [String: CGSize]()
    var loadingSpinner = MDCActivityIndicator()
    var imagesLoaded: Int = 0
    var pullingData: Bool = false
    var images = [String: UIImage]()
    
    private var lastCollectionViewContentOffset: CGFloat = 0
    var viewController = MainViewController()

    // Database shit
    public var prismPostArrayList: [PrismPost]! = [PrismPost]()

    var validate = false

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
                    self.loadingSpinner.stopAnimating()
                    self.collectionView.reloadData()
                }
            } else {
                print("error loading data")
            }
        }
    }

    private func setupView() {
        backgroundColor = .collectionViewBackground
        collectionView.register(PrismPostCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        loadingSpinner = MDCActivityIndicator()
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
//        // pull more posts if available
//        let scrollViewOffsetValue: CGFloat = (scrollView.contentSize.height - scrollView.frame.size.height) * 0.80
//        if (scrollView.contentOffset.y >= scrollViewOffsetValue) && prismPostArrayList.count > 0 && !pullingData { }
        
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
//        print("Image loaded for url \(postID)")
        imageSizes[postID] = imageSize
        collectionView.collectionViewLayout.invalidateLayout()
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
//                self.populateUserDetailsForAllPosts()
            }else{
                print("no data")
                completionHandler(false)
            }
        })
    }
}


// CollectionView Footer
/*
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      switch kind {
      case UICollectionElementKindSectionFooter:
          let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath as IndexPath)
//            footerView.backgroundColor = Color.white
          footerView.layer.shadowColor = UIColor(hex: 0xDEDEDE).cgColor
          footerView.layer.shadowOffset = CGSize(width: 0, height: 1)
          footerView.layer.shadowOpacity = 0.4
          footerView.layer.shadowRadius = 1
          footerView.layer.cornerRadius = 1.5

          return footerView
      default:
          assert(false, "Unexpected element kind")
      }
      return UICollectionReusableView()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
      return CGSize(width: collectionView.frame.width, height: 35)
  }
*/
