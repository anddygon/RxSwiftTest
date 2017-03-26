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
        v.delegate = self
        view.addSubview(v)
        
        v.rx
            .buttonClicked
            .bindNext {
                print("rx 代理模式")
            }
            .disposed(by: bag)
    }

}

extension ViewController: MyViewDelegate {
    
    func myView(view: MyView, buttonClicked button: UIButton) {
        print("系统代理模式调用")
    }
    
}
