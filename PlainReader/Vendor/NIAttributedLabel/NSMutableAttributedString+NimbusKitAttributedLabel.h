/*
 Copyright (c) 2011-present, NimbusKit. All rights reserved.
 Originally created by Roger Chapman
 
 This source code is licensed under the BSD-style license found in the LICENSE file in the root
 directory of this source tree and at the http://nimbuskit.info/license url. An additional grant of
 patent rights can be found in the PATENTS file in the same directory and url.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

/**
 * This NimbusKit extension of the NSMutableAttributedString class provides a number of convenience
 * methods for setting styles on attributed strings.
 *
 * All methods will remove the attribute from the modification range before applying the changed
 * attribute.
 *
 * @ingroup NimbusKitAttributedLabel
 */
@interface NSMutableAttributedString (NimbusKitAttributedLabel)

- (void)nimbuskit_setFont:(UIFont *)font;
- (void)nimbuskit_setTextAlignment:(CTTextAlignment)textAlignment lineBreakMode:(CTLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineHeight;
- (void)nimbuskit_setTextColor:(UIColor *)color;
- (void)nimbuskit_setBackgroundColor:(UIColor *)color;
- (void)nimbuskit_setLigaturesEnabled:(BOOL)enabled;
- (void)nimbuskit_setKern:(CGFloat)kern;
- (void)nimbuskit_setUnderlineStyle:(CTUnderlineStyle)style modifier:(CTUnderlineStyleModifiers)modifier;
- (void)nimbuskit_setStrokeWidth:(CGFloat)width;
- (void)nimbuskit_setStrokeColor:(UIColor *)color;
- (void)nimbuskit_setLetterpressEnabled:(BOOL)enabled;

- (void)nimbuskit_setFont:(UIFont *)font range:(NSRange)range;
- (void)nimbuskit_setTextAlignment:(CTTextAlignment)textAlignment lineBreakMode:(CTLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineHeight range:(NSRange)range;
- (void)nimbuskit_setTextColor:(UIColor *)color range:(NSRange)range;
- (void)nimbuskit_setBackgroundColor:(UIColor *)color range:(NSRange)range;
- (void)nimbuskit_setLigaturesEnabled:(BOOL)enabled range:(NSRange)range;
- (void)nimbuskit_setKern:(CGFloat)kern range:(NSRange)range;
- (void)nimbuskit_setUnderlineStyle:(CTUnderlineStyle)style modifier:(CTUnderlineStyleModifiers)modifier range:(NSRange)range;
- (void)nimbuskit_setStrokeWidth:(CGFloat)width range:(NSRange)range;
- (void)nimbuskit_setStrokeColor:(UIColor *)color range:(NSRange)range;
- (void)nimbuskit_setLetterpressEnabled:(BOOL)enabled range:(NSRange)range;

@end

/** @name Modifying Styles for the Entire String */

/**
 * Sets the font for the entire string.
 *
 * @sa nimbuskit_setFont:range:
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setFont:
 */

/**
 * Sets the text alignment and the line break mode for the entire string.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setTextAlignment:lineBreakMode:lineHeight:
 */

/**
 * Sets the text color for the entire string.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setTextColor:
 */

/**
 * Sets the background color for the entire string.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setBackgroundColor:
 */

/**
 * Sets whether or not ligatures are enabled for the entire string.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setLigaturesEnabled:
 */

/**
 * Sets the text kern for the entire string.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setKern:
 */

/**
 * Sets the underline style and modifier for the entire string.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setUnderlineStyle:modifier:
 */

/**
 * Sets the stroke width for the entire string.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setStrokeWidth:
 */

/**
 * Sets the stroke color for the entire string.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setStrokeColor:
 */

/**
 * Sets whether or not the letterpress text style is enabled for the entire string.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setLetterpressEnabled:
 */

/** @name Modifying Styles for Ranges of the String */

/**
 * Sets the font for a given range.
 *
 * @sa nimbuskit_setFont:
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setFont:range:
 */

/**
 * Sets the text alignment and line break mode for a given range.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setTextAlignment:lineBreakMode:lineHeight:range:
 */

/**
 * Sets the text color for a given range.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setTextColor:range:
 */

/**
 * Sets the background color for a given range.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setBackgroundColor:range:
 */

/**
 * Sets whether or not ligatures are enabled for a given range.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setLigaturesEnabled:range:
 */

/**
 * Sets the text kern for a given range.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setKern:range:
 */

/**
 * Sets the underline style and modifier for a given range.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setUnderlineStyle:modifier:range:
 */

/**
 * Sets the stroke width for a given range.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setStrokeWidth:range:
 */

/**
 * Sets the stroke color for a given range.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setStrokeColor:range:
 */

/**
 * Sets whether or not the letterpress text style is enabled for a given range.
 *
 * Does nothing on pre-iOS 7 devices.
 *
 * @fn NSMutableAttributedString(NimbusKitAttributedLabel)::nimbuskit_setLetterpressEnabled:range:
 */
