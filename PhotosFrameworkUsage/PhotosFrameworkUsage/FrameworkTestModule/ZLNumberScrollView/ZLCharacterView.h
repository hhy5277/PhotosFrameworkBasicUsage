//
//  ZLCharacterView.h
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/19.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLCharacterView : UIView
@property (nonatomic, assign) ZLScrollDirectionStyle style;
@property (nonatomic, strong) NSArray *characterArray;
@property (nonatomic, assign) float duration;
@property (nonatomic, copy) NSString *showCharacter;
@property (nonatomic, assign) NSInteger showCharacterIndex;
-(instancetype)initWithFrame:(CGRect)frame WithTextLabel:(UILabel *)label;
-(void)setShowCharacter:(NSString *)showCharacter animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
