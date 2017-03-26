//
//  RxMyViewDelegateProxy.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/26.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxCocoa

class RxMyViewDelegateProxy: DelegateProxy, MyViewDelegate, DelegateProxyType {
    
    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let myView: MyView = object as! MyView
        myView.delegate = delegate as? MyViewDelegate
    }
    
    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let myView: MyView = object as! MyView
        return myView.delegate
    }
    
}
