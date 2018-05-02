//
//  MainViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 3/3/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material
import Firebase
import Motion
import MaterialComponents
import SDWebImage

class MainViewController: UIViewController {

    var navigationBar: NavigationBar!
    var menuBar: MenuBar!
    var collectionView: UICollectionView!
    var newPostButton: FABButton!
    var newPostButtonHidden: Bool = false
    var selectedPrismPostIndexPath: IndexPath!
    let zoomTransitioningDelegate  = ZoomTransitioningDelegate()
    var resetNavigationBar: Bool = false

    var onDoneBlock : ((Bool) -> Void)?

    let colors = [UIColor.white, UIColor.blue, UIColor.gray, UIColor.green]

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
    
    private var uploadedImageUri: String!
    private var uploadedImageDescription: String!



    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appWillTerminate(_:)), name: Notification.Name.UIApplicationWillTerminate, object: nil)

        setupNavigationBar()
        initializeMenuBar()
        initializeCollectionView()
        initializeNewPostButton()
        
        // Database Initialization
        auth = Auth.auth()
        storageReference = Default.STORAGE_REFERENCE
        databaseReference = Default.ALL_POSTS_REFERENCE
        userReference = Default.USERS_REFERENCE.child((auth.currentUser?.uid)!)
        databaseReferenceAllPosts = Default.ALL_POSTS_REFERENCE
        usersReference = Default.USERS_REFERENCE

        CurrentUser()
        CurrentUser.refreshUserProfile()

//        refreshData()
    }

    override func viewWillAppear(_ animated: Bool) {
        if resetNavigationBar {
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
//            self.navigationController?.navigationBar.barTintColor = UIColor.statusBarBackground
//            self.navigationController?.navigationBar.isTranslucent = false
//            self.navigationItem.setHidesBackButton(true, animated: false)
//
////            view.removeConstraints(view.constraints)
//            view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
//            view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)


            resetNavigationBar = false
        }
//        setupNavigationBar()
//        initializeMenuBar()


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func appWillTerminate(_ application: UIApplication) {
//        SDImageCache.shared().clearMemory()
//        SDImageCache.shared().clearDisk()
//        CachedImages.clearCache() { (result) in
//            print("cleared cache")
//        }
        print("cache cleared")
    }

    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.statusBarBackground
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        let navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: 0, width: 100, height: 44)

        let iconImageView = UIImageView(image: Icons.SPLASH_SCREEN_ICON)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 0, y: 8, width: 34, height: 34)
        navigationView.addSubview(iconImageView)

        let titleLabel =  UILabel()
        titleLabel.frame = CGRect(x: 44, y: 8, width: 100, height: 34)
        titleLabel.text = "Prism"
        titleLabel.font = RobotoFont.bold(with: 22)
        titleLabel.textColor = UIColor.white
        navigationView.addSubview(titleLabel)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationView)

        let signOutButton = UIBarButtonItem(title: "SignOut", style: .done, target: self, action: #selector(signOutButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = signOutButton

    }

    private func setupNavigationBarForImageUpload(uploadImage: UIImage) {
        let progressViewWidth = Constraints.screenWidth() - 20 - 8 - 24 - 24 - 8 - 20

        let uploadImageNavigationTitleView = UIView()
        uploadImageNavigationTitleView.frame = CGRect(x: 0, y: 0, width: Constraints.screenWidth() - 40, height: 44)

        // image view
        let image = UIImageView()
        image.image = uploadImage
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 34/2
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        image.clipsToBounds = true

        let rightView = UIView()

        let label = UILabel()
        label.text = "Uploading image ..."
        label.textColor = UIColor.white
        label.font = RobotoFont.thin(with: 13)

        let progress = UIProgressView()

        rightView.addSubview(label)
        rightView.addSubview(progress)
        rightView.addConstraintsWithFormat(format: "H:|[v0]", views: label)
        rightView.addConstraintsWithFormat(format: "H:|[v0(\(progressViewWidth))]|", views: progress)
        rightView.addConstraintsWithFormat(format: "V:|[v0][v1(3)]-|", views: label, progress)

        uploadImageNavigationTitleView.addSubview(image)
        uploadImageNavigationTitleView.addSubview(rightView)
        uploadImageNavigationTitleView.addConstraintsWithFormat(format: "H:|[v0(34)]-8-[v1]|", views: image, rightView)
        uploadImageNavigationTitleView.addConstraintsWithFormat(format: "V:|-5-[v0(34)]|", views: image)
        uploadImageNavigationTitleView.addConstraintsWithFormat(format: "V:|[v0]|", views: rightView)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: uploadImageNavigationTitleView)
        self.navigationItem.rightBarButtonItem = nil

        UIView.animate(withDuration: 0, animations: {
            progress.setProgress(0, animated: false)
        }, completion: { (finished) in
            UIView.animate(withDuration: 2, animations: {
                progress.setProgress(1.0, animated: true)
            })
        })

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
            label.text = "Finishing up ..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                label.text = "Done"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    self.setupNavigationBar()
                }
            }
        }


    }

    private func initializeMenuBar() {
        // TODO: Hide navigationbar on swipe
//        self.navigationController?.hidesBarsOnSwipe = true
        menuBar = MenuBar()
        menuBar.homeController = self
        menuBar.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)

//        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func initializeCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.register(PrismPostCollectionView.self, forCellWithReuseIdentifier: "FeedPosts")
        collectionView?.register(SettingsCollectionView.self, forCellWithReuseIdentifier: "Settings")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.backgroundColor = UIColor.loginBackground
//        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView!)

        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        self.view.addConstraintsWithFormat(format: "V:|-50-[v0]|", views: collectionView)
    }

    private func initializeNewPostButton() {
        newPostButton = FABButton(image: Icon.add?.withRenderingMode(.alwaysTemplate))
        newPostButton.backgroundColor = UIColor.materialBlue
        newPostButton.imageView?.tintColor = UIColor.white
        newPostButton.addTarget(self, action: #selector(newPostButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(newPostButton)

        self.view.addConstraintsWithFormat(format: "H:[v0(56)]-24-|", views: newPostButton)
        self.view.addConstraintsWithFormat(format: "V:[v0(56)]-24-|", views: newPostButton)
    }

    @objc func newPostButtonAction(_ sender: FABButton) {
        print("newPostButton pressed")

        setupNavigationBarForImageUpload(uploadImage: Icons.SPLASH_SCREEN_ICON!)

    }

    @objc func signOutButtonAction(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        print("user logged out")
        onDoneBlock!(true)
        self.navigationController?.popViewController(animated: false)
    }

    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }

    func toggleNewPostButton(hide: Bool) {
        if hide && !newPostButtonHidden {
            newPostButtonHidden = true
            self.newPostButton.animate(.scale(0), .duration(0.25))
        } else if !hide && newPostButtonHidden {
            newPostButtonHidden = false
            self.newPostButton.animate(.scale(1), .duration(0.25))
        }
    }
}

extension MainViewController: PrismPostCollectionViewDelegate {
    func prismPostSelected(_ indexPath: IndexPath) {
        print("post image selected")
        selectedPrismPostIndexPath = indexPath
        let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! PrismPostCollectionView
        let prismPostCell = cell.collectionView.cellForItem(at: indexPath) as! PrismPostCollectionViewCell

        let viewController = PrismPostDetailViewController()
        viewController.image = prismPostCell.postImage.image
        viewController.prismPost = prismPostCell.prismPost
        viewController.prismPostCell = prismPostCell

        self.navigationController?.delegate = zoomTransitioningDelegate
        resetNavigationBar = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func profileViewSelected(_ prismPost: PrismPost) {
        let viewController = ProfileViewController()
        viewController.prismPost = prismPost
        navigationController?.pushViewController(viewController, animated: false)
    }
}

extension MainViewController: ZoomingViewController {
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }

    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> CustomImageView? {
        if let indexPath = selectedPrismPostIndexPath {
            let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! PrismPostCollectionView
            let prismPostCell = cell.collectionView.cellForItem(at: indexPath) as! PrismPostCollectionViewCell
            return prismPostCell.postImage
        }
        return nil
    }
}

extension MainViewController: UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
     }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
     }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print(prismPostArrayList.count)
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedPosts", for: indexPath) as! PrismPostCollectionView
            cell.viewController = self
            cell.delegate = self
//            cell.prismPostArrayList = self.prismPostArrayList
            return cell
        }
        else if indexPath.item == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Settings", for: indexPath) as!
                SettingsCollectionView
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: view.frame.height - 50)
    }

    /**
     *  Clears the data structure and pulls ALL_POSTS info again from cloud
     *  Queries the ALL_POSTS data sorted by the post timestamp and pulls n
     *  number of posts and loads them into an ArrayList of postIds and
     *  a HashMap of PrismObjects
     */
    private func refreshData() {
        print("Inside refreshData")
        prismPostArrayList.removeAll()
        let query = databaseReferenceAllPosts.queryOrdered(byChild: Key.POST_TIMESTAMP).queryLimited(toFirst: UInt(Default.IMAGE_LOAD_COUNT))
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                for postSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    let prismPost = Helper.constructPrismPostObject(postSnapshot: postSnapshot)
                    self.prismPostArrayList.append(prismPost)
                }
                self.populateUserDetailsForAllPosts()
                print(self.prismPostArrayList.count)
            }
            else{
                print("No More Posts available")
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
    private func populateUserDetailsForAllPosts(){
        print("Inside populateUserDetailsForAllPosts")
        usersReference.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists(){
                for post in self.prismPostArrayList{
                    let userSnapshot = snapshot.childSnapshot(forPath: post.getUid())
                    let prismUser = Helper.constructPrismUserObject(userSnapshot: userSnapshot) as PrismUser
                    post.setPrismUser(prismUser: prismUser)
                }
            }
            else{
                print("no data")
            }
        })
    }

    private func fetchMorePosts() {
        print("Inside fetchMorePosts")
        let lastPostTimestamp: Int64 = (prismPostArrayList.last?.getTimestamp())!
        let query = databaseReferenceAllPosts.queryOrdered(byChild: Key.POST_TIMESTAMP).queryStarting(atValue: lastPostTimestamp + 1).queryLimited(toFirst: UInt(Default.IMAGE_LOAD_COUNT))
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists(){
                for postSnapshot in snapshot.children{
                    let prismPost = Helper.constructPrismPostObject(postSnapshot: postSnapshot as! DataSnapshot)
                    self.prismPostArrayList.append(prismPost)
                }
                self.populateUserDetailsForAllPosts()
            }else{
                print("no data")
            }
        })
    }

    
    private func uploadImageToCloud(uploadImage : UIImage){
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let imageName = generateUniqueNsUid()
//        StorageReference postImageRef = storageReference.child(Key.STORAGE_POST_IMAGES_REF).child(uploadedImageUri.getLastPathSegment());

        let postImageRef = storageReference.child(Key.STORAGE_POST_IMAGES_REF).child("\(imageName).jpeg") as StorageReference
        if let uploadData = UIImageJPEGRepresentation(uploadImage, 1){
            postImageRef.putData(uploadData, metadata: metadata, completion: { (metadata, error) in
//                postImageRef.observe(.progress) { snapshot, a in
//
//                }
                if error != nil {
                    print(error!)
                    return
                }
                let downloadUrl: String = (metadata?.downloadURL()?.absoluteString)!
                let postReference = self.databaseReference.childByAutoId() as DatabaseReference
                let prismPost = self.createPrismPostObjectForUpload(downloadUrl: downloadUrl) as PrismPost
                
                
                // Add postId to USER_UPLOADS table
                let userPostRef = self.userReference.child(Key.DB_REF_USER_UPLOADS).child(postReference.key) as DatabaseReference
                userPostRef.value(forKey: String(prismPost.getTimestamp()))

                // Create the post in cloud and on success, add the image to local recycler view adapter
                postReference.setValue(prismPost, withCompletionBlock: { (error, ref ) in
                    if error != nil {
                        //updateLocalRecyclerViewWithNewPost(prismPost);

                    }
                    else {
                        print("Image upload failed")
                    }
                })
                
                
//                postReference.setValue(prismPost).addOnCompleteListener(new OnCompleteListener<Void>() {
//                    @Override
//                    public void onComplete(@NonNull Task<Void> task) {
//                        if (task.isSuccessful()) {
//                        } else {
//                            uploadingImageTextView.setText("Failed to make the post");
//                            Log.wtf(Default.TAG_DB, Message.POST_UPLOAD_FAIL, task.getException());
//                        }
//                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//                            imageUploadProgressBar.setProgress(100, true);
//                        } else {
//                            imageUploadProgressBar.setProgress(100);
//                        }
//                    }
//                })
                print("Upload Successful")
                
            })
        }
        
    }
    
//    private func uploadImageToCloud(uploadImage : UIImage){
//
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        let imageName = NSUUID().uuidString
//        let uploadImagesRef = storageRef.child("POST_IMAGES").child("\(imageName).jpeg")
//        if let uploadData = UIImageJPEGRepresentation(uploadImage, 90){
//            print(uploadData)
//            uploadImagesRef.putData(uploadData, metadata: metadata, completion: { (metadata, error) in
//                if error != nil{
//                    print(error)
//                    return
//                }
//                print("Upload Successful")
//
//                let imageURL = (metadata?.downloadURL()?.absoluteString)!
//                let timestamp = self.getNegativeCurrentTimeStampInMillis()
//                let uid = Auth.auth().currentUser!.uid
//                let prismPostObject = PrismPost(timestamp: timestamp, postDescription: "", imageURL: imageURL, uid: uid)
//                self.addPrismPostChildtoAllPosts(prismPostObject: prismPostObject)
//            })
//        }
//    }
//
//    func addPrismPostChildtoAllPosts(prismPostObject : PrismPost){
//        print("Inside addPrismPostChildtoAllPosts")
//        let usersRef = accountsRef.child("ALL_POSTS").childByAutoId()
//        let values = ["caption": prismPostObject.postDescription,
//                      "image" : prismPostObject.imageURL,
//                      "timestamp": prismPostObject.timestamp,
//                      "uid": prismPostObject.uid] as [String : Any]
//        usersRef.setValue(values, withCompletionBlock: {
//            (err, ref) in
//            if err != nil {
//                print(err)
//                return
//            }
//            let postId = usersRef.key
//            self.addUserUploadtoUser(timestamp: prismPostObject.timestamp, postId: postId)
//            print("Successfully added Prism post child to ALL_POSTS")
//        })
//    }
//
//    func addUserUploadtoUser(timestamp : Int64, postId : String){
//        print("Inside addUserUploadtoUser")
//        let uid = Auth.auth().currentUser!.uid
//        let usersRef = accountsRef.child("USERS").child(uid).child("USER_UPLOADS").child(postId)
//        //        let values = [ postId : timestamp] as [String : Int64]
//        usersRef.setValue(timestamp, withCompletionBlock: {
//            (err, ref) in
//            if err != nil {
//                print(err)
//                return
//            }
//            print("Successfully added user upload to USER")
//        })
//    }

    /**
     * Takes in the downloadUri that was create in cloud and reference to the post that
     * got created in cloud and prepares the PrismPost object that will be pushed
     */
    private func createPrismPostObjectForUpload(downloadUrl: String) -> PrismPost{
        let imageUri = downloadUrl as String
        let userId: String = (auth.currentUser?.uid)!
        let timestamp = getNegativeCurrentTimeStampInMillis() as Int64
        let description = "Parth's new haircut>>>>>>>>>>>>>" as String
        return PrismPost(timestamp: timestamp, postDescription: description, imageURL: imageUri, uid: userId)
    }
    public func generateUniqueNsUid() -> String {
        return NSUUID().uuidString
    }

    
    
    func getNegativeCurrentTimeStampInMillis() -> Int64 {
        return (Date().milliseconds()) * -1
    }
    
}
