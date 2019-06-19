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
@property (nonatomic, strong) ZLNumberScrollView *countView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) int index;
@end

@implementation NumberScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize textSize = [@"9" boundingRectWithSize:CGSizeMake(320, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kNumberFont} context:nil].size;
    
    self.index = 0;
    self.countView = [[ZLNumberScrollView alloc]initWithFrame:CGRectMake(20, 100, 250, textSize.height)];
    self.countView.duration = 0.5f;
    self.countView.textColor = [UIColor redColor];
    //    self.countView.characterWidth = textSize.width;
    self.countView.style = ZLScrollDirectionStyleDown;
    self.countView.textFont = kNumberFont;
    [self.view addSubview:self.countView];
    self.countView.numberText = @"78,940,561,306";
}

-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObjects:@"123,456", @"45,687", @"95,487", @"987,456,358", @"12", @"45,687,492,102", nil];
    }
    return _dataArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (IBAction)confirmOnClick {
//    NSString *text = self.numberTfx.text;
    
    self.index++;
    if (self.index == self.dataArray.count) {
        self.index = 0;
    }
    self.countView.numberText = self.dataArray[self.index];
}

- (void)test1 {
    [[self.view viewWithTag:100] removeFromSuperview];
    //
    ZLNumberScrollAnimationView *animationView = [ZLNumberScrollAnimationView animationViewWithFrame:CGRectMake(0, 90, kScreenWidth, 40) points:(long)[self.numberTfx.text integerValue]];
    animationView.tag = 100;
    [self.view addSubview:animationView];
}

@end
