//
//  BLKPullToRefreshViewController.h
//  BLKPullToRefresh
//
//  Created by guojiubo on 14-3-19.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRRefreshHeader.h"
#import "PRLoadMoreFooter.h"
#import "PRViewController.h"

@interface PRPullToRefreshViewController : PRViewController

@property (nonatomic, readonly) PRRefreshHeader *refreshHeader;
@property (nonatomic, readonly) PRLoadMoreFooter *loadMoreFooter;

- (UIScrollView *)scrollView;

//  a hook to determine whether to use pull-to-refresh feature
//  overide this method and return NO to disable pull-to-refresh feature, defaults to YES
- (BOOL)useRefreshHeader;

// called when refresh triggered
- (void)refreshTriggered;

// call this method when you finish refreshing to restore refresh header state
- (void)refreshCompleted;

//  a hook to determine whether to use load more feature
//  overide this method and return NO to disable load more feature, defaults to YES
- (BOOL)useLoadMoreFooter;

//  always call these super methods to update _loadMoreFooterView's state
- (void)loadMoreTriggered;

//  call this method when you finish loading more to update load more state
- (void)loadMoreCompletedWithNoMore:(BOOL)isNoMore;

@end
