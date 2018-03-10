//
// Created by Satish Boggarapu on 3/7/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import AVFoundation
import Material

class FeedPosts: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.collectionViewBackground
        cv.dataSource = self
        cv.delegate = self
        cv.bounces = false
        return cv
    }()

    let images: [UIImage] = [UIImage(named: "image1")!, UIImage(named: "image2")!, UIImage(named: "image3")!, UIImage(named: "image4")!, UIImage(named: "image5")!, UIImage(named: "image6")!]

    private var lastCollectionViewContentOffset: CGFloat = 0
    var viewController = MainViewController()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        backgroundColor = .collectionViewBackground

        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)

        collectionView.register(FeedPostCell.self, forCellWithReuseIdentifier: "cell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastCollectionViewContentOffset > scrollView.contentOffset.y {
//            print("Scrolled up")
            viewController.toggleNewPostButton(hide: false)
        } else if self.lastCollectionViewContentOffset < scrollView.contentOffset.y {
//            print("scrolled down")
            viewController.toggleNewPostButton(hide: true)
        }
//        print(abs(self.lastCollectionViewContentOffset - scrollView.contentOffset.y))
        self.lastCollectionViewContentOffset = scrollView.contentOffset.y
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeedPostCell
        cell.postImage.image = images[indexPath.item]

        // tap gesture for topView
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapGestureAction(_:)))
        cell.topView.addGestureRecognizer(profileTapGesture)

        // tap gesture for post image
        let postImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(postImageTapGestureAction(_:)))
        postImageTapGesture.numberOfTapsRequired = 2
        cell.postImage.addGestureRecognizer(postImageTapGesture)

        // tap gesture for likesLabel
        let likesTapGesture = UITapGestureRecognizer(target: self, action: #selector(likesLabelTapGestureAction(_:)))
        cell.likes.addGestureRecognizer(likesTapGesture)

        // tap gesture for repostsLabel
        let repostsTapGesture = UITapGestureRecognizer(target: self, action: #selector(repostsLabelTapGestureAction(_:)))
        cell.reposts.addGestureRecognizer(repostsTapGesture)

        // target for button
        cell.likeButton.addTarget(self, action: #selector(likesButtonAction(_:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(shareButtonAction(_:)), for: .touchUpInside)
        cell.moreButton.addTarget(self, action: #selector(moreButtonAction(_:)), for: .touchUpInside)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func getCellSize(indexPath: IndexPath) -> CGSize {
        let maxWidthInPixels: CGFloat = Constraints.screenWidth() * 0.95 * UIScreen.main.scale
        let maxHeightInPixels: CGFloat = Constraints.screenHeight() * 0.6 * UIScreen.main.scale
        let imageViewMaxFrame = AVMakeRect(aspectRatio: images[indexPath.item].size,
                                           insideRect: CGRect(origin: CGPoint.zero, size: CGSize(width: maxWidthInPixels, height: maxHeightInPixels)))
        let imageHeightInPoints = imageViewMaxFrame.height / UIScreen.main.scale
        let height: CGFloat = 16 + 48 + 8 + imageHeightInPoints + 8 + 28 + 16 + 1
        let width: CGFloat = Constraints.screenWidth()
        return CGSize(width: width, height: height)
    }

    @objc func profileTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on profile View")
    }

    @objc func postImageTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Post Image View")
    }

    @objc func likesLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Likes Label")
    }

    @objc func repostsLabelTapGestureAction(_ sender: UITapGestureRecognizer) {
        print("Tapped on Reposts Label")
    }

    @objc func likesButtonAction(_ sender: UIButton) {
        print("Tapped on Like Button")
        sender.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        sender.isSelected = !sender.isSelected
        sender.tintColor = (sender.isSelected) ? UIColor.materialBlue : UIColor.white
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: { [weak self] in
            sender.transform = .identity
        }, completion: nil)
        if let indexPath = getTappedCellIndexForButton(button: sender) {
            let cell = collectionView.cellForItem(at: indexPath) as! FeedPostCell
            cell.heartImageView.alpha = 0.75
            cell.heartImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: { [weak self] in
                cell.heartImageView.transform = .identity
            }, completion: { (finished) in
                cell.heartImageView.alpha = 0
            })
        }
    }

    @objc func shareButtonAction(_ sender: UIButton) {
        print("Tapped on Share Button")
    }

    @objc func moreButtonAction(_ sender: UIButton) {
        print("Tapped on More Button")
        sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: { [weak self] in
            sender.transform = .identity
        }, completion: nil)
    }

    // gets the indexpath at the tap position
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