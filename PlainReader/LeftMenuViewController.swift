//
//  LeftMenuViewController.swift
//  PlainReader
//
//  Created by guo on 11/5/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {

    @IBOutlet weak var realtimeItem: LeftMenuItem!
    @IBOutlet weak var topCommentItem: LeftMenuItem!
    @IBOutlet weak var weeklyItem: LeftMenuItem!
    @IBOutlet weak var starredItem: LeftMenuItem!
    @IBOutlet weak var settingsItem: LeftMenuItem!
    @IBOutlet weak var themeSwitch: ThemeSwitch!
    var currentSelectedItem: LeftMenuItem!
    let menus = ["实时资讯", "精彩评论", "本周热门", "收藏", "设置", "日/夜间模式"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.realtimeItem.selected = true
        self.realtimeItem.titleLabel.text = "实时资讯"
        self.realtimeItem.imageView.image = UIImage(named: "LeftMenuRealtime")
        
        self.currentSelectedItem = self.realtimeItem
        
        self.topCommentItem.titleLabel.text = "精彩评论"
        self.topCommentItem.imageView.image = UIImage(named: "LeftMenuTopComment")
        
        self.weeklyItem.titleLabel.text = "本周热门"
        self.weeklyItem.imageView.image = UIImage(named: "LeftMenuWeekly")
        
        self.starredItem.titleLabel.text = "收　　藏"
        self.starredItem.imageView.image = UIImage(named: "LeftMenuStarred")
        
        self.settingsItem.titleLabel.text = "设　　置"
        self.settingsItem.imageView.image = UIImage(named: "LeftMenuSettings")
        
        self.themeSwitch.selected = PRAppSettings.sharedSettings().nightMode
    }
    
    @IBAction func itemAction(item: LeftMenuItem) {
        if item == self.currentSelectedItem {
            self.sideMenuViewController.hideMenuViewController()
            return
        }
        
        self.currentSelectedItem.selected = false
        self.currentSelectedItem = item
        item.selected = true
        
        self.sideMenuViewController.hideMenuViewController()
        
        let centerStackController = self.sideMenuViewController.contentViewController as! CWStackController
        
        // Swift's switch is awesome!
        switch item {
        case self.realtimeItem:
            let realtime = PRRealtimeViewController.cw_loadFromNibUsingClassName()
            centerStackController.viewControllers = [realtime]
        case self.topCommentItem:
            let topComments = UIStoryboard(name: "TopComments", bundle: nil).instantiateInitialViewController() as! PRTopCommentsViewController
            centerStackController.viewControllers = [topComments]
        case self.weeklyItem:
            let weekly = PRWeeklyViewController.cw_loadFromNibUsingClassName();
            centerStackController.viewControllers = [weekly]
        case self.starredItem:
            let starreds = StarredArticlesViewController.cw_loadFromNibUsingClassName()
            centerStackController.viewControllers = [starreds]
        case self.settingsItem:
            let settings: AnyObject = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController()
            centerStackController.viewControllers = [settings]
        default:
            print("Something went wrong")
        }
    }
    
    @IBAction func switchValueChanged(sender: ThemeSwitch) {
        self.sideMenuViewController?.hideMenuViewController()
        PRAppSettings.sharedSettings().nightMode = self.themeSwitch.selected
    }
}
