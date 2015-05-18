//
//  CommentsViewController.h
//  PlainReader
//
//  Created by guojiubo on 14-4-6.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRPullToRefreshViewController.h"
#import "PRArticle.h"

@interface PRCommentsViewController : PRPullToRefreshViewController <CWStackProtocol>

@property (nonatomic, strong) PRArticle *article;
@property (nonatomic, strong) NSArray *comments;

@end
