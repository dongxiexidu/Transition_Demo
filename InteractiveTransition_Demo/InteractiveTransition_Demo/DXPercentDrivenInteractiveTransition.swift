//
//  DXPercentDrivenInteractiveTransition.swift
//  InteractiveTransition_Demo
//
//  Created by fashion on 2018/8/6.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

/// 手势的方向
enum InteractiveTransitionGestureDirection {
    case left
    case right
    case up
    case down
}
/// 手势控制哪种转场
enum InteractiveTransitionType {
    case present
    case dismiss
    case push
    case pop
}


class DXPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    /// 记录是否开始手势，用于判断pop操作是手势触发还是返回键触发
    public var isInteration : Bool = false
    
    /// 触发手势present的时候的config，config中初始化并present需要弹出的控制器
    public var presentConifg : (()->())?
    
    /// 触发手势push的时候的config，config中初始化并push需要弹出的控制器
    public var pushConifg : (()->())?
    
    private weak var viewController : UIViewController!
    private var direction = InteractiveTransitionGestureDirection.left
    private var type = InteractiveTransitionType.present
    
    convenience init(type: InteractiveTransitionType, direction: InteractiveTransitionGestureDirection) {
        self.init()
        self.direction = direction
        self.type = type
    }
    
    func addPanGestureForViewController(viewController: UIViewController)  {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handleGesture(panGesture:)))
        self.viewController = viewController
        viewController.view.addGestureRecognizer(pan)
    }
    
    // 手势过渡的过程
    @objc func handleGesture(panGesture: UIPanGestureRecognizer){
        // 手势百分比
        var percent : CGFloat = 0
        
        switch direction {
        case .left:
            let transitionX = -panGesture.translation(in: panGesture.view).x
            if let view = panGesture.view {
                percent = transitionX / view.frame.size.width
            }
            
        case .right:
            let transitionX = panGesture.translation(in: panGesture.view).x
            if let view = panGesture.view {
                percent = transitionX / view.frame.size.width
            }
        case .up:
            let transitionY = -panGesture.translation(in: panGesture.view).y
            if let view = panGesture.view {
                percent = transitionY / view.frame.size.width
            }
        case .down:
            let transitionY = panGesture.translation(in: panGesture.view).y
            if let view = panGesture.view {
                percent = transitionY / view.frame.size.width
            }
        }
        
        switch panGesture.state {
        case .began:
            
            isInteration = true
            startGesture()
        case .changed:
            
            // 手势过程中，设置pop过程进行的百分比
            update(percent)
        case .ended:
            
            // 手势完成后结束标记
            isInteration = false
            // 判断移动距离是否过半，过半则完成转场操作
            if percent > 0.5 {
                finish()
            }else{ // 取消转场操作
                cancel()
            }
        default:
            break
        }
 
    }

    
    private func startGesture()  {
        switch type {
        case .present:
            presentConifg?()
        case .dismiss:
            viewController.dismiss(animated: true, completion: nil)
        case .push:
            pushConifg?()
        case .pop:
            viewController.navigationController?.popViewController(animated: true)
        }
    }

}
