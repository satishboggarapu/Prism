//
// Created by Satish Boggarapu on 3/9/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material

class Settings: UICollectionViewCell {

    var profileView: UIView!
    var profileImageView: UIImageView!
    var userName: UILabel!

    let cellHeight: CGFloat = 44

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    private func initializeProfileView() {
        let profileViewHeight: CGFloat = cellHeight * 3

        profileView = UIView()

        profileImageView = UIImageView()
        profileImageView.image = UIImage(icon: .SPLASH_SCREEN_ICON)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
//        profileImageView.layer.cornerRadius =
//        profileImageView.layer.borderWidth = 2
//        profileImageView.layer.borderColor = UIColor.white.cgColor

        userName = UILabel()
        userName.text = "Satish Boggarapu"
        userName.textColor = UIColor.white
        userName.font = RobotoFont.medium(with: 17)

        let viewProfileLabel = UILabel()
        viewProfileLabel.text = "View your profile"
        viewProfileLabel.textColor = UIColor.gray
        viewProfileLabel.font = RobotoFont.medium(with: 17)

//        let rightView = UIView()
//        rightView.addSubview(userName)
//        rightView.addSubview(viewProfileLabel)
//        rightView.addConstraintsWithFormat(format: "", views: <#T##UIView...##UIKit.UIView...#>)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}