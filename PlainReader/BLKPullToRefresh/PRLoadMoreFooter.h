//
//  BLKLoadMoreFooterView.h
//  BLKTableViewController
//
//  Created by Black on 12-11-27.
//  Copyright (c) 2012年 com.gyz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PRLoadMoreState) {
  PRLoadMoreStatePrompt,
  PRLoadMoreStateLoading,
  PRLoadMoreStateNoMore
};

@interface PRLoadMoreFooter : UIView

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) PRLoadMoreState state;
@property (nonatomic, strong) UIColor *infoColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, copy) void (^loadMoreTriggeredBlock) ();

- (void)loadMoreFooterDidScroll:(UIScrollView *)scrollView;

@end
