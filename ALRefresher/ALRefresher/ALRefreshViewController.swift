//
//  ALRefreshViewController.swift
//  ALRefresher
//
//  Created by 王可成 on 15/12/20.
//  Copyright © 2015年 AL. All rights reserved.
//

import UIKit
private let ALTableViewCellReuseId = "ALTableViewCellReuseId"
class ALRefreshViewController: UITableViewController {
	
	
	var refresher: ALRefreshControl?
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationController?.navigationBar.translucent = false
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ALTableViewCellReuseId)
		
		let refresher = ALRefreshControl(frame: CGRectMake(0,-64,110,110))
		refresher.target = tableView
		self.refresher = refresher
		refresher.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
		tableView.addSubview(refresher)
	}
	
	
	func loadData(){
		print("开始加载数据----------->")
		//模拟加载延时
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
			print("----------->数据加载完毕")
				self.refresher?.endRefreshing()
		}
	}
	
}


//MARK: -  tableView data source
extension ALRefreshViewController{
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(ALTableViewCellReuseId, forIndexPath: indexPath)
		cell.backgroundColor = UIColor.lightGrayColor()
		return cell
	}
	
}
