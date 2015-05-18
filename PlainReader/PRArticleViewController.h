//
//  ArticleViewController.h
//  PlainReader
//
//  Created by guojiubo on 14-3-25.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRViewController.h"

extern NSString *const ArticleViewControllerStarredNotification;

@interface PRArticleViewController : PRViewController <CWStackProtocol>

@property (nonatomic, copy) NSNumber *articleId;

@end
    