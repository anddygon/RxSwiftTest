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

typealias State = (index: Int, text: String?)
let initialState: State = (-1, nil)

class ViewController: UIViewController {
    
    @IBOutlet weak var field: UITextField!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //如果从未发送过数据第一个立即发送之后的相邻数据会保证发送间隔不小于1秒, 默认会接受到最后一个新值 下面的throttle latest设置false则不一定会拿到最新值
//        field.rx.text
//            .asObservable()
//            .throttle(1, scheduler: MainScheduler.instance)
//            .scan(initialState) { (sum: State, text: String?) -> State in
//                return (sum.index + 1, text)
//            }
//            .bindNext { (s: State) in
//                print("第\(s.index)次 \(s.text)")
//            }
//            .addDisposableTo(bag)
        
        field.rx.text
            .asObservable()
            .throttle(1, latest: false, scheduler: MainScheduler.instance)
            .scan(initialState) { (sum: State, text: String?) -> State in
                return (sum.index + 1, text)
            }
            .bindNext { (s: State) in
                print("第\(s.index)次 \(s.text)")
            }
            .addDisposableTo(bag)
    }

}

