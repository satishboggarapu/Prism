//
//  PrismPostDetailViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 4/10/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material

class PrismPostDetailViewController: UIViewController {

    var image: UIImage!
    var imageView: CustomImageView!
    var prismPost: PrismPost!

    private var scrollView: UIScrollView!
    private var backButton: UIButton!
    private var moreButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .statusBarBackground

        let height = Helper.getImageHeightForPrismPostDetailViewController(image)
        
        scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        view.addSubview(scrollView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)

        imageView = CustomImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: height)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: height)


        initializeBackButton()
        initializeMoreButton()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initializeBackButton() {
        backButton = UIButton()
        backButton.setTitle("", for: .normal)
        backButton.setImage(Icon.arrowBack?.tint(with: .white), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)

        view.addConstraintsWithFormat(format: "H:|-4-[v0(40)]", views: backButton)
        view.addConstraintsWithFormat(format: "V:|-24-[v0(40)]", views: backButton)
    }
    
    private func initializeMoreButton() {
        moreButton = UIButton()
        moreButton.setTitle("", for: .normal)
        moreButton.setImage(Icons.MORE_VERTICAL_DOTS_24?.tint(with: .white), for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        view.addSubview(moreButton)
        
        view.addConstraintsWithFormat(format: "H:[v0(40)]-4-|", views: moreButton)
        view.addConstraintsWithFormat(format: "V:|-24-[v0(40)]", views: moreButton)
    }
    
    @objc func backButtonAction() {
        print("back button")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreButtonAction() {
        let moreDialog = MoreDialog(prismPost: prismPost)
        moreDialog.delegate = self
        moreDialog.providesPresentationContextTransitionStyle = true
        moreDialog.definesPresentationContext = true
        moreDialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        moreDialog.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(moreDialog, animated: true, completion: nil)
    }

}

extension PrismPostDetailViewController: MoreDialogDelegate {
    func moreDialogReportButtonAction() {

    }

    func moreDialogShareButtonAction() {

    }

    func moreDialogDeleteButtonAction() {
//        DatabaseAction.deletePost(prismPost, completionHandler: { (result) in
//            if result {
//                self.delegate?.deletePost(self.prismPost)
//            }
//        })
    }
}

extension PrismPostDetailViewController: ZoomingViewController {

    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }

    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> CustomImageView? {
        return imageView
    }

}
