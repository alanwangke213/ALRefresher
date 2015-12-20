//
//  ALRefreshControl.swift
//  ALRefresher
//
//  Created by 王可成 on 15/12/20.
//  Copyright © 2015年 AL. All rights reserved.
//

import UIKit

// refresher height
private let ALRefreshControlHeight: CGFloat = 64
private let ALRefresherHeight: CGFloat = 45

// state for refresher
enum ALRefreshControlState: Int{
	case Normal = 0
	case Pulling = 1
	case Refreshing = 2
}

class ALRefreshControl: UIControl {

	// target scroll view
	var target: UIScrollView?
	// 刷新执行方法
	var action: Selector?
	// refresher state
	var refresherState: ALRefreshControlState = .Normal
	
	//MARK: - LAZY
	// refresh view
	private lazy var refresher: ALRefresher = ALRefresher(frame: CGRectMake(0,0,ALRefresherHeight,ALRefresherHeight))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	private func setupUI(){
		// resize self's frame
		var frame = self.frame
		frame.size = CGSizeMake(UIScreen.mainScreen().bounds.width, ALRefreshControlHeight)
		self.frame = frame
		// add ALRefresher
		refresher.center = CGPointMake(frame.width * 0.5, frame.height * 0.5)
		addSubview(refresher)
		
	}
	
	override func willMoveToSuperview(newSuperview: UIView?) {
		super.willMoveToSuperview(newSuperview)
		// if superview is not nil，and is kind of UIScrollView
		if let scrollView = newSuperview where scrollView.isKindOfClass(NSClassFromString("UIScrollView")!) {
			scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
			// record it, and remove observer in deinit
			self.target = scrollView as? UIScrollView
		}
	}
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		let contentInsetTop = self.target?.contentInset.top
		let contentOffsetY = self.target?.contentOffset.y
		// 临界值
		let criticalValue = -contentInsetTop! - frame.height
		
		let point = (change!["new"] as! NSValue).CGPointValue()
		
		if contentOffsetY < 0{
			// when is dragging
			if target!.dragging {
				if contentOffsetY < criticalValue && refresherState == .Normal{
					self.refresherState = .Pulling
				}else if contentOffsetY >= criticalValue && refresherState == .Pulling{
					self.refresherState = .Normal
				}
			}else{
				// if
				if refresherState == .Pulling{
					refresherState = .Refreshing
					refresh()
				}
			}
			resizeSquareInRefresher(point.y)
		}else if contentOffsetY == 0{
			refresher.reset()
		}
	}
	
	// 执行刷新操作
	private func refresh(){
		UIView.animateWithDuration(0.25, animations: { () -> Void in
			var contentInset = self.target?.contentInset
			contentInset?.top += self.frame.height
			self.target?.contentInset = contentInset!
			self.refresher.start()
			// 发出valueChanged消息
			self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
			})
	}
	
	func endRefreshing(){
		// 重置contentInsetTop
		UIView.animateWithDuration(0.25, animations: { () -> Void in
			var contentInset = self.target!.contentInset
			contentInset.top -= self.frame.height
			self.target?.contentInset = contentInset
		})
		refresher.reset()
		refresherState = .Normal
	}
	
	//MARK: - 有BUG
	private func resizeSquareInRefresher(offsetY: CGFloat){
		let index = Int(-offsetY / (self.frame.height / 5))
		let scale = (ALRefresherHeight / 3) / (self.frame.height / 5)
		let offset = -offsetY % (self.frame.height / 5)
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
			if 0 <= index && index < 5{
				print("Index: \(index) --- offset: \(offset)")
				self.refresher.resizeSquaresInGroup(index, toValue: CGSizeMake(offset * scale * 4, offset * scale * 4))
			}
		}
	}

	
	deinit{
		if let scrollView = self.target{
			scrollView.removeObserver(self, forKeyPath: "contentOffset")
		}
	}
	
	
}
