//
//  LZImageBrowserManger.m
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/7/16.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "LZImageBrowserManger.h"
#import "LZImageBrowserForceTouchViewController.h"
#import "LZImageBrowserViewController.h"
#import "LZImageBrowserHeader.h"

@interface LZImageBrowserManger ()<UIViewControllerPreviewingDelegate>
@property(nonatomic,copy)NSArray * imageUrls;
@property (nonatomic, copy) NSArray *images;
@property(nonatomic,copy)NSArray * originImageViews;

@property(nonatomic,weak)UIViewController * controller;
@property(nonatomic,copy)ForceTouchActionBlock forceTouchActionBlock;
@property(nonatomic,copy)NSArray * previewActionTitls;
@end
@implementation LZImageBrowserManger

+ (id)imageBrowserMangerWithUrlStr:(NSArray<NSString *>*)imageUrls originImageViews:(NSArray<UIImageView *>*)originImageViews originController:(UIViewController *)controller forceTouch:(BOOL)forceTouchCapability forceTouchActionTitles:(nullable NSArray <NSString *>*)titles forceTouchActionComplete:(nullable ForceTouchActionBlock)forceTouchActionBlock {
    LZImageBrowserManger *imageBrowserManger = [[LZImageBrowserManger alloc] init];
    imageBrowserManger.imageUrls = imageUrls;
    imageBrowserManger.originImageViews = originImageViews;
    imageBrowserManger.controller = controller;

    if (forceTouchCapability) {
        [imageBrowserManger initForceTouch];
    }
    if (forceTouchCapability && titles.count) {
        imageBrowserManger.previewActionTitls = titles;
        imageBrowserManger.forceTouchActionBlock = forceTouchActionBlock;
    }
    
    return imageBrowserManger;
}

+ (id)imageBrowserMangerWithImages:(NSArray<UIImage *> *)images originImageViews:(NSArray<UIImageView *> *)originImageViews originController:(UIViewController *)controller forceTouch:(BOOL)forceTouchCapability forceTouchActionTitles:(nullable NSArray<NSString *> *)titles forceTouchActionComplete:(nullable ForceTouchActionBlock)forceTouchActionBlock {
    LZImageBrowserManger *imageBrowserManger = [[LZImageBrowserManger alloc] init];
    imageBrowserManger.images = images;
    imageBrowserManger.originImageViews = originImageViews;
    imageBrowserManger.controller = controller;
    
    if (forceTouchCapability) {
        [imageBrowserManger initForceTouch];
    }
    if (forceTouchCapability && titles.count) {
        imageBrowserManger.previewActionTitls = titles;
        imageBrowserManger.forceTouchActionBlock = forceTouchActionBlock;
    }
    
    return imageBrowserManger;
}

- (void)showImageBrowser {
    LZImageBrowserViewController *imageBrowserViewController = nil;
    if ([self.imageUrls count] > 0) {
        imageBrowserViewController = [[LZImageBrowserViewController alloc] initWithUrlStr:self.imageUrls originImageViews:self.originImageViews selectPage:self.selectPage];
    } else if ([self.images count] > 0) {
        imageBrowserViewController = [[LZImageBrowserViewController alloc] initWithImages:self.images originImageViews:self.originImageViews selectPage:self.selectPage];
    }
    
    if (imageBrowserViewController != nil) {
        [self.controller presentViewController:imageBrowserViewController animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"没有图片" message:@"没有图片" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)initForceTouch {
    if ([self.controller respondsToSelector:@selector(traitCollection)]) {
        if ([self.controller.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            if (self.controller.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                //1.注册3Dtouch事件
                for (UIView * view in self.originImageViews) {
                    [self.controller registerForPreviewingWithDelegate:self sourceView:view];
                }
            }
        }
    }
}

#pragma mark --UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSInteger selectPage = [self.originImageViews indexOfObject:[previewingContext sourceView]];
    self.selectPage = selectPage;
    UIImage * showOriginForceImage = (UIImage *)[self.originImageViews[selectPage] image];
    LZImageBrowserForceTouchViewController * forceTouchController = [[LZImageBrowserForceTouchViewController alloc] init];
    if ([self.images count] > 0) {
        forceTouchController.image = self.images[selectPage];
        
    } else if ([self.imageUrls count] > 0) {
        NSString * showForceImageUrl = self.imageUrls[selectPage];
        forceTouchController.showForceImageUrl = showForceImageUrl;
    }
    
    forceTouchController.showOriginForceImage = showOriginForceImage;
    if (self.previewActionTitls.count) {
        forceTouchController.previewActionTitls = self.previewActionTitls;
        forceTouchController.forceTouchActionBlock = self.forceTouchActionBlock;
    }

    CGFloat showImageViewW;
    CGFloat showImageViewH;
    CGFloat showImageW = showOriginForceImage.size.width;
    CGFloat showImageH = showOriginForceImage.size.height;
    if (showImageH/showImageW > Screen_Height/Screen_Width) {
        showImageViewH = Screen_Height;
        showImageViewW = Screen_Height * showImageW/showImageH;
    } else {
        showImageViewW = Screen_Width;
        showImageViewH = Screen_Width * showImageH/showImageW;
    }
    
    //设置展示大小
    forceTouchController.preferredContentSize = CGSizeMake((showImageViewW-2)/1, (showImageViewH-2)/1);
    
    return forceTouchController;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    LZImageBrowserViewController * imageBrowserViewController = nil;
    if ([self.images count] > 0) {
        imageBrowserViewController = [[LZImageBrowserViewController alloc] initWithImages:self.images originImageViews:self.originImageViews selectPage:self.selectPage];
        
    } else if ([self.imageUrls count] > 0) {
        imageBrowserViewController = [[LZImageBrowserViewController alloc] initWithUrlStr:self.imageUrls originImageViews:self.originImageViews selectPage:self.selectPage];
    }
    
    [self.controller presentViewController:imageBrowserViewController animated:NO completion:nil];
}

@end
