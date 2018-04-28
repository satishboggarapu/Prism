//
// Created by Satish Boggarapu on 4/10/18.
// Copyright (c) 2018 Satish Boggarapu. All rights reserved.
//

import UIKit

@objc protocol ZoomingViewController {
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> CustomImageView?
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView?
}

enum TransitionState {
    case INITIAL
    case FINAL
}

class ZoomTransitioningDelegate: NSObject {

    var transitionDuration = 0.5
    var operation: UINavigationControllerOperation = .none
    private let zoomScale = CGFloat(15)
    private let backgroundScale = CGFloat(0.7)

    typealias ZoomingViews = (otherView: UIView, imageView: UIView)

    func configureViews(for state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground: ZoomingViews, viewsInForeground: ZoomingViews, snapshotViews: ZoomingViews) {
        switch state {
            case .INITIAL:
                backgroundViewController.view.transform = CGAffineTransform.identity
                backgroundViewController.view.alpha = 1

                snapshotViews.imageView.frame = containerView.convert(viewsInBackground.imageView.frame, from: viewsInBackground.imageView.superview)

            case .FINAL:
//                backgroundViewController.view.transform = CGAffineTransform(scaleX: backgroundScale, y: backgroundScale)
                backgroundViewController.view.alpha = 0

                snapshotViews.imageView.frame = containerView.convert(viewsInForeground.imageView.frame, from: viewsInForeground.imageView.superview)

        }
    }
}

extension ZoomTransitioningDelegate: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView

        var backgroundViewController = fromViewController
        var foregroundViewController = toViewController

        if operation == .pop {
            backgroundViewController = toViewController
            foregroundViewController = fromViewController
        }

        let maybeBackgroundImageView = (backgroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)
        let maybeForegroundImageView = (foregroundViewController as? ZoomingViewController)?.zoomingImageView(for: self)

        assert(maybeBackgroundImageView != nil, "Cannot find imageView in backgroundVC")
        assert(maybeForegroundImageView != nil, "Cannot find imageView in foregroundVC")

        let backgroundImageView = maybeBackgroundImageView!
        let foregroundImageView = maybeForegroundImageView!

        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        let height = Helper.getImageHeightForPrismPostDetailViewController(backgroundImageView.image!)
        imageViewSnapshot.contentMode = .scaleAspectFit
        imageViewSnapshot.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: height)
//        imageViewSnapshot.translatesAutoresizingMaskIntoConstraints = false
//        imageViewSnapshot.layer.masksToBounds = true

        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        let foregroundViewBackgroundColor = foregroundViewController.view.backgroundColor
        foregroundViewController.view.backgroundColor = .clear
        containerView.backgroundColor = .collectionViewBackground

        containerView.addSubview(backgroundViewController.view)
        containerView.addSubview(foregroundViewController.view)
        containerView.addSubview(imageViewSnapshot)

//        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: imageViewSnapshot)
//        containerView.addConstraintsWithFormat(format: "V:|-\(Constraints.navigationBarHeight())-[v0]|", views: imageViewSnapshot)

        var preTransitionState = TransitionState.INITIAL
        var postTransitionState = TransitionState.FINAL

        if operation == .pop {
            preTransitionState = .FINAL
            postTransitionState = .INITIAL
        }

//        if preTransitionState == TransitionState.FINAL {
//            fromViewController.navigationController?.navigationBar.isTranslucent = false
//        }

        configureViews(for: preTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snapshotViews: (imageViewSnapshot, imageViewSnapshot))

        foregroundViewController.view.layoutIfNeeded()

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, animations: {
            self.configureViews(for: postTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundImageView, backgroundImageView), viewsInForeground: (foregroundImageView, foregroundImageView), snapshotViews: (imageViewSnapshot, imageViewSnapshot))
        }, completion: { (finished) in
            backgroundViewController.view.transform = CGAffineTransform.identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

extension ZoomTransitioningDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is ZoomingViewController && toVC is ZoomingViewController {
            self.operation = operation
            return self
        } else {
            return nil
        }
    }
}