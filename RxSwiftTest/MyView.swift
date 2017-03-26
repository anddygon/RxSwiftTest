//
//  MyView.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/26.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit

@objc protocol MyViewDelegate {
    @objc optional func myView(view: MyView, buttonClicked button: UIButton)
}

class MyView: UIView {

    @IBOutlet weak var btn: UIButton!
    weak var delegate: MyViewDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        btn.addTarget(self, action: #selector(MyView.btnClicked(_:)), for: .touchUpInside)
    }
    
    func btnClicked(_ sender: UIButton) {
        delegate?.myView?(view: self, buttonClicked: sender)
    }
    
    class func loadFromNib(parameters: [String: Any]? = nil) -> MyView {
        let v = Bundle(for: self).loadNibNamed("MyView", owner: self, options: nil)?.first as! MyView
        
        return v
    }
    
}
