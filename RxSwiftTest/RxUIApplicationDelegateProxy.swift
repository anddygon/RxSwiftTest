//
//  RxUIApplicationDelegateProxy.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/26.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import RxCocoa
import RxSwift

private class RxUIApplicationDelegateProxy: DelegateProxy, UIApplicationDelegate, DelegateProxyType {
    
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let app: UIApplication = object as! UIApplication
        app.delegate = delegate as? UIApplicationDelegate
    }
    
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let app: UIApplication = object as! UIApplication
        return app.delegate
    }
    //对于appDelegate这里必须强引用，不然appDelegate就被释放了。
    override func setForwardToDelegate(_ delegate: AnyObject?, retainDelegate: Bool) {
        super.setForwardToDelegate(delegate, retainDelegate: true)
    }
    
}

extension Reactive where Base: UIApplication {
    
    var delegate: DelegateProxy {
        return RxUIApplicationDelegateProxy.proxyForObject(base)
    }
    
    var didBecomeActive: Observable<UIApplicationState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
            .map{ _ in
                return .active
            }
    }
    
    var didEnterBackground: Observable<UIApplicationState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
            .map{ _ in
                return .background
            }
    }
    
    var willResignActive: Observable<UIApplicationState> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:)))
            .map{ _ in
                return .inactive
            }
    }
    
    var willTerminate: Observable<Void> {
        return delegate
            .methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:)))
            .map{ _ in }
    }
    
    var state: Observable<UIApplicationState> {
        return Observable.of(
            didBecomeActive,
            didEnterBackground,
            willResignActive
            )
            .merge()
            .startWith(base.applicationState)
    }
    
    var isFirstLaunch: Observable<Bool> {
        return Observable.just(Constant.isFirstLaunch)
        
    }
    
    var isFirstLaunchOfNewVersion: Observable<Bool> {
        return Observable.just(Constant.isFirstLaunchOfNewVersion)
    }
    
}

private struct Constant {
    struct Key {
        static var appHadLaunch: String {
            return "xp_appHadLaunch"
        }
        static var appFirstLaunchOfNewVersion: String {
            return "xp_appFirstLaunchOfNewVersionn"
        }
        static var lastVersionOfAppLaunch: String {
            return "xp_lastVersionAppLaunch"
        }
    }
    
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    static let isFirstLaunch: Bool = {
        /** 这里单用一个key来判断处于以下原因
         1. 如果用历史版本会导致必须在app-terminate前记录历史版本到userdefaults里，这样逻辑分离，代码很不稳定
         2. 如果在这里记录会导致另外一个问题就是 如果先调用iFirstLaunch 会影响isFirstLaunchOfNewVersion,永远得不到isFirstLaunchOfNewVersion事件，因为这里已经记录了历史版本
         3. ***最重要的是为了保持功能的独立性，即便你不使用isFirstLaunchOfNewVerion也不影响该功能***
         */
        let userDefaults = UserDefaults.standard
        let isFirstLaunch = !userDefaults.bool(forKey: Key.appHadLaunch)
        
        userDefaults.set(true, forKey: Key.appHadLaunch)
        userDefaults.synchronize()
        
        return isFirstLaunch
    }()
    
    static let isFirstLaunchOfNewVersion: Bool = {
        let userDefaults = UserDefaults.standard
        let lastLaunchVersion: String? = userDefaults.string(forKey: Key.lastVersionOfAppLaunch)
        let currentVersion = Constant.appVersion
        let isFirstLaunchOfNewVersion = lastLaunchVersion != currentVersion
        
        userDefaults.set(currentVersion, forKey: Key.lastVersionOfAppLaunch)
        userDefaults.synchronize()
        
        return isFirstLaunchOfNewVersion
    }()
    
}
