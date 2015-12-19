//
//  ALRefresher.swift
//  ALRefresher
//
//  Created by 王可成 on 15/12/19.
//  Copyright © 2015年 AL. All rights reserved.
//

import UIKit
import pop

//是否放大
var amplify: Bool = true
class ALRefresher: UIView {

	// 定时器
	private weak var timer: NSTimer?
	// 方块宽高
	private var squareDestWH: CGFloat = 50
	// 最小宽高
	private var squareOriginWH: CGFloat = 0.5
	// squareArray
	private var squareArray: [UIView]?
	// squareList
	private var squareList: [[UIView]]?
	// currentGroup
	private var currentGroup: Int = 0
	// toValue
	private var toValue: NSValue?
	// 动画执行时间
	var duration: NSTimeInterval = 0.6
	// wheather the animation is animating
	var isAnimating: Bool = false
	// 重复次数（未实现）
	var repeatCount: Int = 0
	// 始终触发系数<0-1>
	var timeRatio: Double = 0.35
	//MARK: - initiate
	override init(frame: CGRect) {
		super.init(frame: frame)
		squareDestWH = frame.size.width < frame.size.height ? frame.size.width / 3 : frame.size.height / 3
		setupUI()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI(){
		initiateRefresherView()
	}
	
	//开始动画
	func start(){
		creatTimer()
	}
	
	//暂停执行动画
	func stop(){
		invalidTimer()
		stopRefresher()
	}
	func cancel(){
		invalidTimer()
		resetRefresher()
	}
	
	//获取refresher
	private func initiateRefresherView(){
		var squareArray = [UIView]()
		for i in 0..<9 {
			let rowIndex = i / 3
			let colIndex = i % 3
			let squareX = CGFloat(colIndex) * squareDestWH
			let squareY = CGFloat(rowIndex) * squareDestWH
			let squareView = UIView(frame: CGRectMake(squareX, squareY, squareOriginWH, squareOriginWH))

			squareView.tag = i
			squareView.backgroundColor = UIColor.lightGrayColor()
			self.addSubview(squareView)
			squareArray.append(squareView)
		}
		self.squareArray = squareArray
		listSquareViews()
	}
	
	//给squareView分组
	private func listSquareViews(){
		let list_1: [UIView] = [squareArray![0]]
		let list_2: [UIView] = [squareArray![1],squareArray![3]]
		let list_3: [UIView] = [squareArray![2],squareArray![4],squareArray![6]]
		let list_4: [UIView] = [squareArray![5],squareArray![7]]
		let list_5: [UIView] = [squareArray![8]]
		self.squareList = [list_1, list_2, list_3, list_4, list_5]
	}
	//创建定时器
	private func creatTimer(){
		if self.timer == nil {
			dispatch_sync(dispatch_get_global_queue(0, 0)) { () -> Void in
				let timer = NSTimer.scheduledTimerWithTimeInterval( self.duration * self.timeRatio, target: self, selector: "startRefresher", userInfo: nil, repeats: true)
				self.timer = timer
				timer.fire()
			}
		}
		isAnimating = true
	}
	
	//销毁定时器
	private func invalidTimer(){
		self.timer?.invalidate()
	}
	
	//开始执行动画
	@objc private func startRefresher(){
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
	private func stopRefresher(){
		for square in squareArray!{
			square.pop_removeAllAnimations()
		}
		isAnimating = false
	}
	
	//取消
	private func resetRefresher(){
		//		!!!未实现
	}

	//更新toValue
	private func updateScaleValues(){
		toValue = amplify ? NSValue(CGSize: CGSizeMake(squareDestWH * 2, squareDestWH * 2)) : NSValue(CGSize: CGSizeMake(squareOriginWH, squareOriginWH))
	}
	
	//设置缩放动画
	private func setScaleAnim(view: UIView){
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
