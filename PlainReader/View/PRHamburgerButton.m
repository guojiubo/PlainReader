//
//  HamburgerButton.m
//  InteractiveHamburger
//
//  Created by guo on 11/10/14.
//  Copyright (c) 2014 CocoaWind. All rights reserved.
//

#import "PRHamburgerButton.h"
#import <POP.h>

@interface PRHamburgerButton ()

@property (nonatomic, strong) CALayer *topLayer;
@property (nonatomic, strong) CALayer *middleLayer1;
@property (nonatomic, strong) CALayer *middleLayer2;
@property (nonatomic, strong) CALayer *bottomLayer;

@end

@implementation PRHamburgerButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

+ (instancetype)button
{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
}

- (void)setHamburgerColor:(UIColor *)hamburgerColor
{
    CGColorRef color = hamburgerColor.CGColor;
    [self.topLayer setBackgroundColor:color];
    [self.bottomLayer setBackgroundColor:color];
    [self.middleLayer1 setBackgroundColor:color];
    [self.middleLayer2 setBackgroundColor:color];
}

- (void)setup
{
    self.insets = UIEdgeInsetsMake(8, 4, 8, 4);
    
    CGFloat height = 2.0f;
    CGFloat width = CGRectGetWidth(self.bounds) - self.insets.left - self.insets.right;
    CGFloat cornerRadius =  1.0f;
    CGColorRef color = [self.tintColor CGColor];
    
    self.topLayer = [CALayer layer];
    self.topLayer.frame = CGRectMake(CGRectGetMidX(self.bounds) - (width/2), CGRectGetMinY(self.bounds) + self.insets.top, width, height);
    self.topLayer.cornerRadius = cornerRadius;
    self.topLayer.backgroundColor = color;
    
    self.middleLayer1 = [CALayer layer];
    self.middleLayer1.frame = CGRectMake(CGRectGetMidX(self.bounds) - (width/2), CGRectGetMidY(self.bounds)-(height/2), width, height);
    self.middleLayer1.cornerRadius = cornerRadius;
    self.middleLayer1.backgroundColor = color;
    
    self.middleLayer2 = [CALayer layer];
    self.middleLayer2.frame = CGRectMake(CGRectGetMidX(self.bounds) - (width/2), CGRectGetMidY(self.bounds)-(height/2), width, height);
    self.middleLayer2.cornerRadius = cornerRadius;
    self.middleLayer2.backgroundColor = color;
    
    self.bottomLayer = [CALayer layer];
    self.bottomLayer.frame = CGRectMake(CGRectGetMidX(self.bounds) - (width/2), CGRectGetMaxY(self.bounds) - self.insets.bottom - height, width, height);
    self.bottomLayer.cornerRadius = cornerRadius;
    self.bottomLayer.backgroundColor = color;
    
    [self.layer addSublayer:self.topLayer];
    [self.layer addSublayer:self.middleLayer1];
    [self.layer addSublayer:self.middleLayer2];
    [self.layer addSublayer:self.bottomLayer];
    
    [self addTarget:self
             action:@selector(touchUpInsideHandler:)
   forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUpInsideHandler:(PRHamburgerButton *)sender
{
    self.open = !self.open;
}

- (void)setOpen:(BOOL)open
{
    _open = open;
    
    if (open) {
        [self open];
        return;
    }
    
    [self close];
}

- (void)removeAllAnimations
{
    [self.topLayer pop_removeAllAnimations];
    [self.bottomLayer pop_removeAllAnimations];
    [self.middleLayer1 pop_removeAllAnimations];
    [self.middleLayer2 pop_removeAllAnimations];
}

- (void)open
{
    [self removeAllAnimations];
    
    POPBasicAnimation *fadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    fadeAnimation.duration = 0.2;
    fadeAnimation.toValue = @0;
    [self.topLayer pop_addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    [self.bottomLayer pop_addAnimation:fadeAnimation forKey:@"fadeAnimation"];
    
    POPBasicAnimation *positionTopAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionTopAnimation.duration = 0.2;
    positionTopAnimation.toValue = @(CGRectGetMidY(self.bounds));
    [self.topLayer pop_addAnimation:positionTopAnimation forKey:@"positionTopAnimation"];
    
    POPBasicAnimation *positionBottomAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionBottomAnimation.duration = 0.2;
    positionBottomAnimation.toValue = @(CGRectGetMidY(self.bounds));
    [self.bottomLayer pop_addAnimation:positionBottomAnimation forKey:@"positionBottomAnimation"];

    [fadeAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        POPSpringAnimation *transformAnimation1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        transformAnimation1.toValue = @(M_PI_4);
        transformAnimation1.springBounciness = 20.f;
        transformAnimation1.springSpeed = 20;
        transformAnimation1.dynamicsTension = 1000;
        
        POPSpringAnimation *transformAnimation2 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        transformAnimation2.toValue = @(-M_PI_4);
        transformAnimation2.springBounciness = 20.0f;
        transformAnimation2.springSpeed = 20;
        transformAnimation2.dynamicsTension = 1000;
        
        [self.middleLayer1 pop_addAnimation:transformAnimation1 forKey:@"rotate1Animation"];
        [self.middleLayer2 pop_addAnimation:transformAnimation2 forKey:@"rotate2Animation"];
    }];
}

- (void)close
{
    [self removeAllAnimations];
    
    POPBasicAnimation *transformAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    transformAnimation1.duration = 0.2;
    transformAnimation1.toValue = @(0);
    
    POPBasicAnimation *transformAnimation2 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    transformAnimation2.duration = 0.2;
    transformAnimation2.toValue = @(0);
    
    [self.middleLayer1 pop_addAnimation:transformAnimation1 forKey:@"rotate1Animation"];
    [self.middleLayer2 pop_addAnimation:transformAnimation2 forKey:@"rotate2Animation"];
    
    [transformAnimation1 setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        POPBasicAnimation *fadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        fadeAnimation.duration = .3;
        fadeAnimation.toValue = @1;
        [self.topLayer pop_addAnimation:fadeAnimation forKey:@"fadeAnimation"];
        [self.bottomLayer pop_addAnimation:fadeAnimation forKey:@"fadeAnimation"];
        
        POPSpringAnimation *positionTopAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        positionTopAnimation.springBounciness = 15;
        positionTopAnimation.springSpeed = 20;
        positionTopAnimation.dynamicsTension = 1000;
        positionTopAnimation.toValue = @(CGRectGetMinY(self.bounds) + self.insets.top + CGRectGetHeight(self.middleLayer1.bounds)/2);
        [self.topLayer pop_addAnimation:positionTopAnimation forKey:@"positionTopAnimation"];
        
        POPSpringAnimation *positionBottomAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        positionBottomAnimation.springBounciness = 15;
        positionBottomAnimation.springSpeed = 20;
        positionBottomAnimation.dynamicsTension = 1000;
        positionBottomAnimation.toValue = @(CGRectGetMaxY(self.bounds) - self.insets.bottom - CGRectGetHeight(self.middleLayer1.bounds)/2);
        [self.bottomLayer pop_addAnimation:positionBottomAnimation forKey:@"positionBottomAnimation"];
    }];
}

- (void)setOpeningProgress:(CGFloat)openingProgress
{

    _openingProgress = MIN(1, MAX(0, openingProgress));
    CGFloat threshold = 0.5f;
    
    if (_openingProgress <= threshold) {
        [self.topLayer setOpacity:1];
        [self.bottomLayer setOpacity:1];

        [self.middleLayer1 setTransform:CATransform3DIdentity];
        [self.middleLayer2 setTransform:CATransform3DIdentity];

        CGFloat yProgress = _openingProgress/threshold;
        CGFloat distance = CGRectGetMinY(self.middleLayer1.frame) - self.insets.top;
        
        CGRect frame = [self.topLayer frame];
        frame.origin.y = yProgress * distance + (CGRectGetMinY(self.bounds) + self.insets.top);
        [self.topLayer setFrame:frame];
        
        frame = [self.bottomLayer frame];
        frame.origin.y = (CGRectGetMaxY(self.bounds) - self.insets.bottom - CGRectGetHeight(self.middleLayer1.bounds)) - yProgress * distance;
        [self.bottomLayer setFrame:frame];
        
        return;
    }
    
    CGFloat middleY = (CGRectGetMidY(self.bounds) - CGRectGetHeight(self.middleLayer1.bounds)/2);
    CGRect frame = [self.topLayer frame];
    frame.origin.y = middleY;
    [self.topLayer setFrame:frame];
    [self.topLayer setOpacity:0];
    
    frame = [self.bottomLayer frame];
    frame.origin.y = middleY;
    [self.bottomLayer setFrame:frame];
    [self.bottomLayer setOpacity:0];
    
    CGFloat angle = (_openingProgress - threshold)/threshold * M_PI_4;
    [self.middleLayer1 setTransform:CATransform3DMakeRotation(angle, 0, 0, 1)];
    [self.middleLayer2 setTransform:CATransform3DMakeRotation(-angle, 0, 0, 1)];
}

@end
