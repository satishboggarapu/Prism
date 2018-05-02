//
//  ProfileViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 5/1/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import MaterialComponents
import Material

class ProfileViewController: UIViewController {

    private var backButton: FABButton!
    private var editAccountButton: FABButton!
    private var profileNavigationView: UIView!
    private var profileView: UIView!

    var prismPost: PrismPost!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        initializeProfileView()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.barTintColor = .statusBarBackground

        // left button
        backButton = FABButton()
        backButton.backgroundColor = .clear
        backButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        backButton.setTitle("", for: .normal)
        backButton.setImage(Icons.ARROW_BACK_24?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.setImage(Icons.ARROW_BACK_24?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        backButton.imageView?.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        // right button
        editAccountButton = FABButton()
        editAccountButton.backgroundColor = .clear
        editAccountButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        editAccountButton.setTitle("", for: .normal)
        editAccountButton.setImage(Icons.ACCOUNT_EDIT_24?.withRenderingMode(.alwaysTemplate), for: .normal)
        editAccountButton.setImage(Icons.ACCOUNT_EDIT_24?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        editAccountButton.imageView?.tintColor = .white
        editAccountButton.addTarget(self, action: #selector(editAccountButtonAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editAccountButton)

        // title view
        profileNavigationView = UIView()
        profileNavigationView.backgroundColor = .clear
        profileNavigationView.alpha = 0.0
        navigationItem.titleView = profileNavigationView

        let profileImage = CustomImageView()
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = 36/2
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false

        let profilePicture = prismPost.getPrismUser().getProfilePicture().getLowResDefaultProfilePic()
        if profilePicture != nil {
            profileImage.image = profilePicture
        } else {
            let imageUrl = prismPost.getPrismUser().getProfilePicture().profilePicUriString
            profileImage.loadImageUsingUrlString(imageUrl, postID: prismPost.getUid())
            profileImage.layer.borderWidth = 1
            profileImage.layer.borderColor = UIColor.white.cgColor
        }

        let username = UILabel()
        username.textColor = UIColor.white
        username.text = prismPost.getPrismUser().getUsername()
        username.font = RobotoFont.bold(with: 17)
        username.translatesAutoresizingMaskIntoConstraints = false

        profileNavigationView.addSubview(profileImage)
        profileNavigationView.addSubview(username)

        profileNavigationView.addConstraintsWithFormat(format: "V:[v0(36)]", views: profileImage)
        profileNavigationView.addConstraint(NSLayoutConstraint(item: profileImage, attribute: .centerY, relatedBy: .equal, toItem: profileNavigationView, attribute: .centerY, multiplier: 1, constant: 0))
        profileNavigationView.addConstraintsWithFormat(format: "V:[v0]", views: username)
        profileNavigationView.addConstraint(NSLayoutConstraint(item: username, attribute: .centerY, relatedBy: .equal, toItem: profileNavigationView, attribute: .centerY, multiplier: 1, constant: 0))
        profileNavigationView.addConstraintsWithFormat(format: "H:|-[v0(36)]-[v1]", views: profileImage, username)


    }

    private func initializeProfileView() {
        profileView = UIView()
        profileView.backgroundColor = .statusBarBackground
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileView)

        view.addConstraintsWithFormat(format: "H:|[v0]|", views: profileView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: profileView)

        let username = UILabel()
        username.text = prismPost.getPrismUser().getUsername()
        username.textColor = .white
        username.font = RobotoFont.bold(with: 20)
        username.textAlignment = .center
        username.translatesAutoresizingMaskIntoConstraints = false
        profileView.addSubview(username)

        let fullName = UILabel()
        fullName.text = prismPost.getPrismUser().getFullName()
        fullName.textColor = .white
        fullName.font = RobotoFont.light(with: 15)
        fullName.textAlignment = .center
        fullName.translatesAutoresizingMaskIntoConstraints = false
        profileView.addSubview(fullName)

        profileView.addConstraintsWithFormat(format: "H:|[v0]|", views: username)
        profileView.addConstraintsWithFormat(format: "H:|[v0]|", views: fullName)
        profileView.addConstraintsWithFormat(format: "V:|-[v0]-4-[v1]", views: username, fullName)


    }

    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }

    @objc private func editAccountButtonAction() {

    }


}
