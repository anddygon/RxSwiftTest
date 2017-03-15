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

let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)

typealias State = (index: Int, text: String?)
let initialState: State = (-1, nil)

class ViewController: UIViewController {
    
    @IBOutlet weak var field: UITextField!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }

    fileprivate func test() {
        field.rx.text
            .asObservable()
            .scan(initialState) { (sum: State, text: String?) -> State in
                return (sum.index + 1, text)
            }
//            .flatMap { (s: State) -> Observable<String?> in
//                return timer
//                    .map({ (i: Int) -> String? in
//                        return "序列\(s.index)--元素\(i)--\(s.text)"
//                    })
//            }
//            .flatMapFirst({ (s: State) -> Observable<String?> in
//                return timer
//                    .map({ (i: Int) -> String? in
//                        return "序列\(s.index)--元素\(i)--\(s.text)"
//                    })
//            })
//            .flatMapLatest({ (s: State) -> Observable<String?> in
//                return timer
//                    .map({ (i: Int) -> String? in
//                        return "序列\(s.index)--元素\(i)--\(s.text)"
//                    })
//            })
            .flatMapWithIndex({ (s: State, index: Int) -> Observable<String?> in
                if index % 6 == 0 {
                    return timer
                        .map({ (i: Int) -> String? in
                            return "序列\(s.index)--元素\(i)--\(s.text)"
                        })
                } else {
                    return Observable.empty()
                }
            })
            .bindNext { (text: String?) in
                print(text ?? "")
            }
            .addDisposableTo(bag)
    }
    
}

