//
//  RxUIApplicationDelegateProxy.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/26.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import RxCocoa
import RxSwift

class RxUIApplicationDelegateProxy: DelegateProxy, UIApplicationDelegate, DelegateProxyType {
    
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let app: UIApplication = object as! UIApplication
        app.delegate = delegate as? UIApplicationDelegate
    }
    
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let app: UIApplication = object as! UIApplication
        return app.delegate
    }
    //对于appDelegate这里必须强引用，不然appDelegate就被释放了。这样也不会有问题，因为app是全局存在的
    override func setForwardToDelegate(_ delegate: AnyObject?, retainDelegate: Bool) {
        super.setForwardToDelegate(delegate, retainDelegate: true)
    }
    
}

extension Reactive where Base: UIApplication {
    
    var delegate: DelegateProxy {
        return RxUIApplicationDelegateProxy.proxyForObject(base)
    }
    
    var willResignActive: Observable<Void> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:)))
            .map({ (params: [Any]) -> Void in
                return
            })
    }
    
}
