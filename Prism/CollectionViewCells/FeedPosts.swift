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

}