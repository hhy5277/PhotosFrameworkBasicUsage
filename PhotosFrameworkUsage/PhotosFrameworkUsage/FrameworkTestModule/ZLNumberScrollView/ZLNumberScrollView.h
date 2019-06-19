//
//  ZLNumberScrollView.h
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/19.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCharacterView.h"

#define kNumberFont [UIFont systemFontOfSize:30]

NS_ASSUME_NONNULL_BEGIN

@interface ZLNumberScrollView : UIView
/**
 *  characterWidth
 */
@property (nonatomic, assign) float characterWidth;
/**
 *  textFont
 */
@property (nonatomic, strong) UIFont *textFont;
/**
 *  textColor
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 *  duration
 */
@property (nonatomic, assign) float duration;
/**
 *  scrollDirection
 */
@property (nonatomic, assign) ZLScrollDirectionStyle style;
/**
 *  numberText
 */
@property (nonatomic, copy) NSString *numberText;
@end

NS_ASSUME_NONNULL_END
