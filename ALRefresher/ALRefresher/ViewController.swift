//
//  OnePageViewController.swift
//  BoomTest
//
//  Created by 王可成 on 15/12/17.
//  Copyright © 2015年 AL. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
	
	var refresher: ALRefresher?
		//MARK: - ------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		//按钮
		let btn = UIButton(frame: CGRect(x: 150, y: 500, width: 60, height: 30))
		btn.setTitle("show", forState: .Normal)
		btn.layer.cornerRadius = 5
		btn.layer.masksToBounds = true
		btn.backgroundColor = UIColor.redColor()
		btn.addTarget(self, action: "show", forControlEvents: .TouchUpInside)
		view.addSubview(btn)
		
		//增加一组
		//只需要设置refresher的frame就行，根据宽度和高度来计算小方块的宽高
		let refresher = ALRefresher(frame: CGRect(x: 100, y: 200, width: 100, height: 80))
		self.refresher = refresher
		refresher.duration = 0.4
		refresher.timeRatio = 0.4
		view.addSubview(refresher)
	}
	
	func show(){
		refresher!.isAnimating ? refresher?.stop() : refresher?.start()
	}
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
		
}
