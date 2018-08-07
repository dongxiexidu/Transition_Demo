//
//  CircleSpreadController.swift
//  InteractiveTransition_Demo
//
//  Created by fashion on 2018/8/6.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

class CircleSpreadController: UIViewController {

    lazy var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 100, y: 100, width: 40, height: 40)
        button.backgroundColor = UIColor.lightGray
        button.setTitle("点击或\n拖动我", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.addTarget(self, action: #selector(presentViewController), for: .touchUpInside)
        return button
    }()
    
    deinit {
        print("CircleSpreadController-销毁了")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView.init(frame: self.view.bounds)
        imageView.image = #imageLiteral(resourceName: "pic2")
        view.addSubview(imageView)
        
        view.addSubview(button)
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture(panGesture:)))
        button.addGestureRecognizer(pan)
        
    }
    @objc func panGesture(panGesture: UIPanGestureRecognizer) {
        if let btn = panGesture.view {
            
            let centerX : CGFloat = panGesture.translation(in: btn).x + self.button.center.x
            let centerY : CGFloat = panGesture.translation(in: btn).y + self.button.center.y
    
            let newCenter : CGPoint = CGPoint.init(x: centerX, y: centerY)
            button.center = newCenter
            panGesture.setTranslation(CGPoint.zero, in: panGesture.view)
            
            if panGesture.state == .ended || panGesture.state == .cancelled{
                var center = self.button.center
                if center.x < 20 {
                    center.x = 20
                }
                if center.x > view.bounds.size.width-20 {
                    center.x = view.bounds.size.width-20
                }
                if center.y < 64+20 {
                    center.y = 64+20
                }
                if center.y > view.bounds.size.height-20 {
                    center.y = view.bounds.size.height-20
                }
                
                UIView.animate(withDuration: 0.2) {
                    self.button.center = center
                    panGesture.setTranslation(CGPoint.zero, in: panGesture.view)
                }
            }
        }

    }
    
    
    @objc func presentViewController() {
        let vc = CircleSpreadPresentedController()
        self.present(vc, animated: true, completion: nil)
    }


}
