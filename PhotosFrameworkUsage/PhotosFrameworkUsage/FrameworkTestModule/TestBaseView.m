//
//  TestBaseView.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/6.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "TestBaseView.h"

@implementation TestBaseView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUI];
}
- (void)setUI{
    self.userInteractionEnabled = YES;
    //    self.text = @"";
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)]];
}
- (void)tapGes:(UITapGestureRecognizer *)ges{
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    menu.menuItems = @[[[UIMenuItem alloc] initWithTitle:@"点赞" action:@selector(tap:)],
                       [[UIMenuItem alloc] initWithTitle:@"留言" action:@selector(reply:)],
                       [[UIMenuItem alloc] initWithTitle:@"踩一踩" action:@selector(down:)],
                       [[UIMenuItem alloc] initWithTitle:@"踩一踩" action:@selector(down:)]];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    if ( (action == @selector(copy:) && self.text) // 需要有文字才能支持复制
//        || (action == @selector(cut:) && self.text) // 需要有文字才能支持剪切
//        || action == @selector(paste:)
//        || action == @selector(tap:)
//        || action == @selector(reply:)
//        || action == @selector(down:)) return YES;
    return NO;
}
- (void)cut:(UIMenuController *)menu
{
    //UIPasteboard 粘贴板
    // 将label的文字存储到粘贴板
//    [UIPasteboard generalPasteboard].string = self.text;
//    // 清空文字
//    self.text = nil;
    NSLog(@"cut");
}

- (void)copy:(UIMenuController *)menu
{
    // 将label的文字存储到粘贴板
//    [UIPasteboard generalPasteboard].string = self.text;
    NSLog(@"copy");
}

- (void)paste:(UIMenuController *)menu
{
    // 将粘贴板的文字赋值给label
//    self.text = [UIPasteboard generalPasteboard].string;
    NSLog(@"paste");
}

- (void)tap:(UIMenuController *)menu{
    NSLog(@"tap");
}
- (void)reply:(UIMenuController *)menu{
    NSLog(@"reply");
}
- (void)down:(UIMenuController *)menu{
    NSLog(@"down");
}

@end
