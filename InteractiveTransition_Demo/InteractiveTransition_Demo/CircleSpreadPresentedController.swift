//
//  CircleSpreadPresentedController.swift
//  InteractiveTransition_Demo
//
//  Created by fashion on 2018/8/6.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

class CircleSpreadPresentedController: UIViewController {

    var interactiveTransition : DXPercentDrivenInteractiveTransition!
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 50, width: view.frame.size.width, height: 50)
        button.backgroundColor = UIColor.clear
        button.setTitle("点我或向下滑动dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView.init(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "pic1")
        view.addSubview(imageView)

        view.addSubview(button)
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom

        interactiveTransition = DXPercentDrivenInteractiveTransition.init(type: .dismiss, direction: .down)
        interactiveTransition.addPanGestureForViewController(viewController: self)
    }

    deinit {
        print("CircleSpreadPresentedController-销毁了")
    }

    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension CircleSpreadPresentedController : UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DXCircleSpreadTransition.init(type: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DXCircleSpreadTransition.init(type: .dismiss)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isInteration ? interactiveTransition  : nil
    }
    
}
