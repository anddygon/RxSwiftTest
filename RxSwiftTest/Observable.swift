//
//  Extension.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/20.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxSwift

extension ObservableConvertibleType {
    
    func retryWhenUserAllowed(valueOnFailure: E) -> Observable<E> {
        return self
            .asObservable()
            .catchError { (e: Error) -> Observable<E> in
                return Observable<E>.create({ (observer) -> Disposable in
                    let alertVC = UIAlertController(title: "遇到错误", message: e.localizedDescription, preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "确定", style: .default, handler: { (_) in
                        observer.onError(e)
                        observer.onCompleted()
                    })
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
                        observer.onCompleted()
                    })
                    
                    alertVC.addAction(confirmAction)
                    alertVC.addAction(cancelAction)
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
                    
                    return Disposables.create {
                        alertVC.dismiss(animated: true, completion: nil)
                    }
                })
            }
            .retry()
    }
    
}
