//
//  SystemShareViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/30.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "SystemShareViewController.h"
#import <MessageUI/MessageUI.h>

@interface SystemShareViewController ()

@end

@implementation SystemShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

+ (void)sendEmailWithFilePath:(NSArray *)filePaths viewController:(UIViewController *)viewController {
    if ([filePaths count] <= 0) {
        [[[UIAlertView alloc] initWithTitle:@"notice" message:@"Not have Data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    // 判断用户是否已设置邮件账户
    if ([MFMailComposeViewController canSendMail]) {
        // 能发送
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        [mailCompose setMailComposeDelegate:viewController];
        // 是否为HTML格式
//        [mailCompose setMessageBody:emailContent isHTML:NO];
        
        // 添加附件
        for (NSString *filepath in filePaths) {
            NSData *data = [NSData dataWithContentsOfFile:filepath];
            // 获取文件名，带后缀
            NSString *filename = [filepath lastPathComponent];
            
            if (data == nil) {
                [[[UIAlertView alloc] initWithTitle:@"Invalid data" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                return;
            }
            
            [mailCompose addAttachmentData:data mimeType:[FileUploadTool mimeTypeForPath:filepath] fileName:filename];
        }
        
        // 弹出邮件发送视图
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController presentViewController:mailCompose animated:YES completion:nil];
        });
    } else {
        [[[UIAlertView alloc] initWithTitle:@"notice" message:@"Please add your email first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

/*
 
 //UIActivityTypePostToFacebook,
 //UIActivityTypePostToTwitter,
 //UIActivityTypePostToWeibo,
 //UIActivityTypeMessage,
 //UIActivityTypeMail,
 //UIActivityTypePrint,
 //UIActivityTypeCopyToPasteboard,
 //UIActivityTypeAssignToContact,
 //UIActivityTypeSaveToCameraRoll,
 //UIActivityTypeAddToReadingList,
 //UIActivityTypePostToFlickr,
 //UIActivityTypePostToVimeo,
 //UIActivityTypePostToTencentWeibo,
 //UIActivityTypeAirDrop,
 //UIActivityTypeOpenInIBooks
 */
+ (void)shareShowInViewController:(UIViewController *)viewController {
    NSString *textToShare = @"我是ZL，欢迎关注我！";
    UIImage *imageToShare = [UIImage imageNamed:@"icon-60"];
    NSURL *urlToShare = [NSURL URLWithString:@"https://www.jianshu.com/u/9cb1a1857948"];
    NSArray *activityItems = @[textToShare,urlToShare,imageToShare];
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                     applicationActivities:@[]];
    //    vc.excludedActivityTypes = @[UIActivityTypePostToVimeo];
    
    vc.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        NSLog(@"%@", activityType);
        if (completed) {
            [[[UIAlertView alloc] initWithTitle:@"shared successful." message:@"shared successful." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"shared cancel." message:@"shared cancel." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    };
    [viewController presentViewController:vc animated:YES completion:nil];
}

@end
