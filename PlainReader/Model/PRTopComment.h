//
//  PRTopComment.h
//  PlainReader
//
//  Created by guo on 10/24/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRArticle.h"

@interface PRTopComment : NSObject

@property (nonatomic, copy) NSNumber *topCommentId;
@property (nonatomic, copy) NSString *hashValue;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, strong) PRArticle *article;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellHeightForPadPortrait;
@property (nonatomic, assign) CGFloat cellHeightForPadLandscape;

@end
