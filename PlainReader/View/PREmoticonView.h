//
//  PREmoticonView.h
//  PlainReader
//
//  Created by guojiubo on 14-6-30.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PREmoticonView : UIView

@property (nonatomic, copy) void (^emoticonSelectionBlock)(NSString *emoticonName);
@property (nonatomic, copy) void (^emoticonDeletionBlock)(void);

@end
