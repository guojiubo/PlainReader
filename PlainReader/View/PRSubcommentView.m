//
//  PRSubcommentView.m
//  PlainReader
//
//  Created by guo on 12/10/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

#import "PRSubcommentView.h"

@interface PRSubcommentView ()

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation PRSubcommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.layer.borderWidth = 0.5;
    
    PRAppSettings *settings = [PRAppSettings sharedSettings];
    if ([settings isNightMode]) {
        [self.layer setBorderColor:[UIColor pr_tableViewSeparatorColor].CGColor];
        self.backgroundColor = CW_HEXColor(0x393c44);
    }
    else {
        [self.layer setBorderColor:[UIColor pr_tableViewSeparatorColor].CGColor];
        self.backgroundColor = CW_HEXColor(0xf0f0f0);
    }
    
    _nameLabel = [[UILabel alloc] init];
    [self addSubview:_nameLabel];
    
    _floorLabel = [[UILabel alloc] init];
    _floorLabel.font = [UIFont systemFontOfSize:12];
    _floorLabel.textColor = [UIColor pr_lightGrayColor];
    _floorLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_floorLabel];
    
    _plainContentLabel = [[UILabel alloc] init];
    _plainContentLabel.numberOfLines = 0;
    _plainContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:_plainContentLabel];
    
    _attributedContentLabel = [[NIAttributedLabel alloc] init];
    _attributedContentLabel.numberOfLines = 0;
    _attributedContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _attributedContentLabel.textColor = [UIColor pr_darkGrayColor];
    [self addSubview:_attributedContentLabel];
    
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
    
    _actionView = [[PRCommentActionView alloc] init];
    [self addSubview:_actionView];
    
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _floorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _actionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_nameLabel, _floorLabel, _plainContentLabel, _actionView, _attributedContentLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_nameLabel]-30-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_nameLabel]" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_floorLabel]-20-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_floorLabel]" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_actionView(==150)]-10-|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_actionView(==30)]|" options:kNilOptions metrics:nil views:views]];
}

- (void)setComment:(PRComment *)comment
{
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
    
    _nameLabel.attributedText = attr;
    _floorLabel.text = [@(comment.floorNumber) stringValue];
    if (comment.containsEmocaton) {
        self.plainContentLabel.hidden = YES;
        self.attributedContentLabel.hidden = NO;
        self.attributedContentLabel.text = comment.content;
        
        for (PREmoticon *emoticon in comment.emoticons) {
            [self.attributedContentLabel insertFLImage:[FLAnimatedImage animatedImageWithGIFData:[emoticon imageData]] atIndex:emoticon.location];
        }
        
        self.attributedContentLabel.frame = CGRectMake(20, 40, CGRectGetWidth(self.bounds) - 40, 1000);
        [self.attributedContentLabel sizeToFit];
        
        self.cw_height = self.attributedContentLabel.cw_height + 75;
    }
    else {
        self.plainContentLabel.hidden = NO;
        self.attributedContentLabel.hidden = YES;
        self.plainContentLabel.text = comment.content;

        self.plainContentLabel.frame = CGRectMake(20, 40, CGRectGetWidth(self.bounds) - 40, 1000);
        [self.plainContentLabel sizeToFit];
        
        self.cw_height = self.plainContentLabel.cw_height + 75;
    }
        
    self.actionView.comment = comment;
}

@end
