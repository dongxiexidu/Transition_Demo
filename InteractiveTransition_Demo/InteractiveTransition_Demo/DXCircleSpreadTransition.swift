//
//  DXCircleSpreadTransition.swift
//  InteractiveTransition_Demo
//
//  Created by fashion on 2018/8/6.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

enum CircleSpreadTransitionType {
    case present
    case dismiss
}

class DXCircleSpreadTransition: NSObject {
    
    var type = CircleSpreadTransitionType.present
    
    convenience init(type: CircleSpreadTransitionType) {
        self.init()
        self.type = type
    }
    
    
    func presentAnimation(transitionContext : UIViewControllerContextTransitioning) {
        if let toVC = transitionContext.viewController(forKey: .to) , let fromVC = transitionContext.viewController(forKey: .from) as? UINavigationController{
            if let tempVC = fromVC.viewControllers.last as? CircleSpreadController{
                
                let containerView = transitionContext.containerView
                containerView.addSubview(toVC.view)
                
                // 画两个圆路径
                let startCycle = UIBezierPath.init(ovalIn: tempVC.button.frame)
                let x : CGFloat = max(tempVC.button.frame.origin.x, containerView.frame.size.width-tempVC.button.frame.origin.x)
                let y : CGFloat = max(tempVC.button.frame.origin.y, containerView.frame.size.height-tempVC.button.frame.origin.y)
                
                let radius : CGFloat = sqrt(pow(x, 2) + pow(y, 2))
                let endCycle = UIBezierPath.init(arcCenter: containerView.center, radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
                
                // 创建CAShapeLayer进行遮盖
                let maskLayer = CAShapeLayer.init()
                maskLayer.path = endCycle.cgPath
                
                // 将maskLayer作为toVC.View的遮盖
                toVC.view.layer.mask = maskLayer
                
                // 创建路径动画
                let animation = CABasicAnimation.init(keyPath: "path")
                
                animation.delegate = self
                // 动画是加到layer上的，所以必须为CGPath
                animation.fromValue = startCycle.cgPath
                animation.toValue = endCycle.cgPath
                animation.duration = transitionDuration(using: transitionContext)
                
                animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                animation.setValue(transitionContext, forKey: "transitionContext")
                animation.setValue(maskLayer, forKey: "mask")
                
                maskLayer.add(animation, forKey: "path")
            }
            
        }
        
    }
    
    
    func dismissAnimation(transitionContext : UIViewControllerContextTransitioning) {
        
        if let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? UINavigationController, let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) {
            if let tempVC = toVC.viewControllers.last as? CircleSpreadController{
                
                let containerView = transitionContext.containerView
                containerView.insertSubview(toVC.view, at: 0)
                
                // 画两个圆路径
                let radius : CGFloat = sqrt(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2
                let startCycle = UIBezierPath.init(arcCenter: containerView.center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

                let endCycle = UIBezierPath.init(ovalIn: tempVC.button.frame)
                
                
                // 创建CAShapeLayer进行遮盖
                let maskLayer = CAShapeLayer.init()
                maskLayer.fillColor = UIColor.green.cgColor
                maskLayer.path = endCycle.cgPath
                fromVC.view.layer.mask = maskLayer
                
                // 创建路径动画
                let animation = CABasicAnimation.init(keyPath: "path")
                animation.delegate = self
                animation.isRemovedOnCompletion = true
                
                animation.fromValue = startCycle.cgPath
                animation.toValue = endCycle.cgPath
                animation.duration = transitionDuration(using: transitionContext)
                
                animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                animation.setValue(transitionContext, forKey: "transitionContext")
                animation.setValue(maskLayer, forKey: "mask")
                
                maskLayer.add(animation, forKey: "path")
                
            }
            
        }
    }
}

extension DXCircleSpreadTransition : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        switch type {
        case .present:
            let transitionContext : UIViewControllerContextTransitioning = anim.value(forKey: "transitionContext") as! UIViewControllerContextTransitioning
            transitionContext.completeTransition(true)
        case .dismiss:
            let transitionContext : UIViewControllerContextTransitioning = anim.value(forKey: "transitionContext") as! UIViewControllerContextTransitioning
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if transitionContext.transitionWasCancelled {
                transitionContext.viewController(forKey: .from)?.view.layer.mask = nil
            }
        }
        let mask = anim.value(forKey: "mask") as? CAShapeLayer
        mask?.removeFromSuperlayer()
        
    }
}

extension DXCircleSpreadTransition : UIViewControllerAnimatedTransitioning {
    
    // 如何执行过渡动画
    func animateTransition(using transitionContext : UIViewControllerContextTransitioning) {
        switch type {
        case .present:
            presentAnimation(transitionContext: transitionContext)
        case .dismiss:
            dismissAnimation(transitionContext: transitionContext)
        }
    }
    
    // 执行过渡动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
}
