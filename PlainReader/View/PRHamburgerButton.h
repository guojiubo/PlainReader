//
//  HamburgerButton.h
//  InteractiveHamburger
//
//  Created by guo on 11/10/14.
//  Copyright (c) 2014 CocoaWind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRHamburgerButton : UIControl

@property (nonatomic, assign) CGFloat openingProgress;
@property (nonatomic, assign, getter=isOpen) BOOL open;
@property (nonatomic, assign) UIEdgeInsets insets;

@property (nonatomic, strong) UIColor *hamburgerColor UI_APPEARANCE_SELECTOR;

+ (instancetype)button;

@end
