//
// Created by Satish Boggarapu on 3/7/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
// TODO: Delete this
class ImageMenuCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = Icons.IMAGE_FILTER_24?.withRenderingMode(.alwaysTemplate)
        image.tintColor = UIColor.white
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            imageView.tintColor = newValue ? UIColor.materialBlue : UIColor.white
        }
    }
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            imageView.tintColor = newValue ? UIColor.materialBlue : UIColor.white
        }
    }

    func setupViews() {
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(24)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(24)]", views: imageView)

        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }

}
