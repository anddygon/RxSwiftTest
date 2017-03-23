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
import ObjectMapper

let reachabilityService = try! DefaultReachabilityService()

class ViewController: UIViewController {
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let user = User.shared
//        print("before")
//        print("id \(user.id) email \(user.email)")
//        
//        let url = URL(string: "http://7.alpha.stylewe.com/rest/auth?email=gongxiaopeng@chicv.com&password=peng")!
//        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
//        request.httpMethod = "POST"
//        
//        URLSession.shared.rx
//            .response(request: request)
//            .retryOnBecomesReachable(reachabilityService: reachabilityService)
//            .map { (response: HTTPURLResponse, data: Data) -> Any in
//                guard (200..<400).contains(response.statusCode) else {
//                    throw NSError(domain: "App", code: -1, userInfo: [NSLocalizedDescriptionKey: "API错误"])
//                }
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                    return json
//                } catch let error {
//                    throw error
//                }
//            }
//            .catchErrorJustShow()
//            .bindNext { (json: Any) in
//                _ = Mapper<UserBuilder>().map(JSONObject: json)
//                print("after")
//                print("id \(user.id) email \(user.email)")
//            }
//            .addDisposableTo(bag)
        
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIAlertController.rx
            .show(title: "xxxx", message: "yyyyy")
            .debug("111")
            .bindNext { (y: Bool) in
                print("\(y ? "" : "不")同意")
            }
            .addDisposableTo(bag)
    }
    
}
