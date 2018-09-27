//
//  ImageCropViewController.swift
//  Prism
//
//  Created by Satish Boggarapu on 9/27/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import PinLayout

class ImageCropViewController: UIViewController {

    // MARK: UIElements
    private var backButton: UIButton!
    private var newImageButton: UIButton!
    private var cameraButton: UIButton!
    private var nextButton: UIButton!
    private var imageView: UIImageView!

    var selectedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .statusBarBackground

        setupNavigationBar()
        setupImageView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imageView.pin.horizontally().top(to: (navigationController?.navigationBar.edge.bottom)!).bottom(to: view.edge.bottom).margin(16)
    }

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)

        backButton = UIButton(type: .custom)
        backButton.setImage(Icons.ARROW_BACK_24, for: .normal)
        backButton.setTitle(nil, for: .normal)
        backButton.imageView?.tintColor = .white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)

        newImageButton = UIButton(type: .custom)
        newImageButton.setImage(Icons.IMAGE_24, for: .normal)
        newImageButton.setTitle(nil, for: .normal)
        newImageButton.imageView?.tintColor = .white
        newImageButton.addTarget(self, action: #selector(newImageButtonAction), for: .touchUpInside)

        cameraButton = UIButton(type: .custom)
        cameraButton.setImage(Icons.CAMERA_24, for: .normal)
        cameraButton.setTitle(nil, for: .normal)
        cameraButton.imageView?.tintColor = .white
        cameraButton.addTarget(self, action: #selector(cameraButtonAction), for: .touchUpInside)

        nextButton = UIButton(type: .custom)
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = SourceSansFont.bold(with: 14)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)

        let space1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space1.width = 16
        let space2 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space2.width = 16

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: nextButton), space1, UIBarButtonItem(customView: cameraButton), space2, UIBarButtonItem(customView: newImageButton)]
    }
    
    private func setupImageView() {
        imageView = UIImageView()
        imageView.image = selectedImage
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }

    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func newImageButtonAction() {
        
    }

    @objc private func cameraButtonAction() {
        
    }

    @objc private func nextButtonAction() {
        
    }
}
