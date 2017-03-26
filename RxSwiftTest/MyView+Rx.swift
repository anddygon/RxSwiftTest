//
//  MyView+Rx.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/26.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: MyView {
    
    var delegate: DelegateProxy {
        return RxMyViewDelegateProxy.proxyForObject(base)
    }
    
    var buttonClicked: Observable<Void> {
        return delegate
            .methodInvoked(#selector(MyViewDelegate.myView(view:buttonClicked:)))
            .map({ (params: [Any]) -> Void in
                return ()
            })
    }
    
}
