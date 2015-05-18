//
//  PRCommentCell.m
//  PlainReader
//
//  Created by guojiubo on 12/10/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRCommentCell.h"
#import "PRSubcommentView.h"

@implementation PRCommentCell

+ (NSString *)reuseIdentifierForComment:(PRComment *)comment
{
    NSString *identifier = @"CommentCell";
    if (comment.isHot) {
        identifier = [identifier stringByAppendingString:@"Hot"];
        return identifier;
    }
    
    identifier = [identifier stringByAppendingString:[NSString stringWithFormat:@"Subcomment%@", @(comment.subcomments.count)]];
    return identifier;
}

- (instancetype)initWithComment:(PRComment *)comment
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] reuseIdentifierForComment:comment]];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        if (comment.isHot) {
            // Hot comments
            
            _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_avatar_hot"]];
            [self.contentView addSubview:_avatar];
            
            _hotIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_hot"]];
            [self.contentView addSubview:_hotIcon];
            
            _nameLabel = [[UILabel alloc] init];
            [self.contentView addSubview:_nameLabel];
            
            _plainContentLabel = [[UILabel alloc] init];
            _plainContentLabel.numberOfLines = 0;
            _plainContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            [self.contentView addSubview:_plainContentLabel];
            
            _attributedContentLabel = [[NIAttributedLabel alloc] init];
            _attributedContentLabel.numberOfLines = 0;
            _attributedContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                _plainContentLabel.font = [UIFont systemFontOfSize:15];

                _attributedContentLabel.font = [UIFont systemFontOfSize:15];
                _attributedContentLabel.lineHeight = 18;
            }
            else {
                _plainContentLabel.font = [UIFont systemFontOfSize:18];

                _attributedContentLabel.font = [UIFont systemFontOfSize:18];
                _attributedContentLabel.lineHeight = 21;
            }

            _attributedContentLabel.textColor = [UIColor pr_darkGrayColor];
            [self.contentView addSubview:_attributedContentLabel];
            
            _timeLabel = [[UILabel alloc] init];
            _timeLabel.font = [UIFont systemFontOfSize:12];
            _timeLabel.textColor = [UIColor pr_lightGrayColor];
            [self.contentView addSubview:_timeLabel];
            
            _actionView = [[PRCommentActionView alloc] init];
            [self.contentView addSubview:_actionView];
            
            _avatar.translatesAutoresizingMaskIntoConstraints = NO;
            _hotIcon.translatesAutoresizingMaskIntoConstraints = NO;
            _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _plainContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _actionView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = NSDictionaryOfVariableBindings(_avatar, _hotIcon, _nameLabel, _plainContentLabel, _attributedContentLabel, _timeLabel, _actionView);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_avatar(==29)]-15-[_nameLabel]-50-|" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_avatar(==29)]" options:kNilOptions metrics:nil views:views]];
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-27-[_hotIcon(==32)]" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-4)-[_hotIcon(==32)]" options:kNilOptions metrics:nil views:views]];
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28-[_plainContentLabel]-28-|" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-48-[_plainContentLabel]" options:kNilOptions metrics:nil views:views]];
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_timeLabel]" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeLabel]-|" options:kNilOptions metrics:nil views:views]];
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_actionView(==150)]-15-|" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_actionView(==30)]|" options:kNilOptions metrics:nil views:views]];
            
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_avatar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
            
        }
        else {
            // All comments
            
            _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_avatar"]];
            [self.contentView addSubview:_avatar];
            
            _nameLabel = [[UILabel alloc] init];
            [self.contentView addSubview:_nameLabel];
            
            _plainContentLabel = [[UILabel alloc] init];
            _plainContentLabel.numberOfLines = 0;
            _plainContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            [self.contentView addSubview:_plainContentLabel];
            
            _attributedContentLabel = [[NIAttributedLabel alloc] init];
            _attributedContentLabel.numberOfLines = 0;
            _attributedContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                _plainContentLabel.font = [UIFont systemFontOfSize:15];
                
                _attributedContentLabel.font = [UIFont systemFontOfSize:15];
                _attributedContentLabel.lineHeight = 18;
            }
            else {
                _plainContentLabel.font = [UIFont systemFontOfSize:18];

                _attributedContentLabel.font = [UIFont systemFontOfSize:18];
                _attributedContentLabel.lineHeight = 21;
            }
            _attributedContentLabel.textColor = [UIColor pr_darkGrayColor];
            [self.contentView addSubview:_attributedContentLabel];
            
            _timeLabel = [[UILabel alloc] init];
            _timeLabel.font = [UIFont systemFontOfSize:12];
            _timeLabel.textColor = [UIColor pr_lightGrayColor];
            [self.contentView addSubview:_timeLabel];
            
            _actionView = [[PRCommentActionView alloc] init];
            [self.contentView addSubview:_actionView];
            
            _floorLabel = [[UILabel alloc] init];
            _floorLabel.font = [UIFont systemFontOfSize:12];
            _floorLabel.textColor = [UIColor pr_blueColor];
            _floorLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:_floorLabel];
            
            _avatar.translatesAutoresizingMaskIntoConstraints = NO;
            _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _plainContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _floorLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _actionView.translatesAutoresizingMaskIntoConstraints = NO;

            NSMutableDictionary *views = [NSMutableDictionary dictionaryWithDictionary:NSDictionaryOfVariableBindings(_avatar, _nameLabel, _plainContentLabel, _attributedContentLabel, _timeLabel, _floorLabel, _actionView)];
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_avatar(==29)]-15-[_nameLabel]-50-|" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_avatar(==29)]" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_avatar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_floorLabel]-20-|" options:kNilOptions metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_floorLabel]" options:kNilOptions metrics:nil views:views]];
            
            NSMutableArray *subcommentViews = [[NSMutableArray alloc] init];
            for (int i = 0; i < comment.subcomments.count; i++) {
                PRSubcommentView *subcommentView = [[PRSubcommentView alloc] init];
                [self.contentView addSubview:subcommentView];
                [subcommentViews addObject:subcommentView];
            }
            _subcommentViews = subcommentViews;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28-[_plainContentLabel]-28-|" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_plainContentLabel]-38-|" options:kNilOptions metrics:nil views:views]];
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_timeLabel]" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeLabel]-|" options:kNilOptions metrics:nil views:views]];
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_actionView(==150)]-15-|" options:kNilOptions metrics:nil views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_actionView(==30)]|" options:kNilOptions metrics:nil views:views]];
        }
    }
    return self;
}

- (void)configureWithComment:(PRComment *)comment tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    self.backgroundColor = [UIColor pr_backgroundColor];
    
    [self.avatar setImageWithURL:[NSURL URLWithString:comment.avatarUrl] placeholderImage:comment.isHot ? [UIImage imageNamed:@"comment_avatar_hot"] : [UIImage imageNamed:@"comment_avatar"]];
    
    NSString *title = [NSString stringWithFormat:@"%@  [%@]", comment.userName, comment.from];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange fromRange = [title rangeOfString:[NSString stringWithFormat:@"[%@]", comment.from]];
    [attr cw_setFont:[UIFont systemFontOfSize:14]];
    [attr cw_setFont:[UIFont systemFontOfSize:11] range:fromRange];
    
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    if (settings.isNightMode) {
        self.plainContentLabel.textColor = CW_HEXColor(0xcfcfcf);
        self.attributedContentLabel.textColor = CW_HEXColor(0xcfcfcf);
        [attr cw_setTextColor:CW_HEXColor(0xcfcfcf)];
        [attr cw_setTextColor:[UIColor pr_lightGrayColor] range:fromRange];
    }
    else {
        self.plainContentLabel.textColor = [UIColor pr_darkGrayColor];
        self.attributedContentLabel.textColor = [UIColor pr_darkGrayColor];
        [attr cw_setTextColor:[UIColor pr_darkGrayColor]];
        [attr cw_setTextColor:[UIColor pr_lightGrayColor] range:fromRange];
    }
    
    [self.nameLabel setAttributedText:attr];
    [self.timeLabel setText:comment.time];
    [self.floorLabel setText:[@(comment.floorNumber) stringValue]];
    if (comment.containsEmocaton) {
        self.plainContentLabel.hidden = YES;
        self.attributedContentLabel.hidden = NO;
        self.attributedContentLabel.text = comment.content;
        self.attributedContentLabel.cw_left = 28;
        self.attributedContentLabel.cw_width = CGRectGetWidth(tableView.bounds) - 56;
        
        for (PREmoticon *emoticon in comment.emoticons) {
            [self.attributedContentLabel insertFLImage:[FLAnimatedImage animatedImageWithGIFData:[emoticon imageData]] atIndex:emoticon.location];
        }
        [self.attributedContentLabel sizeToFit];
        
        self.attributedContentLabel.cw_bottom = CGRectGetHeight(self.bounds) - 38;
        self.attributedContentLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    else {
        self.plainContentLabel.hidden = NO;
        self.attributedContentLabel.hidden = YES;
        self.plainContentLabel.text = comment.content;
    }
    
    CGFloat lastSubcommentViewBottom = 48;
    for (int i = 0; i < comment.subcomments.count && i < self.subcommentViews.count; i++) {
        PRComment *subcomment = comment.subcomments[i];
        PRSubcommentView *subcommentView = self.subcommentViews[i];
        CGRect frame = CGRectMake(15, lastSubcommentViewBottom > 48 ? lastSubcommentViewBottom - 0.5 : lastSubcommentViewBottom, CGRectGetWidth(tableView.bounds) - 30, 100);
        subcommentView.frame = frame;
        subcommentView.comment = subcomment;
        lastSubcommentViewBottom = subcommentView.cw_bottom;
        [self connectCellActions:subcommentView.actionView tableView:tableView comment:subcomment indexPath:indexPath];
    }
    
    self.actionView.comment = comment;
    [self connectCellActions:self.actionView tableView:tableView comment:comment indexPath:indexPath];
}

- (void)connectCellActions:(PRCommentActionView *)actionView tableView:(UITableView *)tableView comment:(PRComment *)comment indexPath:(NSIndexPath *)indexPath
{
    actionView.supportButton.indexPath = indexPath;
    [actionView.supportButton addTarget:tableView.delegate action:NSSelectorFromString(@"support:") forControlEvents:UIControlEventTouchUpInside];
    actionView.opposeButton.indexPath = indexPath;
    [actionView.opposeButton addTarget:tableView.delegate action:NSSelectorFromString(@"oppose:") forControlEvents:UIControlEventTouchUpInside];
    actionView.replyButton.indexPath = indexPath;
    [actionView.replyButton addTarget:tableView.delegate action:NSSelectorFromString(@"reply:") forControlEvents:UIControlEventTouchUpInside];
}

+ (CGFloat)cellHeightForComment:(PRComment *)comment inTableView:(UITableView *)tableView
{
    UIDeviceOrientation oritentation = [[UIDevice currentDevice] orientation];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        if (comment.cellHeight > 0) {
            return comment.cellHeight;
        }
    }
    else {
        if (UIDeviceOrientationIsPortrait(oritentation)) {
            if (comment.cellHeightForPadPortrait > 0) {
                return comment.cellHeightForPadPortrait;
            }
        }
        else {
            if (comment.cellHeightForPadLandscape > 0) {
                return comment.cellHeightForPadLandscape;
            }
        }
    }
    
    UILabel *contentLabel;
    if ([comment containsEmocaton]) {
        NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 56, 3000)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            label.font = [UIFont systemFontOfSize:15];
            label.lineHeight = 18;
        }
        else {
            label.font = [UIFont systemFontOfSize:18];
            label.lineHeight = 21;
        }

        label.text = comment.content;
        for (PREmoticon *emoticon in comment.emoticons) {
            [label insertFLImage:[FLAnimatedImage animatedImageWithGIFData:[emoticon imageData]] atIndex:emoticon.location];
        }
        
        contentLabel = label;
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 56, 3000)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.font = [UIFont systemFontOfSize:UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad ? 15 : 18];
        label.text = comment.content;
        
        contentLabel = label;
    }
    
    [contentLabel sizeToFit];
    if (comment.isHot) {
        comment.cellHeight = contentLabel.cw_height + 86;
        return comment.cellHeight;
    }
    
    CGFloat subcommentsHeight = 0;
    for (int i = 0; i < comment.subcomments.count; i++) {
        if (i == 0) {
            subcommentsHeight = 10;
        }
        
        PRComment *subcomment = comment.subcomments[i];
        UILabel *subcontentLabel;
        if ([subcomment containsEmocaton]) {
            NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 70, 3000)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.text = subcomment.content;
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                label.font = [UIFont systemFontOfSize:15];
                label.lineHeight = 18;
            }
            else {
                label.font = [UIFont systemFontOfSize:18];
                label.lineHeight = 21;
            }
            
            for (PREmoticon *emoticon in subcomment.emoticons) {
                [label insertFLImage:[FLAnimatedImage animatedImageWithGIFData:[emoticon imageData]] atIndex:emoticon.location];
            }
            
            subcontentLabel = label;
        }
        else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 70, 3000)];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.font = [UIFont systemFontOfSize:UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad ? 15 : 18];
            label.text = subcomment.content;
            
            subcontentLabel = label;
        }
        
        [subcontentLabel sizeToFit];
        subcommentsHeight += subcontentLabel.cw_height + 75;
    }
    
    comment.cellHeight = subcommentsHeight + contentLabel.cw_height + 86;
    
    if (UIDeviceOrientationIsPortrait(oritentation)) {
        comment.cellHeightForPadPortrait = comment.cellHeight;
    }
    else {
        comment.cellHeightForPadLandscape = comment.cellHeight;
    }
    
    return comment.cellHeight;
}

@end
