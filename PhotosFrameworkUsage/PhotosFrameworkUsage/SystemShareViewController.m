//
//  SystemShareViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/30.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "SystemShareViewController.h"

@interface SystemShareViewController ()

@end

@implementation SystemShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
