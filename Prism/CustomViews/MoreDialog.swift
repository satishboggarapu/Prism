//
// Created by Satish Boggarapu on 4/9/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material

class MoreDialog: UIViewController {

    // UIElements
    private var backgroundView: UIView!
    private var dialogView: UIView!
    var reportButton: UIButton!
    var shareButton: UIButton!
    var deleteButton: UIButton!

    private var shouldDisplayDeleteButton: Bool!

    convenience init(prismPost: PrismPost) {
        self.init(nibName: nil, bundle: nil)
        shouldDisplayDeleteButton = (prismPost.getUid() == CurrentUser.prismUser.getUid()) ? true : false
        setupView()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    private func setupView() {
        initializeBackgroundView()
        initializeDialogView()

        let leftMargin = (ScreenType.screenType == ScreenType.iPhoneSE_1136) ? 20 : 30

        view.addConstraintsWithFormat(format: "H:|[v0]|", views: backgroundView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: backgroundView)

        view.addConstraintsWithFormat(format: "H:|-\(leftMargin)-[v0]-\(leftMargin)-|", views: dialogView)
        view.addConstraintsWithFormat(format: "V:[v0]", views: dialogView)
        view.addConstraint(NSLayoutConstraint(item: dialogView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))

        setupDialogView()

    }
    
    private func setupDialogView() {
        initializeReportButton()
        initializeShareButton()

        dialogView.addConstraintsWithFormat(format: "H:|-24-[v0]-24-|", views: reportButton)
        dialogView.addConstraintsWithFormat(format: "H:|-24-[v0]-24-|", views: shareButton)

        if shouldDisplayDeleteButton {
            initializeDeleteButton()
            dialogView.addConstraintsWithFormat(format: "H:|-24-[v0]-24-|", views: deleteButton)
            dialogView.addConstraintsWithFormat(format: "V:|-24-[v0]-8-[v1]-8-[v2]-24-|", views: reportButton, shareButton, deleteButton)
        } else {
            dialogView.addConstraintsWithFormat(format: "V:|-24-[v0]-8-[v1]-24-|", views: reportButton, shareButton)
        }

    }

    private func initializeBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.addSubview(backgroundView)

        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tapGesture)
    }

    private func initializeDialogView() {
        dialogView = UIView()
        dialogView.backgroundColor = .customAlertDialogBackground
        dialogView.layer.cornerRadius = 2
        dialogView.layer.shadowColor = UIColor.black.cgColor
        dialogView.layer.shadowOpacity = 0.5
        dialogView.layer.shadowOffset = CGSize.zero
        dialogView.layer.shadowRadius = 5
        view.insertSubview(dialogView, aboveSubview: backgroundView)
    }

    private func initializeReportButton() {
        reportButton = UIButton()
        reportButton.setTitle("Report post", for: .normal)
        reportButton.setTitleColor(.customAlertDialogButtonTitleColor, for: .normal)
        reportButton.titleLabel?.font = RobotoFont.medium(with: 16)
        reportButton.contentHorizontalAlignment = .left
//        reportButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        dialogView.addSubview(reportButton)
    }

    private func initializeShareButton() {
        shareButton = UIButton()
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.customAlertDialogButtonTitleColor, for: .normal)
        shareButton.titleLabel?.font = RobotoFont.medium(with: 16)
        shareButton.contentHorizontalAlignment = .left
//        shareButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        dialogView.addSubview(shareButton)
    }

    private  func initializeDeleteButton() {
        deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.customAlertDialogButtonTitleColor, for: .normal)
        deleteButton.titleLabel?.font = RobotoFont.medium(with: 16)
        deleteButton.contentHorizontalAlignment = .left
        deleteButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        dialogView.addSubview(deleteButton)
    }


    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}
