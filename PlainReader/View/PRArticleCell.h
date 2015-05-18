//
//  ArticleCell.h
//  PlainReader
//
//  Created by guojiubo on 14-3-28.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRArticle.h"
#import "PRTableViewCell.h"

@interface PRArticleCell : PRTableViewCell

@property (nonatomic, weak) PRArticle *article;

@end
