//
//  PRStarredArticlesViewController.swift
//  PlainReader
//
//  Created by guo on 11/12/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

import UIKit

class StarredArticlesViewController: PRPullToRefreshViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var articles = PRDatabase.sharedDatabase().starredArticles() as! [PRArticle]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshHeader.title = "收藏"

        let menuView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        let menuButton = PRAutoHamburgerButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        menuButton.addTarget(self, action: "menuAction:", forControlEvents: .TouchUpInside)
        menuButton.center = menuView.center
        menuView.addSubview(menuButton)
        self.refreshHeader.leftView = menuView
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "handleStarActionNotification:", name: ArticleViewControllerStarredNotification, object: nil)
    }
    
    func handleStarActionNotification(n: NSNotification) {
        self.tableView.reloadData()
    }
    
    func menuAction(sender: PRAutoHamburgerButton) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    override func scrollView() -> UIScrollView! {
        return self.tableView
    }
    
    override func useRefreshHeader() -> Bool {
        return true
    }
    
    override func useLoadMoreFooter() -> Bool {
        return false
    }
    
    override func refreshTriggered() {
        super.refreshTriggered()
        articles = PRDatabase.sharedDatabase().starredArticles() as! [PRArticle]
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
            if let weakSelf = self {
                weakSelf.refreshCompleted()
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ArticleCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PRArticleCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("PRArticleCell", owner: self, options: nil).first as? PRArticleCell
        }
        cell!.article = self.articles[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let article = self.articles[indexPath.row]
        let vc = PRArticleViewController.cw_loadFromNibUsingClassName()
        vc.articleId = article.articleId;
        self.stackController.pushViewController(vc, animated: true)
    }

}
