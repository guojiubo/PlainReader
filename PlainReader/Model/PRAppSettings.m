//
//  CPAppSettings.m
//  PlainReader
//
//  Created by guojiubo on 14-5-26.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PRAppSettings.h"

NSString *const PRAppSettingsThemeChangedNotification = @"PRAppSettingsThemeChangedNotification";

static NSString *const kPrefetchKey = @"prefetch";
static NSString *const kImageWIFIOnlyKey = @"imageWIFIOnly";
static NSString *const kFontSizeKey = @"fontSize";
static NSString *const kNightModeKey = @"nightModeFixed";
static NSString *const kFastScrollKey = @"fastScroll";
static NSString *const kAutoStarCommentedKey = @"autostar";
static NSString *const kInclineSummaryKey = @"inclineSummary";

@interface PRAppSettings ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation PRAppSettings

@synthesize prefetchOnWIFI = _prefetchOnWIFI;
@synthesize imageWIFIOnly = _imageWIFIOnly;
@synthesize fontSize = _fontSize;
@synthesize nightMode = _nightMode;
@synthesize inclineSummary = _inclineSummary;

+ (instancetype)sharedSettings
{
    static PRAppSettings *_settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _settings = [[PRAppSettings alloc] init];
    });
    return _settings;
}

- (id)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        [_userDefaults registerDefaults:@{kPrefetchKey: @YES,
                                          kImageWIFIOnlyKey: @NO,
                                          kFontSizeKey: @(PRArticleFontSizeNormal),
                                          kNightModeKey: @NO,
                                          kFastScrollKey: @YES,
                                          kAutoStarCommentedKey: @YES,
                                          kInclineSummaryKey: @NO}];
        
        _prefetchOnWIFI = [_userDefaults boolForKey:kPrefetchKey];
        _imageWIFIOnly = [_userDefaults boolForKey:kImageWIFIOnlyKey];
        _fontSize = [_userDefaults integerForKey:kFontSizeKey];
        _nightMode = [_userDefaults boolForKey:kNightModeKey];
        _articleFastScroll = [_userDefaults boolForKey:kFastScrollKey];
        _autoStarCommented = [_userDefaults boolForKey:kAutoStarCommentedKey];
        _inclineSummary = [_userDefaults boolForKey:kInclineSummaryKey];
    }
    return self;
}

- (BOOL)isPrefetchOnWIFI
{
    return _prefetchOnWIFI;
}

- (void)setPrefetchOnWIFI:(BOOL)prefetchOnWIFI
{
    _prefetchOnWIFI = prefetchOnWIFI;
    [self.userDefaults setBool:prefetchOnWIFI forKey:kPrefetchKey];
}

- (BOOL)isImageWIFIOnly
{
    return _imageWIFIOnly;
}

- (void)setImageWIFIOnly:(BOOL)imageWIFIOnly
{
    _imageWIFIOnly = imageWIFIOnly;
    [self.userDefaults setBool:imageWIFIOnly forKey:kImageWIFIOnlyKey];
}

- (PRArticleFontSize)fontSize
{
    return _fontSize;
}

- (void)setFontSize:(PRArticleFontSize)fontSize
{
    _fontSize = fontSize;
    [self.userDefaults setInteger:fontSize forKey:kFontSizeKey];
}

- (void)setNightMode:(BOOL)nightMode
{
    _nightMode = nightMode;
    [self.userDefaults setBool:nightMode forKey:kNightModeKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PRAppSettingsThemeChangedNotification object:self];
}

- (BOOL)isNightMode
{
    return _nightMode;
}

- (void)setArticleFastScroll:(BOOL)articleFastScroll
{
    _articleFastScroll = articleFastScroll;
    [self.userDefaults setBool:articleFastScroll forKey:kFastScrollKey];
}

- (void)setAutoStarCommented:(BOOL)autoStarCommented
{
    _autoStarCommented = autoStarCommented;
    [self.userDefaults setBool:autoStarCommented forKey:kAutoStarCommentedKey];
}

- (void)setInclineSummary:(BOOL)inclineSummary
{
    _inclineSummary = inclineSummary;
    [self.userDefaults setBool:inclineSummary forKey:kInclineSummaryKey];
}

- (BOOL)inclineSummary
{
    return _inclineSummary;
}

@end
