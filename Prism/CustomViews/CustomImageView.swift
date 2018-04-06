//
// Created by Satish Boggarapu on 4/4/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

// TODO: Clean this up
protocol CustomImageViewDelegate: class {
    func imageLoaded(postID: String, imageSize: CGSize)
}

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    weak var delegate: CustomImageViewDelegate?
    var imageUrlString: String?
    
    let activityIndicator = MDCActivityIndicator()

    func loadImageUsingUrlString(_ urlString: String, postID: String, completionHandler: @escaping ((_ exist : Bool, _ image: UIImage) -> Void)) {
        
        activityIndicator.indicatorMode = .indeterminate
        activityIndicator.radius = 10
        activityIndicator.strokeWidth = 2
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = [UIColor.materialBlue]
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageUrlString = urlString
        let url = URL(string: urlString)
        image = nil
        activityIndicator.startAnimating()

        if let imageFromCache = imageCache.object(forKey: postID as NSString) {
            self.image = imageFromCache
            self.delegate?.imageLoaded(postID: postID, imageSize: imageFromCache.size)
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            completionHandler(true, imageFromCache)
            return
        }

        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                completionHandler(false, UIImage())
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                    completionHandler(true, imageToCache!)
                    self.delegate?.imageLoaded(postID: postID, imageSize: (imageToCache?.size)!)
                }
                imageCache.setObject(imageToCache!, forKey: postID as NSString)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            })
        }).resume()
    }
    
    func loadImageUsingUrlString(_ urlString: String, postID: String) {
        
        activityIndicator.indicatorMode = .indeterminate
        activityIndicator.radius = 10
        activityIndicator.strokeWidth = 2
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = [UIColor.materialBlue]
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageUrlString = urlString
        let url = URL(string: urlString)
        image = nil
        activityIndicator.startAnimating()
        
        if let imageFromCache = imageCache.object(forKey: postID as NSString) {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: postID as NSString)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            })
        }).resume()
    }

}
