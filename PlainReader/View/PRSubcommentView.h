//
//  PRSubcommentView.h
//  PlainReader
//
//  Created by guo on 12/10/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRComment.h"
#import "NIAttributedLabel.h"
#import "PRCommentActionView.h"

@interface PRSubcommentView : UIView

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UILabel *plainContentLabel;
@property (nonatomic, strong) NIAttributedLabel *attributedContentLabel;
@property (nonatomic, strong) PRCommentActionView *actionView;

@property (nonatomic) PRComment *comment;

@end
