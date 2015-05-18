//
//  BLKPullToRefreshHeader.h
//  BLKPullToRefresh
//
//  Created by guojiubo on 14-3-19.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PRRefreshState) {
    PRRefreshStatePulling = 0,
    PRRefreshStateTriggering,
    PRRefreshStateRefreshing
};

@interface PRRefreshHeader : UIView

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) PRRefreshState state;
@property (nonatomic, copy) void (^refreshTriggeredBlock) ();
@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *subtitleColor UI_APPEARANCE_SELECTOR;

- (void)restore;

- (void)pullToRefreshHeaderDidScroll:(UIScrollView *)scrollView;

@end





