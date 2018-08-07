//
//  ViewController.swift
//  InteractiveTransition_Demo
//
//  Created by fashion on 2018/8/6.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func cycleBtnClick(_ sender: Any) {
        let vc = CircleSpreadController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

