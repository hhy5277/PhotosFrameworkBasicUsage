//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by 瓜豆2018 on 2019/5/16.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "ViewController.h"
#import "MediaViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MediaViewController *mediaVc = [[MediaViewController alloc] init];
    [self.navigationController pushViewController:mediaVc animated:YES];
}

@end
