//
//  CommentPostViewController.h
//  PlainReader
//
//  Created by guojiubo on 14-5-20.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRViewController.h"
#import "PRArticle.h"
#import "PRComment.h"

@interface PRCommentPostViewController : PRViewController <CWStackProtocol>

@property (nonatomic, strong) PRArticle *article;
@property (nonatomic, strong) PRComment *comment;

@end
