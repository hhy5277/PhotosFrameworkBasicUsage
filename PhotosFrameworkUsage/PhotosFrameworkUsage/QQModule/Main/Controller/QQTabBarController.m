//
//  QQTabBarController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/5.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "QQTabBarController.h"
#import "QQNavigationController.h"


@interface QQTabBarController ()

@end

@implementation QQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title {
    childController.title = title;
    QQNavigationController *nav = [[QQNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}


@end
