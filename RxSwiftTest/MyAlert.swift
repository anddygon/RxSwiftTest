//
//  MyAlert.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/23.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UIAlertController {
    
    static func show(title: String, message: String) -> Observable<Bool> {
        return Observable<Bool>.create({ (observer: AnyObserver<Bool>) -> Disposable in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                observer.onNext(true)
                observer.onCompleted()
            }
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (_) in
                observer.onNext(false)
                observer.onCompleted()
            })
            alertVC.addAction(noAction)
            alertVC.addAction(yesAction)
            
            let rootVC = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
            rootVC?.present(alertVC, animated: true, completion: nil)
            
            return Disposables.create {
                alertVC.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}
