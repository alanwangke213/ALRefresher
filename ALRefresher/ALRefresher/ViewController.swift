//
//  OnePageViewController.swift
//  BoomTest
//
//  Created by 王可成 on 15/12/17.
//  Copyright © 2015年 AL. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
	
	@IBOutlet weak var startBtn: UIButton!
	@IBOutlet weak var stopBtn: UIButton!
	@IBOutlet weak var cancelBtn: UIButton!
	var grayRefresher: ALRefresher?
		//MARK: - ------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//增加一组
		//只需要设置refresher的frame就行，根据宽度和高度来计算小方块的宽高
		let grayRefresher = ALRefresher(frame: CGRect(x: 100, y: 200, width: 150, height: 150))
		grayRefresher.backgroundColor = UIColor.blackColor()
		grayRefresher.squareColor = UIColor.lightGrayColor()
		//修改动画时间
		grayRefresher.duration = 0.4
		self.grayRefresher = grayRefresher
		view.addSubview(grayRefresher)
	}
	
	@IBAction func didClickStartBtn() {
		grayRefresher?.start()
	}

	@IBAction func didClickStopBtn() {
		grayRefresher?.stop()
	}
	
	@IBAction func didClickCancelBtn() {
		grayRefresher?.cancel()
	}

	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
		
}
