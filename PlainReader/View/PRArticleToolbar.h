//
//  PRArticleToolbar.h
//  PlainReader
//
//  Created by guo on 5/17/15.
//  Copyright (c) 2015 GUOJIUBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRArticleToolbar : UIToolbar

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (void)startLoading;

- (void)stopLoading;

@end
