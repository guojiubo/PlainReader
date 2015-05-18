//
//  PRComment.h
//  PlainReader
//
//  Created by guojiubo on 14-5-11.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PREmoticon.h"
#import "PRArticle.h"

@interface PRComment : NSObject

@property (nonatomic, copy) NSString * cid;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, assign) NSUInteger oppose;
@property (nonatomic, assign) NSUInteger support;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) NSArray *subcomments;
@property (nonatomic, strong) PRArticle *article;
@property (nonatomic, copy) NSString *aid;
@property (nonatomic, assign) BOOL supported;
@property (nonatomic, assign) BOOL opposed;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, assign) NSInteger floorNumber;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, readonly) BOOL containsEmocaton;
@property (nonatomic, copy, readonly) NSString *pureContent;  // content without emoticon texts
@property (nonatomic, strong, readonly) NSMutableArray *emoticons;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellHeightForPadPortrait;
@property (nonatomic, assign) CGFloat cellHeightForPadLandscape;

+ (instancetype)instanceFromDictionary:(NSDictionary *)dict;

@end
