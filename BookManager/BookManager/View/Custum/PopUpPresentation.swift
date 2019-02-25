//
//  PupUpPresentation.swift
//  BookManagement
//
//  Created by yoshino1010 on 2019/01/03.
//  Copyright © 2019年 yoshino1010. All rights reserved.
//

import UIKit

class PopUpPresentation: UIPresentationController {
    private let view = UIView()
    private let margin = CGSize(width: CGFloat(50), height: CGFloat(100))
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView else { return }
        view.frame = container.bounds
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(modalViewTouched(_:)))
        
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .black
        view.alpha = 0.0
        
        container.insertSubview(view, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.view.alpha = 0.7
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate( alongsideTransition: { (context) in
            self.view.alpha = 0.0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.view.removeFromSuperview()
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width - margin.width, height: parentSize.height - margin.height)
    }
    
    @objc func modalViewTouched(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect()
        let containerBounds = containerView!.bounds
        let childContentSize = size(
            forChildContentContainer: presentedViewController,
            withParentContainerSize: containerBounds.size
        )
        presentedViewFrame.size = childContentSize
        presentedViewFrame.origin.x = margin.width / 2.0
        presentedViewFrame.origin.y = margin.height / 2.0
        
        return presentedViewFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        view.frame = containerView!.bounds
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 10
        presentedView?.clipsToBounds = true
        presentedView?.backgroundColor = .white
    }
}
