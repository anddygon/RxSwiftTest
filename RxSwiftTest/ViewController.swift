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
    
    @IBOutlet weak var label: UILabel!
    let viewTouched: PublishSubject<Void> = PublishSubject()
    let random: PublishSubject<Int> = PublishSubject()
    let bag = DisposeBag()
    var randomSeq: Observable<Int> {
        return test1()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func test1() -> Observable<Int> {
        return Observable<Int>
            .deferred { () -> Observable<Int> in
                let r = Int(arc4random() % 10)
                return Observable.just(r)
            }
            .map { (i: Int) -> Int in
                switch i {
                case 7...9 :
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(i)太大了"])
                case 0...5:
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(i)太小了"])
                default:
                    return i
                }
            }
            .retryWhenUserAllowed(valueOnFailure: 666666)
    }
    
    fileprivate func test() -> Observable<Int> {
        return Observable<Int>
                    .deferred { () -> Observable<Int> in
                        let r = Int(arc4random() % 10)
                        return Observable.just(r)
                    }
                    .debug("yyy")
                    .map { (i: Int) -> Int in
                        switch i {
                        case 7...9 :
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(i)太大了"])
                        case 0...5:
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "\(i)太小了"])
                        default:
                            return i
                        }
                    }
                    .retryWhen { [unowned self] (errorSeq: Observable<Error>) -> Observable<Void> in
                        var retryCount = 3
                        return errorSeq
                                    .do(onNext: { _ in
                                        retryCount -= 1
                                    })
                                    .flatMap({ (e: Error) -> Observable<Void> in
                                        if retryCount >= 0 {
                                            return showAlert(title: "遇到错误", message: e.localizedDescription, from: self)
                                                .map({ (isRetry: Bool) -> Void in
                                                    if isRetry {
                                                        return ()
                                                    } else {
                                                        throw e
                                                    }
                                                })
                                                .debug("xxx")
                                        } else {
                                            print("重试次数已用完")
                                            return Observable.error(e)
                                        }
                                    })
                                    .retry()
                    }
    }
    
    fileprivate func testRetry() {
//        viewTouched
//            .asObservable()
//            .flatMapLatest { (_) -> Observable<Int> in
//                let r = Int(arc4random() % 10)
//                if r != 6 {
//                    return Observable.just(r)
//                } else {
//                    return Observable.error(MyError.oversize(value: r))
//                                .catchErrorJustReturn(-1)
//                }
//            }
//            .bindNext { (i: Int) in
//                print("随机值为 \(i)")
//            }
//            .addDisposableTo(bag)
        
        random
            .asObservable()
            .debug("retry前")
            .retry(3)
            .debug("retry后")
            .flatMapLatest { (i: Int) -> Observable<String> in
                return showAlert(title: "遇到一个错误是否重试?", message: "错误: " + "xxx", from: self)
                            .map({ (isEnsure: Bool) -> String in
                                if isEnsure {
                                    return "\(i)"
                                } else {
                                    throw MyError.oversize(value: 6)
                                }
                            })
            }
//            .debug("555")
            .bindNext { (s) in
                print("最终值 \(s)")
            }
            .addDisposableTo(bag)
    }
    
    fileprivate func testRetryWhen() {
        viewTouched
            .asObservable()
            .debug("111")
            .flatMapLatest { (_) -> Observable<Int> in
                return Observable.just(Int.random())
                    .debug("222")
            }
            .map { (i: Int) -> Int in
                if i <= -6 {
                    throw MyError.notPositive(value: i)
                } else if i > 8 {
                    throw MyError.oversize(value: i)
                } else {
                    return i
                }
            }
            .debug("333")
            .retryWhen { [unowned self] (errorSeq: Observable<MyError>) -> Observable<Void> in
                return errorSeq
                    .debug("444")
                    .flatMap({ (error: MyError) -> Observable<Void> in
                        let message: String
                        switch error {
                        case let .notPositive(value):
                            message = "\(value)小于等于-6"
                        case let .oversize(value):
                            message = "\(value)大于8"
                        }
                        
                        return showAlert(title: "遇到一个错误是否重试?", message: "错误: " + message, from: self)
                            .map({ (isEnsure: Bool) -> Void in
                                if isEnsure {
                                    return ()
                                } else {
                                    throw error
                                }
                            })
                            .debug("555")
                    })
                    .retry()
                    .debug("666")
            }
            .debug("777")
            .bindNext { (i: Int) in
                print("随机值为 \(i)")
            }
            .addDisposableTo(bag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewTouched.onNext()
        random.onNext(Int(arc4random() % 100))
        randomSeq
            .catchError({ (e: Error) -> Observable<Int> in
                print("我抓到error: \(e.localizedDescription)")
                return Observable.empty()
            })
            .bindNext { (i: Int) in
                print("随机值 \(i)")
            }
            .addDisposableTo(bag)
    }

}

enum MyError: Error {
    case notPositive(value: Int)
    case oversize(value: Int)
}

extension Int {
    
    static func random() -> Int {
        let r1 = arc4random() % 10
        let r2 = arc4random() % 2 == 0
        return Int(r1) * (r2 ? 1 : -1)
    }
    
}

func showAlert(title: String, message: String, from viewController: UIViewController) -> Observable<Bool> {
    return Observable.create { (observer: AnyObserver<Bool>) -> Disposable in
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ensureAction = UIAlertAction(title: "确定", style: .default) { (_) in
            observer.onNext(true)
            observer.onCompleted()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            observer.onNext(false)
            observer.onCompleted()
        }
        
        alertVC.addAction(ensureAction)
        alertVC.addAction(cancelAction)
        viewController.present(alertVC, animated: true, completion: nil)
        
        return Disposables.create {
            alertVC.dismiss(animated: true, completion: nil)
        }
    }
}
