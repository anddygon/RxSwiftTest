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
        
//        //每隔一秒发送一个int
//        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//            .debug("interval", trimOutput: true)
//            .bindNext { (i: Int) in
//                print("interval \(i)")
//            }
//            .addDisposableTo(bag)
//        
//        //5秒后发送一次 然后发送complete
//        Observable<Int>.timer(5, scheduler: MainScheduler.instance)
//            .debug("timer", trimOutput: true)
//            .bindNext { (i: Int) in
//                print("timer \(i)")
//            }
//            .addDisposableTo(bag)
        
//        //5秒后发送第一个值，然后每隔1秒发送下一个值
//        Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
//            .debug("timer period", trimOutput: true)
//            .bindNext { (i: Int) in
//                print("timer \(i)")
//            }
//            .addDisposableTo(bag)
    }
    
}

