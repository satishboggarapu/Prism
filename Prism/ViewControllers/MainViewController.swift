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

class MainViewController: UIViewController{

    var navigationBar: NavigationBar!
    var menuBar: MenuBar!
    var collectionView: UICollectionView!
    var newPostButton: FABButton!
    let colors = [UIColor.white, UIColor.blue, UIColor.gray, UIColor.green]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        initializeMenuBar()
        initializeCollectionView()
        initializeNewPostButton()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.statusBarBackground
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.setHidesBackButton(true, animated: false)

        let navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: 0, width: 100, height: 44)

        let iconImageView = UIImageView(image: UIImage(icon: .SPLASH_SCREEN_ICON))
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

    private func initializeMenuBar() {
//        self.navigationController?.hidesBarsOnSwipe = true

        menuBar = MenuBar()
        menuBar.homeController = self
        menuBar.translatesAutoresizingMaskIntoConstraints = false
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
        collectionView?.register(FeedPosts.self, forCellWithReuseIdentifier: "FeedPosts")
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
    }

    @objc func signOutButtonAction(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        print("user logged out")
        self.navigationController?.popViewController(animated: true)
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
}

extension MainViewController: UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
     }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
     }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedPosts", for: indexPath)
//        cell.backgroundColor = colors[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: view.frame.height - 50)
    }
}
