//
//  Extension.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/20.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

extension ObservableConvertibleType {
    
    func retryWhenUserAllowed() -> Observable<E> {
        return self
            .asObservable()
            .catchError { (e: Error) -> Observable<E> in
                /*以当用户确认重试的时候 发送error，然后触发真正的retry工作
                 我们这里提供的只是一个用户接口来让用户做选择
                 **/
                return Observable<E>.create({ (observer) -> Disposable in
                    let alertVC = UIAlertController(title: "遇到错误，是否重试？", message: e.localizedDescription, preferredStyle: .alert)
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
    
    func catchErrorJustShow(extraHandler handler: ((Error) -> Void)? = nil) -> Observable<E> {
        return self
            .asObservable()
            .catchError{ (e: Error) -> Observable<E> in
                SVProgressHUD.showError(withStatus: e.localizedDescription)
                handler?(e)
                return Observable.empty()
        }
    }
    
}
