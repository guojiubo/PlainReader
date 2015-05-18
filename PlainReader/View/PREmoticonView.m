//
//  PREmoticonView.m
//  PlainReader
//
//  Created by guojiubo on 14-6-30.
//  Copyright (c) 2014年 guojiubo. All rights reserved.
//

#import "PREmoticonView.h"
#import "PREmoticonParser.h"
#import "UIImage+PRAdditions.h"

@interface PREmoticonView ()

@property (nonatomic, strong) NSArray *emoticonImageNames;

@end

@implementation PREmoticonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CW_RGBColor(240, 240, 240);
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        toolbar.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:toolbar];
        
        NSArray *allValues = [[PREmoticonParser emoticonImageDictionary] allValues];
        self.emoticonImageNames = [allValues sortedArrayUsingSelector:@selector(compare:)];
        
        CGFloat spaceBetweenRow = (frame.size.height - 35*3)/4;
        CGFloat spaceBetweenColumn = (frame.size.width - 35*5)/6;
        
        for (NSInteger index = 0; index < 15; ++index) {
            NSInteger row = index/5;
            NSInteger column = index%5;
            
            CGRect frame = CGRectMake(0, 0, 35, 35);
            frame.origin.x = spaceBetweenColumn + (35+spaceBetweenColumn)*column;
            frame.origin.y = spaceBetweenRow + (35+spaceBetweenRow)*row;
            if (index != 14) {
                UIButton *button = [[UIButton alloc] initWithFrame:frame];
                button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                [button setImage:[UIImage pr_animatedGIFNamed:self.emoticonImageNames[index]] forState:UIControlStateNormal];
                button.tag = index;
                [button addTarget:self action:@selector(emoticonSelectionAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
            else {
                UIButton *deleteButton = [[UIButton alloc] initWithFrame:frame];
                [deleteButton setImage:[UIImage imageNamed:@"comment_emoticon_delete_n"] forState:UIControlStateNormal];
                [deleteButton setImage:[UIImage imageNamed:@"comment_emoticon_delete_p"] forState:UIControlStateHighlighted];
                deleteButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                [deleteButton addTarget:self action:@selector(emoticonDeletionAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:deleteButton];
            }
            
        }
    }
    return self;
}

- (void)emoticonSelectionAction:(UIButton *)button
{
    NSString *imageName = self.emoticonImageNames[button.tag];
    
    NSString *emoticonName = nil;
    for (NSString *key in [[PREmoticonParser emoticonImageDictionary] allKeys]) {
        if ([imageName isEqualToString:[PREmoticonParser emoticonImageDictionary][key]]) {
            emoticonName = [NSString stringWithFormat:@"[s:%@]", key];
            break;
        }
    }
    
    if (self.emoticonSelectionBlock) {
        self.emoticonSelectionBlock(emoticonName);
    }
}

- (void)emoticonDeletionAction:(UIButton *)button
{
    if (self.emoticonDeletionBlock) {
        self.emoticonDeletionBlock();
    }
}

@end
