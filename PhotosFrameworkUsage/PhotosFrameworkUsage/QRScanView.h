//
//  QRScanView.h
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/3.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRScanView : UIView
- (instancetype)initWithScanRect:(CGRect)scanRect;
// 是否隐藏开启闪光灯按钮
@property (nonatomic, assign) float brightnessValue;
@property (nonatomic, copy) void (^offFlashBlock)(BOOL flag);
@end

NS_ASSUME_NONNULL_END
