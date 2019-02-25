//
//  AnimatedTransitioning.swift
//  BookManagement
//
//  Created by yoshino1010 on 2018/12/21.
//  Copyright © 2018年 yoshino1010. All rights reserved.
//

import UIKit

class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    var presenting = false
    let kDuration: Double
    
    init(duration: Double) {
        kDuration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kDuration
    }
    
    final func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC: UIViewController? = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC: UIViewController? = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        guard let _fromVC = fromVC, let _toVC = toVC else { return }
        if presenting {
            present(transitionContext: transitionContext, fromView: _fromVC.view, toView: _toVC.view)
        } else {
            dismiss(transitionContext: transitionContext, fromView: _fromVC.view, toView: _toVC.view)
        }
    }
    
    func present(transitionContext: UIViewControllerContextTransitioning, fromView: UIView, toView: UIView) {}
    func dismiss(transitionContext: UIViewControllerContextTransitioning, fromView: UIView, toView: UIView) {}
}
