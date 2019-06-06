//
//  QQBaseViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/5.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "QQBaseViewController.h"
#import "QQLoginViewController.h"
#import "QQNavigationController.h"

@interface QQBaseViewController ()

@end

@implementation QQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+ (void)qqAuthorizationController {
    QQLoginViewController *loginVc = [[QQLoginViewController alloc] init];
    QQNavigationController *nav = [[QQNavigationController alloc] initWithRootViewController:loginVc];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:nav];
}

@end
