//
//  BooksListToRegistBooksAnimation.swift
//  BookManagement
//
//  Created by yoshino1010 on 2018/12/21.
//  Copyright © 2018年 yoshino1010. All rights reserved.
//

import UIKit

class BooksListToRegistBooksAnimation: AnimatedTransitioning {
    let rectAroundCircle = { (radius: CGFloat, center: CGPoint) -> CGRect in
        return CGRect(origin: center, size: .zero).insetBy(dx: -radius, dy: -radius)
    }
    
    var complationHandler: (() -> Void)?
    
    var startPoint: CGPoint? = nil
    
    override func present(transitionContext: UIViewControllerContextTransitioning, fromView: UIView, toView: UIView) {
        let containerView = transitionContext.containerView
        
        guard let _startPoint = startPoint else { return }
        
        let x = max(_startPoint.x, containerView.frame.width - _startPoint.x)
        let y = max(_startPoint.y, containerView.frame.height - _startPoint.y)
        let radius = sqrt(x * x + y * y)
        
        complationHandler = {
            transitionContext.completeTransition(true)
        }
        
        let zeroPath = CGPath(ellipseIn: rectAroundCircle(0, _startPoint), transform: nil)
        let fullPath = CGPath(ellipseIn: rectAroundCircle(radius, _startPoint), transform: nil)
        
        containerView.insertSubview(toView, aboveSubview: fromView)
        
        addAnimation(viewController: toView, fromValue: zeroPath, toValue: fullPath)
        
        startPoint = nil
    }
    
    override func dismiss(transitionContext: UIViewControllerContextTransitioning, fromView: UIView, toView: UIView) {
        let containerView = transitionContext.containerView
        
        guard let _startPoint = startPoint else { return }
        
        let x = max(_startPoint.x, containerView.frame.width - _startPoint.x)
        let y = max(_startPoint.y, containerView.frame.height - _startPoint.y)
        let radius = sqrt(x * x + y * y)
        
        complationHandler = {
            transitionContext.completeTransition(true)
        }
        
        let zeroPath = CGPath(ellipseIn: rectAroundCircle(0, _startPoint), transform: nil)
        let fullPath = CGPath(ellipseIn: rectAroundCircle(radius, _startPoint), transform: nil)
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        addAnimation(viewController: fromView, fromValue: fullPath, toValue: zeroPath)
        
        startPoint = nil
    }
    
    private func addAnimation(viewController: UIView, fromValue: CGPath, toValue: CGPath) {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = kDuration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        viewController.layer.mask = CAShapeLayer()
        viewController.layer.mask?.add(animation, forKey: nil)
    }
}

extension BooksListToRegistBooksAnimation: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        complationHandler?()
    }
}
