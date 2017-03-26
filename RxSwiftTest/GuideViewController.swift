//
//  GuideViewController.swift
//  RxSwiftTest
//
//  Created by xiaoP on 2017/3/24.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RazzleDazzle

class GuideViewController: AnimatedPagingScrollViewController {
    
    fileprivate let guideView1 = UIImageView(image: #imageLiteral(resourceName: "guide_1"))
    fileprivate let guideView2 = UIImageView(image: #imageLiteral(resourceName: "guide_2"))
    fileprivate let guideView3 = UIImageView(image: #imageLiteral(resourceName: "guide_3"))
    let start: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Go...", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor.black
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        configAnimations()
        scrollView.bounces = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func numberOfPages() -> Int {
        return 3
    }
    
    private func configViews() {
        contentView.addSubview(guideView1)
        contentView.addSubview(guideView2)
        contentView.addSubview(guideView3)
        contentView.addSubview(start)
    }
 
    private func configAnimations() {
        configGuideView1()
        configGuideView2()
        configGuideView3()
        configStart()
    }
    
    private func configGuideView1() {
        NSLayoutConstraint(item: guideView1, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: guideView1, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: guideView1, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        keepView(guideView1, onPages: [0], atTimes: [0])
    }
    
    private func configGuideView2() {
        NSLayoutConstraint(item: guideView2, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: guideView2, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: guideView2, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        keepView(guideView2, onPages: [1], atTimes: [1])
    }
    
    private func configGuideView3() {
        NSLayoutConstraint(item: guideView3, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: guideView3, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: guideView3, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        keepView(guideView3, onPages: [2], atTimes: [2])
    }
    
    private func configStart() {
        let vertical = NSLayoutConstraint(item: start, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 40)
        let width = NSLayoutConstraint(item: start, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 120)
        let height = NSLayoutConstraint(item: start, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)
        NSLayoutConstraint.activate([vertical, width, height])
        
        keepView(start, onPages: [2], atTimes: [2])
        
        let verticalAnimation = ConstraintConstantAnimation(superview: scrollView, constraint: vertical)
        verticalAnimation[1.99] = 40
        verticalAnimation[2] = -60
        animator.addAnimation(verticalAnimation)
    }
    
}
