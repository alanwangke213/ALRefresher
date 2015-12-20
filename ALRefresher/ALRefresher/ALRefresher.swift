//
//  ALRefresher.swift
//  ALRefresher
//
//  Created by 王可成 on 15/12/19.
//  Copyright © 2015年 AL. All rights reserved.
//

import UIKit
import pop

class ALRefresher: UIView {
	// 定时器
	private weak var timer: NSTimer?
	// 方块宽高
	private var squareDestWH: CGFloat = 30
	// 最小宽高
	private var squareOriginWH: CGFloat = 0.25
	// 方块矩阵一维数组
	private var squareArray: [UIView]?
	// 当前组
	private var currentGroup: Int = 0
	// toValue
	private var toValue: NSValue?
	// 方块矩阵二维数组
	var squareList: [[UIView]]?
	//是否放大
	var amplify: Bool = true
	// 动画执行时间
	var duration: NSTimeInterval = 0.5
	// 标志动画是否在执行
	var isAnimating: Bool = false
	// 重复次数（未实现）
	var repeatCount: Int = 0
	// 触发系数<0-1>
	var timeRatio: Double = 0.25
	// square的背景颜色
	var squareColor: UIColor = UIColor.blackColor(){
		didSet{
			for square in squareArray!{
				square.backgroundColor = squareColor
			}
		}
	}
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
	
	// 开始
	func start(){
		creatTimer()
	}
	
	// 暂停
	func stop(){
		invalidTimer()
		stopRefresher()
	}
	// 重置
	func reset(){
		invalidTimer()
		resetRefresher()
	}
	
	//获取refresher
	private func initiateRefresherView(){
		self.squareArray = nil
		currentGroup = 0
		amplify = true
		var squareArray = [UIView]()
		for i in 0..<9 {
			let rowIndex = i / 3
			let colIndex = i % 3
			let squareX = CGFloat(colIndex) * squareDestWH
			let squareY = CGFloat(rowIndex) * squareDestWH
			let squareView = UIView(frame: CGRectMake(squareX + squareDestWH * 0.5, squareY + squareDestWH * 0.5, squareOriginWH, squareOriginWH))
			squareView.backgroundColor = squareColor
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
	
	// 取消
	func resetRefresher(){
		//		!!!未实现
		for view in self.subviews {
			view.removeFromSuperview()
		}
		initiateRefresherView()
	}

	// 更新toValue
	private func updateScaleValues(){
		toValue = amplify ? NSValue(CGSize: CGSizeMake(squareDestWH * 4, squareDestWH * 4)) : NSValue(CGSize: CGSizeMake(squareOriginWH, squareOriginWH))
	}
	
	// 设置缩放动画
	private func setScaleAnim(view: UIView){
		let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
		anim.toValue = toValue
		anim.duration = duration
		view.layer.pop_addAnimation(anim, forKey: "amplifiy")
		// 执行完毕后
		anim.completionBlock = { (anim) -> Void in
			view.pop_removeAllAnimations()
		}
	}

	// 修改某组square的layerWH
	func resizeSquaresInGroup(index: Int, toValue: CGSize){
		let anim = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
		anim.toValue = NSValue(CGSize: toValue)
//		anim.duration = 0.01
		
		for square in squareList![index]{
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				square.layer.pop_addAnimation(anim, forKey: "resize")
			})
			anim.completionBlock = { (anim) -> Void in
				square.pop_removeAllAnimations()
			}
		}

	}
}
