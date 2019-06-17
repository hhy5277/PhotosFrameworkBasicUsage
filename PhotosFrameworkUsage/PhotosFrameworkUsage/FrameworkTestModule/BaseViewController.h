//
//  BaseViewController.h
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/31.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
+ (void)alertWithTitle:(NSString *)title;
+ (void)alertWithMessage:(NSString *)message;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)hudWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
