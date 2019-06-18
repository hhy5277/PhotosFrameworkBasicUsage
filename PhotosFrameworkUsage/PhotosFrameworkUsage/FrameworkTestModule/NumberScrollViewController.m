//
//  NumberScrollViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/18.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "NumberScrollViewController.h"
#import "ZLNumberScrollAnimationView.h"

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
//
    ZLNumberScrollAnimationView *animationView = [ZLNumberScrollAnimationView animationViewWithFrame:CGRectMake(0, 90, kScreenWidth, 40) points:(long)[self.numberTfx.text integerValue]];
    animationView.tag = 100;
    [self.view addSubview:animationView];
}

@end
