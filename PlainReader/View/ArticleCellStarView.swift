//
//  ArticleCellStarView.swift
//  PlainReader
//
//  Created by guo on 11/13/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

import UIKit

class ArticleCellStarView: UIView {

    var star: UIImageView = UIImageView(image: UIImage(named: "ArticleUnstarred"))
    
    var starred: Bool = false {
        didSet {
            self.star.image = self.starred ? UIImage(named: "ArticleStarred") : UIImage(named: "ArticleUnstarred")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func setup() {
        self.star.center = CGPoint(x: CGRectGetWidth(self.bounds)/2, y: CGRectGetHeight(self.bounds)/2)
        self.star.autoresizingMask = .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin | .FlexibleBottomMargin
        self.addSubview(self.star)
    }
}
