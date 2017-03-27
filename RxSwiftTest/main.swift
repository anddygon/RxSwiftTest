//
//  Main.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/27.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import Foundation
import UIKit

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(
        to: UnsafeMutablePointer<Int8>.self,
        capacity: Int(CommandLine.argc)
    ),
    NSStringFromClass(UIApplication.self),
    NSStringFromClass(AppDelegate.self)
)
