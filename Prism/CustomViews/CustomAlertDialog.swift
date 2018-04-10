//
//  CustomAlertDialog.swift
//  Prism
//
//  Created by Satish Boggarapu on 4/7/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Material

// TODO: Clean up and comment

class CustomAlertDialog: UIViewController {

    // UIElements
    private var backgroundView: UIView!
    private var alertView: UIView!
    private var buttonView: UIView!
    private var textLabel: UILabel!
    private var cancelButton: UIButton!
    var okayButton: UIButton!


    private var titleText: String!
    private var cancelButtonText: String!
    private var okayButtonText: String!

    convenience init(title: String, cancelButtonText: String, okayButtonText: String) {
        self.init(nibName: nil, bundle: nil)
        self.titleText = title
        self.cancelButtonText = cancelButtonText
        self.okayButtonText = okayButtonText
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
//        setupView()
    }

    private func setupView() {
        initializeBackgroundView()
        initializeAlertView()

        let leftMargin = (ScreenType.screenType == ScreenType.iPhoneSE_1136) ? 20 : 30

        view.addConstraintsWithFormat(format: "H:|[v0]|", views: backgroundView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: backgroundView)

        view.addConstraintsWithFormat(format: "H:|-\(leftMargin)-[v0]-\(leftMargin)-|", views: alertView)
        view.addConstraintsWithFormat(format: "V:[v0]", views: alertView)
        view.addConstraint(NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0))

        setupAlertView()
    }

    private func setupAlertView() {
        initializeTextLabel()

        buttonView = UIView()
        alertView.addSubview(buttonView)
        initializeCancelButton()
        initializeOkayButton()

        buttonView.addConstraintsWithFormat(format: "H:[v0]-8-[v1]-8-|", views: cancelButton, okayButton)
        buttonView.addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: cancelButton)
        buttonView.addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: okayButton)

        alertView.addConstraintsWithFormat(format: "H:|-24-[v0]-24-|", views: textLabel)
        alertView.addConstraintsWithFormat(format: "H:|[v0]|", views: buttonView)
        alertView.addConstraintsWithFormat(format: "V:|-24-[v0]-24-[v1(52)]|", views: textLabel, buttonView)
    }

    private func initializeBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.addSubview(backgroundView)

        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tapGesture)
    }

    private func initializeAlertView() {
        alertView = UIView()
        alertView.backgroundColor = .customAlertDialogBackground
        alertView.layer.cornerRadius = 2
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 0.5
        alertView.layer.shadowOffset = CGSize.zero
        alertView.layer.shadowRadius = 5
        view.insertSubview(alertView, aboveSubview: backgroundView)
    }

    private func initializeTextLabel() {
        textLabel = UILabel()
        textLabel.text = titleText
        textLabel.textColor = UIColor.white
        textLabel.font = RobotoFont.medium(with: 17)
        textLabel.numberOfLines = 0
        alertView.addSubview(textLabel)
    }

    private func initializeCancelButton() {
        cancelButton = UIButton()
        cancelButton.setTitle(cancelButtonText, for: .normal)
        cancelButton.setTitleColor(.customAlertDialogButtonTitleColor, for: .normal)
        cancelButton.titleLabel?.font = RobotoFont.medium(with: 15)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        buttonView.addSubview(cancelButton)
    }

    private func initializeOkayButton() {
        okayButton = UIButton()
        okayButton.setTitle(okayButtonText, for: .normal)
        okayButton.setTitleColor(.customAlertDialogButtonTitleColor, for: .normal)
        okayButton.titleLabel?.font = RobotoFont.medium(with: 15)
        okayButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        okayButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        buttonView.addSubview(okayButton)
    }

    @objc func dismissView() {
        self.dismiss(animated: true)
    }

}
