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
		
		//增加一组
		//只需要设置refresher的frame就行，根据宽度和高度来计算小方块的宽高
		let refresher = ALRefresher(frame: CGRect(x: 100, y: 200, width: 150, height: 150))
		refresher.squareColor = UIColor.lightGrayColor()
		//修改动画时间
		refresher.duration = 0.4
		refresher.timeRatio = 0.3
		self.refresher = refresher
		view.addSubview(refresher)
	}
	
	@IBAction func didClickStartBtn() {
		refresher!.start()
	}

	@IBAction func didClickStopBtn() {
		refresher!.stop()
	}
	
	@IBAction func didClickResetBtn() {
		refresher!.reset()
	}

	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		refresher!.reset()
	}
	
		
}
