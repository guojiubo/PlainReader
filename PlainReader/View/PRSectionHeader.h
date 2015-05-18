//
//  PRSectionHeader.h
//  PlainReader
//
//  Created by guojiubo on 14-6-7.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRSectionHeader : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

@end
