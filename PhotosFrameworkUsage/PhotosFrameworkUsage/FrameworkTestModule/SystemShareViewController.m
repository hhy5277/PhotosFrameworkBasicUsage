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

+ (void)sendShortMessageWithPhoneNumber:(NSString *)phoneNumber text:(NSString *)text viewController:(BaseViewController *)viewController {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        // 发送短信的号码，数组形式入参
        controller.recipients = @[phoneNumber];
        controller.navigationBar.tintColor = [UIColor redColor];
        // 此处的body就是短信将要发生的内容
        controller.body = text;
        controller.messageComposeDelegate = viewController;
        [viewController presentViewController:controller animated:YES completion:nil];
        // 修改短信界面标题
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"title"];
    } else {
        [BaseViewController hudWithTitle:@"该设备不支持短信功能"];
    }
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
                continue;
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

+ (void)shareShowInViewController:(UIViewController *)viewController {
    // 分享的title
    NSString *textToShare = @"我是ZL，欢迎关注我！";
    // 分享的图片
    UIImage *imageToShare = [UIImage imageNamed:@"icon-60"];
    // 分享的链接地址
    NSURL *urlToShare = [NSURL URLWithString:@"https://www.jianshu.com/u/9cb1a1857948"];
    // 顺序可以混乱，系统会自动识别类型
    NSArray *activityItems = @[textToShare,urlToShare,imageToShare];
    // 调起系统分享视图
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[]];
    // 设置忽略分享App的属性
    //    vc.excludedActivityTypes = @[UIActivityTypePostToVimeo];
    // 分享结果后的回调Block
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
