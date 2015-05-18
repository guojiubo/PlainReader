//
//  CPAppSettings.h
//  PlainReader
//
//  Created by guojiubo on 14-5-26.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PRArticleFontSize) {
    PRArticleFontSizeSmall,
    PRArticleFontSizeNormal,
    PRArticleFontSizeBig
};

extern NSString *const PRAppSettingsThemeChangedNotification;

@interface PRAppSettings : NSObject

+ (instancetype)sharedSettings;

@property (nonatomic, getter = isPrefetchOnWIFI) BOOL prefetchOnWIFI;
@property (nonatomic, getter = isImageWIFIOnly) BOOL imageWIFIOnly;
@property (nonatomic, assign) PRArticleFontSize fontSize;
@property (nonatomic, getter = isNightMode) BOOL nightMode;
@property (nonatomic) BOOL articleFastScroll;
@property (nonatomic) BOOL autoStarCommented;
@property (nonatomic) BOOL inclineSummary;

@end
