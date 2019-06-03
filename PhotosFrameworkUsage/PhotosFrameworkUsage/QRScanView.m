//
//  QRScanView.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/3.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "QRScanView.h"

@interface QRScanView()
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, weak) UIButton *flashBtn;
@end

@implementation QRScanView
{
    CGRect _scanRect;
    dispatch_source_t timer;
}

- (instancetype)initWithScanRect:(CGRect)scanRect {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor clearColor];
        _scanRect = scanRect;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(scanRect.origin.x, scanRect.origin.y, scanRect.size.width, 1)];
        lineView.backgroundColor = [UIColor greenColor];
        lineView.tag = 1;
        [self addSubview:lineView];
        self.lineView = lineView;
        
        UIButton *flashBtn = [[UIButton alloc] initWithFrame:CGRectMake(scanRect.origin.x, CGRectGetMaxY(scanRect) + 15, scanRect.size.width, 40)];
        flashBtn.hidden = YES;
        [flashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [flashBtn setTitle:@"开启闪光灯" forState:UIControlStateNormal];
        [flashBtn addTarget:self action:@selector(openFlashOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:flashBtn];
        self.flashBtn = flashBtn;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dispatchScanViewAnimation];
        });
    }
    return self;
}

- (void)openFlashOnClick {
    self.flashBtn.selected = !self.flashBtn.selected;
    [self.flashBtn setTitle:(self.flashBtn.selected ? @"关闭闪光灯" : @"开启闪光灯") forState:UIControlStateNormal];
    if (self.offFlashBlock) {
        self.offFlashBlock(self.flashBtn.selected);
    }
}

- (void)dispatchScanViewAnimation {
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(1, 1));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.003 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect frame = self.lineView.frame;
            if (self.lineView.tag == 2) {
                frame.origin.y -= 0.5;
                if (frame.origin.y <= _scanRect.origin.y) {
                    self.lineView.tag = 1;
                }
            } else {
                frame.origin.y += 0.5;
                if (CGRectGetMaxY(frame) >= CGRectGetMaxY(_scanRect)) {
                    self.lineView.tag = 2;
                }
            }
            self.lineView.frame = frame;
        });
        
    });
    dispatch_resume(timer);
}

- (void)setBrightnessValue:(float)brightnessValue {
    _brightnessValue = brightnessValue;
    
    if (brightnessValue < -1) {
        self.flashBtn.hidden = NO;
    } else if (self.flashBtn.selected == NO && self.flashBtn.hidden == NO) {
        self.flashBtn.hidden = YES;
    } else if (self.flashBtn.selected == NO) {
        self.flashBtn.hidden = NO;
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];
    
    CGMutablePathRef screenPath = CGPathCreateMutable();
    CGPathAddRect(screenPath, NULL, self.bounds);
    
    CGMutablePathRef scanPath = CGPathCreateMutable();
    CGPathAddRect(scanPath, NULL, _scanRect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddPath(path, NULL, screenPath);
    CGPathAddPath(path, NULL, scanPath);
    
    CGContextAddPath(ctx, path);
    /** kCGPathEOFill:奇偶规则填充（被覆盖过奇数点的填充，被覆盖过偶数点的不填充)
     就比如说从任意位置p作一条射线，若与该射线相交的多边形边的数目为奇数，则p是在多边形内，
     就去填充，否则就不填充。*/
    CGContextDrawPath(ctx, kCGPathEOFill);
    
    CGPathRelease(path);
    CGPathRelease(screenPath);
    CGPathRelease(scanPath);
}


@end
