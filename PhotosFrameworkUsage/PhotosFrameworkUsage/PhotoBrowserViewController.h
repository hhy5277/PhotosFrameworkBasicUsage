//
//  PhotoBrowserViewController.h
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/28.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoBrowserViewController : UIViewController
@property (nonatomic, strong) NSArray<PHAsset *> *results;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

NS_ASSUME_NONNULL_END
