//
//  OnePageViewController.swift
//  BoomTest
//
//  Created by 王可成 on 15/12/17.
//  Copyright © 2015年 AL. All rights reserved.
//

import UIKit
import pop

//是否放大
var amplify: Bool = true

class ViewController: UIViewController {
	// 定时器
	weak var timer: NSTimer?
	weak var refresher: UIView?
	// 方块宽高
	let squareWH: CGFloat = 50
	//squareArray
	var squareArray: [UIView]?
	//squareList
	var squareList: [[UIView]]?
	//currentGroup
	private var currentGroup: Int = 0
	//fromValue & toValue
	var fromValue: NSValue?
	var toValue: NSValue?
	//piece time
	let duration: NSTimeInterval = 0.6
	//MARK: - ------------------
	override func viewDidLoad() {
		super.viewDidLoad()
		//按钮
		let btn = UIButton(frame: CGRect(x: 150, y: 300, width: 60, height: 30))
		btn.setTitle("start", forState: .Normal)
		btn.layer.cornerRadius = 5
		btn.layer.masksToBounds = true
		btn.backgroundColor = UIColor.redColor()
		btn.addTarget(self, action: "start", forControlEvents: .TouchUpInside)
		view.addSubview(btn)
		
		//增加一组
		
		let refresher = getRefresherView()
		refresher.center = CGPointMake(200, 200)
		view.addSubview(refresher)
	}
	
	//开始动画
	@objc private func start(){
		creatTimer()
	}
	
	//暂停执行动画
	@objc private func stop(){
		invalidTimer()
		stopRefresher()
	}
	@objc private func cancel(){
		invalidTimer()
		resetRefresher()
	}
	
	//获取refreshView
	func getRefresherView() -> UIView{
		let refresher = UIView(frame: CGRectMake(0, 0, squareWH * 3, squareWH * 3))
		var squareArray = [UIView]()
		for i in 0..<9 {
			let rowIndex = i / 3
			let colIndex = i % 3
			let squareView = UIView(frame: CGRectMake(CGFloat(colIndex) * squareWH, CGFloat(rowIndex) * squareWH, 0.5, 0.5))
			squareView.tag = i
			squareView.backgroundColor = UIColor.lightGrayColor()
			refresher.addSubview(squareView)
			squareArray.append(squareView)
		}
		self.refresher = refresher
		self.squareArray = squareArray
		listSquareViews()
		return refresher
	}
	
	//给squareView分组
	func listSquareViews(){
		let list_1: [UIView] = [squareArray![0]]
		let list_2: [UIView] = [squareArray![1],squareArray![3]]
		let list_3: [UIView] = [squareArray![2],squareArray![4],squareArray![6]]
		let list_4: [UIView] = [squareArray![5],squareArray![7]]
		let list_5: [UIView] = [squareArray![8]]
		self.squareList = [list_1, list_2, list_3, list_4, list_5]
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		invalidTimer()
	}
	
	//创建定时器
	func creatTimer(){
		if self.timer == nil {
			dispatch_sync(dispatch_get_global_queue(0, 0)) { () -> Void in
				let timer = NSTimer.scheduledTimerWithTimeInterval( 0.15, target: self, selector: "startScale", userInfo: nil, repeats: true)
				self.timer = timer
				timer.fire()
			}
		}
	}
	
	//销毁定时器
	func invalidTimer(){
		self.timer?.invalidate()
	}
	
	//开始执行动画
	func startScale(){
		updateScaleValues()
		for square in squareList![currentGroup]{
			setScaleAnim(square)
		}
		if currentGroup == squareList!.count - 1 {
			amplify = !amplify
			//改变fromeValue和toValue
			updateScaleValues()
		}
		self.currentGroup = (self.currentGroup + 1) % self.squareList!.count
	}
	
	//暂停
	func stopRefresher(){
		for square in squareArray!{
			square.pop_removeAllAnimations()
		}
	}
	
	//取消
	func resetRefresher(){
		//		!!!为解决
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		cancel()
	}
	//更新fromeValue 和 toValue
	private func updateScaleValues(){
		//		fromValue = amplify ? NSValue(CGSize: CGSizeMake(0.5, 0.5)) : NSValue(CGSize: CGSizeMake(squareWH * 2, squareWH * 2))
		toValue = amplify ? NSValue(CGSize: CGSizeMake(squareWH * 2, squareWH * 2)) : NSValue(CGSize: CGSizeMake(0.5, 0.5))
	}
	
	//设置缩放动画
	func setScaleAnim(view: UIView){
		let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
		//		anim.fromValue = fromValue
		anim.toValue = toValue
		anim.duration = duration
		view.layer.pop_addAnimation(anim, forKey: "amplifiy")
		//执行完毕后
		anim.completionBlock = { (anim) -> Void in
			view.pop_removeAllAnimations()
		}
	}
	
}
