//
//  BaseViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/31.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MessageUI.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+ (void)hudWithTitle:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.label.text = title;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:2];
}

+ (void)alertWithTitle:(NSString *)title {
    [self alertWithTitle:title message:nil];
}

+ (void)alertWithMessage:(NSString *)message {
    [self alertWithTitle:@"notice" message:message];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    });
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error  {
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%d - %@", result,error);
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            [BaseViewController hudWithTitle:@"信息传送成功"];
            break;
        case MessageComposeResultFailed:
            [BaseViewController hudWithTitle:@"信息传送失败"];
            break;
        case MessageComposeResultCancelled:
            [BaseViewController hudWithTitle:@"信息被用户取消发送"];
            break;
        default:
            break;
    }
}

@end
