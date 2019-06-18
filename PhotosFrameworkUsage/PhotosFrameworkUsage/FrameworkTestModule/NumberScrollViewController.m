//
//  NumberScrollViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/18.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "NumberScrollViewController.h"
#import "ZLNumberScrollAnimationView.h"
#import "ZLNumberScrollView.h"

@interface NumberScrollViewController ()
- (IBAction)confirmOnClick;
@property (weak, nonatomic) IBOutlet UITextField *numberTfx;
@end

@implementation NumberScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (IBAction)confirmOnClick {
//    NSString *text = self.numberTfx.text;
    
    [[self.view viewWithTag:100] removeFromSuperview];
    
    
    long num = (long)[self.numberTfx.text integerValue];
    ZLNumberScrollView *scrollView = [ZLNumberScrollView animationViewWithFrame:CGRectMake(0, 90, kScreenWidth, 40) points:num];
    scrollView.tag = 100;
    [self.view addSubview:scrollView];
    
    
    
//    ZLNumberScrollAnimationView *animationView = [ZLNumberScrollAnimationView animationViewWithFrame:CGRectMake(0, 90, kScreenWidth, 40) points:(long)[self.numberTfx.text integerValue]];
//    animationView.tag = 100;
//    [self.view addSubview:animationView];
}

@end
