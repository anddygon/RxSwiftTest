//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/15.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }
    
    func test() {
        let url = URL(string: "https://www.stylewe.com/rest/advertising")!
        URLSession.shared.rx
            .json(url: url)
//            .catchErrorJustShow()
            .retryWhenUserAllowed()
            .bindNext { (json: Any) in
                print("json \(json)")
            }
            .addDisposableTo(bag)
    }

}
