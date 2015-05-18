/*
 Copyright (c) 2011-present, NimbusKit. All rights reserved.
 Originally created by Roger Chapman
 
 This source code is licensed under the BSD-style license found in the LICENSE file in the root
 directory of this source tree and at the http://nimbuskit.info/license url. An additional grant of
 patent rights can be found in the PATENTS file in the same directory and url.
 */

#import "NSMutableAttributedString+NimbusKitAttributedLabel.h"

#import "NimbusKitBasics.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "NimbusKit requires ARC support."
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < NI_IOS_6_0
#error "NIAttributedLabel requires iOS 6 or higher."
#endif

NI_FIX_CATEGORY_BUG(NSMutableAttributedStringNimbusKitAttributedLabel)

@implementation NSMutableAttributedString (NimbusKitAttributedLabel)

+ (NSLineBreakMode)nimbuskit_lineBreakModeFromCTLineBreakMode:(CTLineBreakMode)mode {
    switch (mode) {
        case kCTLineBreakByWordWrapping: return NSLineBreakByWordWrapping;
        case kCTLineBreakByCharWrapping: return NSLineBreakByCharWrapping;
        case kCTLineBreakByClipping: return NSLineBreakByClipping;
        case kCTLineBreakByTruncatingHead: return NSLineBreakByTruncatingHead;
        case kCTLineBreakByTruncatingTail: return NSLineBreakByTruncatingTail;
        case kCTLineBreakByTruncatingMiddle: return NSLineBreakByTruncatingMiddle;
    }
}

- (NSRange)nimbuskit_rangeOfEntireString {
    return NSMakeRange(0, self.length);
}

- (void)nimbuskit_setFont:(UIFont*)font {
    [self nimbuskit_setFont:font range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setTextAlignment:(CTTextAlignment)textAlignment lineBreakMode:(CTLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineHeight {
    [self nimbuskit_setTextAlignment:textAlignment
                       lineBreakMode:lineBreakMode
                          lineHeight:lineHeight
                               range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setTextColor:(UIColor *)color {
    [self nimbuskit_setTextColor:color range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setBackgroundColor:(UIColor *)color {
    [self nimbuskit_setBackgroundColor:color range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setLigaturesEnabled:(BOOL)enabled {
    [self nimbuskit_setLigaturesEnabled:enabled range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setKern:(CGFloat)kern {
    [self nimbuskit_setKern:kern range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setUnderlineStyle:(CTUnderlineStyle)style modifier:(CTUnderlineStyleModifiers)modifier {
    [self nimbuskit_setUnderlineStyle:style modifier:modifier range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setStrokeWidth:(CGFloat)width {
    [self nimbuskit_setStrokeWidth:width range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setStrokeColor:(UIColor *)color {
    [self nimbuskit_setStrokeColor:color range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setLetterpressEnabled:(BOOL)enabled {
    [self nimbuskit_setLetterpressEnabled:enabled range:self.nimbuskit_rangeOfEntireString];
}

- (void)nimbuskit_setFont:(UIFont *)font range:(NSRange)range {
    [self removeAttribute:NSFontAttributeName range:range];
    
    if (nil != font) {
        [self addAttribute:NSFontAttributeName value:font range:range];
    }
}

- (void)nimbuskit_setTextAlignment:(CTTextAlignment)textAlignment
                     lineBreakMode:(CTLineBreakMode)lineBreakMode
                        lineHeight:(CGFloat)lineHeight
                             range:(NSRange)range {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentFromCTTextAlignment(textAlignment);
    paragraphStyle.lineBreakMode = [[self class] nimbuskit_lineBreakModeFromCTLineBreakMode:lineBreakMode];
    paragraphStyle.minimumLineHeight = lineHeight;
    //  paragraphStyle.maximumLineHeight = lineHeight;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

- (void)nimbuskit_setTextColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:NSForegroundColorAttributeName range:range];
    
    if (nil != color) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

- (void)nimbuskit_setBackgroundColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:NSBackgroundColorAttributeName range:range];
    
    if (nil != color) {
        [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
    }
}

- (void)nimbuskit_setLigaturesEnabled:(BOOL)enabled range:(NSRange)range {
    [self removeAttribute:NSLigatureAttributeName range:range];
    [self addAttribute:NSLigatureAttributeName value:@((enabled ? TRUE : FALSE)) range:range];
}

- (void)nimbuskit_setKern:(CGFloat)kern range:(NSRange)range {
    [self removeAttribute:NSKernAttributeName range:range];
    [self addAttribute:NSKernAttributeName value:@(kern) range:range];
}

- (void)nimbuskit_setUnderlineStyle:(CTUnderlineStyle)style modifier:(CTUnderlineStyleModifiers)modifier range:(NSRange)range {
    [self removeAttribute:NSUnderlineStyleAttributeName range:range];
    [self addAttribute:NSUnderlineStyleAttributeName value:@(style|modifier) range:range];
}

- (void)nimbuskit_setStrokeWidth:(CGFloat)width range:(NSRange)range {
    [self removeAttribute:NSStrokeWidthAttributeName range:range];
    [self addAttribute:NSStrokeWidthAttributeName value:@(width) range:range];
}

- (void)nimbuskit_setStrokeColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:NSStrokeColorAttributeName range:range];
    if (nil != color.CGColor) {
        [self addAttribute:NSStrokeColorAttributeName value:color range:range];
    }
}

- (void)nimbuskit_setLetterpressEnabled:(BOOL)enabled range:(NSRange)range {
    // Introduced in iOS 7 - avoid crashing on older OSes.
    if (nil == NSTextEffectLetterpressStyle) {
        return;
    }
    
    [self removeAttribute:NSTextEffectAttributeName range:range];
    if (enabled) {
        [self addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:range];
    }
}

@end
