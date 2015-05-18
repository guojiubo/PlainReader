//
//  PRCommentCell.h
//  PlainReader
//
//  Created by guojiubo on 12/10/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRTableViewCell.h"
#import "NIAttributedLabel.h"
#import "PRComment.h"
#import "PRCommentActionView.h"
#import "PRSubcommentView.h"

@interface PRCommentCell : PRTableViewCell

@property (nonatomic, strong, readonly) UIImageView *avatar;
@property (nonatomic, strong, readonly) UIImageView *hotIcon;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *plainContentLabel;
@property (nonatomic, strong, readonly) NIAttributedLabel *attributedContentLabel;
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *floorLabel;
@property (nonatomic, strong, readonly) NSArray *subcommentViews;
@property (nonatomic, strong, readonly) PRCommentActionView *actionView;

+ (NSString *)reuseIdentifierForComment:(PRComment *)comment;

- (instancetype)initWithComment:(PRComment *)comment;

+ (CGFloat)cellHeightForComment:(PRComment *)comment inTableView:(UITableView *)tableView;

- (void)configureWithComment:(PRComment *)comment tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
