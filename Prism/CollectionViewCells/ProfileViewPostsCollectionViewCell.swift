//
//  ProfileViewPostsCollectionViewCell.swift
//  Prism
//
//  Created by Satish Boggarapu on 5/12/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

class ProfileViewPostsCollectionViewCell: UICollectionViewCell {

    var prismPostImage: CustomImageView!
    var prismPost: PrismPost!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        initializePrismPostImage()

        addConstraintsWithFormat(format: "H:|[v0]|", views: prismPostImage)
        addConstraintsWithFormat(format: "V:|[v0]|", views: prismPostImage)
    }

    private func initializePrismPostImage() {
        prismPostImage = CustomImageView()
        prismPostImage.contentMode = .scaleAspectFit
        prismPostImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(prismPostImage)
    }

    public func loadPostImage() {
        let imageUrl = prismPost.getImage()
        let postId = prismPost.getPostId()
        prismPostImage.loadImageUsingUrlString(imageUrl, postID: postId) { (result, image) in
            // do nothing
        }
    }
    
}
