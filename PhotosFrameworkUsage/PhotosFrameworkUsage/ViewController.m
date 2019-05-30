//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by 瓜豆2018 on 2019/5/16.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "ViewController.h"
#import "MediaViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Extend the code sample from 6a. Add Facebook Login to Your Code
    // Add to your viewDidLoad method:
    loginButton.readPermissions = @[@"public_profile", @"email"];
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        NSLog(@"%@", [FBSDKAccessToken currentAccessToken].tokenString);
    }
    MediaViewController *mediaVc = [[MediaViewController alloc] init];
    [self.navigationController pushViewController:mediaVc animated:YES];
}

@end
