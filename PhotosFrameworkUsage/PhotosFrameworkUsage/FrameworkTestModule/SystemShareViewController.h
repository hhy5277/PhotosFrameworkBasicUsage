//
//  SystemShareViewController.h
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/30.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemShareViewController : UIViewController
+ (void)shareShowInViewController:(UIViewController *)viewController;
+ (void)sendEmailWithFilePath:(NSArray *)filePaths viewController:(UIViewController *)viewController;
+ (void)authenticationPass;
@end

NS_ASSUME_NONNULL_END
