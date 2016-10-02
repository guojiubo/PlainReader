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
    var articles = PRDatabase.shared().starredArticles() as! [PRArticle]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshHeader.title = "收藏"

        let menuView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        let menuButton = PRAutoHamburgerButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        menuButton.addTarget(self, action: #selector(StarredArticlesViewController.menuAction(_:)), for: .touchUpInside)
        menuButton.center = menuView.center
        menuView.addSubview(menuButton)
        self.refreshHeader.leftView = menuView
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(StarredArticlesViewController.handleStarActionNotification(_:)), name: NSNotification.Name.ArticleViewControllerStarred, object: nil)
    }
    
    func handleStarActionNotification(_ n: Notification) {
        self.tableView.reloadData()
    }
    
    func menuAction(_ sender: PRAutoHamburgerButton) {
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
        articles = PRDatabase.shared().starredArticles() as! [PRArticle]
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            if let weakSelf = self {
                weakSelf.refreshCompleted()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ArticleCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PRArticleCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PRArticleCell", owner: self, options: nil)?.first as? PRArticleCell
        }
        cell!.article = self.articles[(indexPath as NSIndexPath).row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = self.articles[(indexPath as NSIndexPath).row]
        let vc = PRArticleViewController.cw_loadFromNibUsingClassName()
        vc?.articleId = article.articleId;
        self.stackController.pushViewController(vc, animated: true)
    }

}
