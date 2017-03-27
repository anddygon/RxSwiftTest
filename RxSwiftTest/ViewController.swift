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
    
    @IBOutlet weak var pickerView: UIPickerView!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = MyView.loadFromNib()
        view.addSubview(v)
        v.delegate = self
        
        v.rx
            .buttonClicked
            .bindNext {
                print("rx 代理模式")
            }
            .disposed(by: bag)
        
//        UIApplication.shared.rx
//            .state
//            .bindNext { (state: UIApplicationState) in
//                switch state {
//                case .active:
//                    print("active")
//                case .background:
//                    print("background")
//                case .inactive:
//                    print("inactive")
//                }
//            }
//            .disposed(by: bag)
//        
//        UIApplication.shared.rx
//            .willTerminate
//            .bindNext { (_) in
//                print("willTerminate")
//            }
//            .addDisposableTo(bag)
        
        let touched = rx.methodInvoked(#selector(ViewController.touchesBegan(_:with:)))
        
        touched
            .flatMapLatest{ _ in
                UIApplication.shared.rx
                    .isFirstLaunch
            }
            .bindNext { (isFirstLaunch: Bool) in
                print("\(isFirstLaunch ? "是" : "不是")首次加载")
            }
            .disposed(by: bag)
        
        touched
            .flatMapLatest{ _ in
                UIApplication.shared.rx
                    .isFirstLaunchOfNewVersion
            }
            .bindNext { (isFirstLaunch: Bool) in
                print("\(isFirstLaunch ? "是" : "不是")首次加载新版本")
            }
            .disposed(by: bag)
        
    }
    
}

extension ViewController: MyViewDelegate {
    
    func myView(view: MyView, buttonClicked button: UIButton) {
        print("系统代理模式调用")
    }
    
}
