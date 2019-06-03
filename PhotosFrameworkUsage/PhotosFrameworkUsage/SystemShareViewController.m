//
//  SystemShareViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/30.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "SystemShareViewController.h"
#import <MessageUI/MessageUI.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface SystemShareViewController ()

@end

@implementation SystemShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

+ (void)authenticationPass {
    // 首先判断版本号
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        [BaseViewController alertWithTitle:@"系统版本不支持TouchID"];
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"输入密码";
    if (@available(iOS 10.0, *)) {
        // iOS10以上支持取消按钮,设置取消按钮的标题
        context.localizedCancelTitle = @"cancel title";
    } else {
        
    }
    
    // error为返回验证错误码
    NSError *error = nil;
    
    /**
     是否支持指纹验证
     evaluatePolicy方法是对TouchID进行验证,Block回调中如果success为YES则验证成功,为NO验证失败,并对error进行解析.
     */
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        // 调起指纹验证对话框
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {  // 验证成功
                [BaseViewController alertWithMessage:@"TouchID 验证成功"];
            } else if (error) {
                NSString *title = @"";
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        title = @"验证失败";
                        break;
                    case LAErrorUserCancel:
                        title = @"TouchID 被用户手动取消";
                        break;
                    case LAErrorUserFallback:
                        title = @"用户不使用TouchID, 选择手动输入密码";
                        break;
                    case LAErrorSystemCancel:
                        title = @"TouchID 被系统取消(如遇到来电, 锁屏, 按了Home键等)";
                        break;
                    case LAErrorPasscodeNotSet:
                        title = @"ToouchID 无法启动，因为用户没有设置密码";
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        title = @"TouchID无法启动，因为用户没有设置TouchID";
                        break;
                    case LAErrorTouchIDNotAvailable:
                        title = @"TouchID 无效";
                        break;
                    case LAErrorTouchIDLockout:
                        title = @"TouchID被锁定（连续多次验证TouchID失败，系统需要用户手动输入密码）";
                        break;
                    case LAErrorAppCancel:
                        title = @"当前软件被挂起并取消授权（如App进入了后台等）";
                        break;
                    case LAErrorInvalidContext:
                        title = @"当前软件被挂起并取消了授权（LAContext对象无效）";
                        break;
                    default:
                        break;
                }
                [BaseViewController alertWithMessage:title];
            }
            
        }];
    } else {
        [BaseViewController alertWithTitle:@"当前设备不支持TouchID"];
    }
    
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
