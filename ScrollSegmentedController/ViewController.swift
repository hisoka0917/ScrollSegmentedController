//
//  ViewController.swift
//  ScrollSegmentedController
//
//  Created by Wang Kai on 2018/7/9.
//  Copyright © 2018年 github. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showContainer(_ sender: Any) {
        let container = ContainerViewController()
        self.navigationController?.pushViewController(container, animated: true)
    }

}

