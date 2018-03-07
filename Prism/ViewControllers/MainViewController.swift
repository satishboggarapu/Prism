//
//  MainViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 3/3/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    var navigationBar: NavigationBar!
    var menuBar: MenuBar!
//    var collectionView: UICollectionView!
    let colors = [UIColor.red, UIColor.blue, UIColor.gray, UIColor.green]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

//        addStatusBarViewWithBackground(UIColor.navigationBarColor)

//        initializeNavigationBar()
        initializeMenuBar()
        initializeCollectionView()
        addConstraints()

    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarColor
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

    }

//    private func animateIconImageView() {
//        UIView.animate(withDuration: 0.75, animations: {
//            self.navigationBar.
//        })
//    }

    private func initializeNavigationBar() {
        navigationBar = NavigationBar(type: .MainView)
        self.view.addSubview(navigationBar)
    }

    private func initializeMenuBar() {
        self.navigationController?.hidesBarsOnSwipe = true

        let redView = UIView()
        redView.backgroundColor = UIColor.navigationBarColor
        redView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)

        menuBar = MenuBar()
        menuBar.homeController = self
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)

//        redView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
//        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        menuBar.topAnchor.constraintEq
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }

    private func initializeCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
//        collectionView.layout
//        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        collectionView?.delegate = self
//        collectionView?.dataSource = self
//        collectionView?.showsVerticalScrollIndicator = false
//        collectionView?.bounces = false
        collectionView?.backgroundColor = UIColor.loginBackground
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.isPagingEnabled = true
//        self.view.addSubview(collectionView!)
    }

    private func addConstraints() {
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: navigationBar)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)

//        let verticalConstraint: String = "V:|-\(Constraints.statusBarHeight())-[v0(\(Constraints.navigationBarHeight()))][v1(50)][v2]|"
//        let verticalConstraint: String = "V:|[v0(50)][v1]|"
        let verticalConstraint: String = "V:|-50-[v0]|"
//        self.view.addConstraintsWithFormat(format: verticalConstraint, views: collectionView)
    }

    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width

        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
}

extension MainViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
     }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
     }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: view.frame.height - 50)
    }
}
