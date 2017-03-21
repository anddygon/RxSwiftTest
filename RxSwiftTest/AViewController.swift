//
//  AViewController.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/17.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rx.sentMessage(#selector(UIAlertViewDelegate.alertView(_:clickedButtonAt:)))
            .asObservable()
            .bindNext { _ in
                print("2222 alert 点击了")
            }
            .addDisposableTo(bag)
        
        btn.rx.tap
            .asObservable()
            .bindNext { _ in
                UIAlertView(title: "title", message: "message", delegate: self, cancelButtonTitle: "ok").show()
            }
            .addDisposableTo(bag)
    }

}

extension AViewController: UIAlertViewDelegate {
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
    }
    
}
