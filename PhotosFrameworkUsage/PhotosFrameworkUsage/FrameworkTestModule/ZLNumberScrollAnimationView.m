//
//  ZLNumberScrollAnimationView.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/18.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "ZLNumberScrollAnimationView.h"

#define kNumberFont [UIFont systemFontOfSize:18]

@interface ZLNumberScrollAnimationView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *numbersArr;
@property (nonatomic, strong) NSMutableArray *tablesArr;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, copy) NSMutableString *pointsStr;
@property (nonatomic, strong) NSMutableArray *charactersArr;
@end

@implementation ZLNumberScrollAnimationView

- (NSArray *)numbersArr {
    if (!_numbersArr) {
        _numbersArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    }
    return _numbersArr;
}

+ (NSString *)numberStringWithPoints:(long)points {
    NSString *text = [NSString stringWithFormat:@"%ld",points];
    NSMutableString *str1 = [[NSMutableString alloc] init];
    for (int i=text.length-1;i>=0;i--) {
        [str1 appendString:[text substringWithRange:NSMakeRange(i, 1)]];
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    for (int i =0;i<str1.length;i++) {
        if (i % 3 == 0 && i != 0) {
            [tempStr appendString:@","];
        }
        [tempStr appendString:[str1 substringWithRange:NSMakeRange(i, 1)]];
    }
    
    NSMutableString *numStr = [[NSMutableString alloc] init];
    for (int i=tempStr.length-1;i>=0;i--) {
        [numStr appendString:[tempStr substringWithRange:NSMakeRange(i, 1)]];
    }
    
    return numStr;
}

+ (instancetype)animationViewWithFrame:(CGRect)frame points:(long)points {
    NSString *numberStr = [self numberStringWithPoints:points];
    ZLNumberScrollAnimationView *animationView = [[ZLNumberScrollAnimationView alloc] initWithFrame:frame];
    animationView.pointsStr = numberStr;
    
    CGSize viewSize = [numberStr boundingRectWithSize:CGSizeMake(320, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kNumberFont} context:nil].size;
    CGFloat contentViewW = ceil(viewSize.width);
    CGFloat contentViewH = ceil(viewSize.height);
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - contentViewW) * 0.5, (frame.size.height - contentViewH) * 0.5, contentViewW, contentViewH)];
    contentView.backgroundColor = [UIColor clearColor];
    [animationView addSubview:contentView];
    animationView.contentView = contentView;
    
    NSUInteger length = [numberStr length];
    animationView.charactersArr = [NSMutableArray arrayWithCapacity:length];
    animationView.tablesArr = [NSMutableArray arrayWithCapacity:length];
    CGFloat tableViewW = contentViewW / length;
    for (int i = 0; i < length; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewW * i, 0, tableViewW, contentViewH) style:UITableViewStylePlain];
        tableView.dataSource = animationView;
        tableView.delegate = animationView;
        tableView.rowHeight = viewSize.height;
        [contentView addSubview:tableView];
        [animationView.tablesArr addObject:tableView];
        
        NSString *str = [numberStr substringWithRange:NSMakeRange(i, 1)];
        [animationView.charactersArr addObject:str];
        if ([str isEqualToString:@","]) {
            tableView.tag = 1000;
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [animationView numberScroll];
    });
    
    return animationView;
}

- (void)numberScroll {
    for (int i = 0; i < [self.charactersArr count]; i++) {
        NSString *str = self.charactersArr[i];
        if ([str isEqualToString:@","]) {
            continue;
        }
        
        UITableView *tableView = self.tablesArr[i];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[str intValue] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1000) {
        return 1;
    }
    return [self.numbersArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    }
    
    if (tableView.tag == 1000) {
        cell.textLabel.text = @",";
        return cell;
    }
    
    cell.textLabel.text = self.numbersArr[indexPath.row];
    return cell;
}

@end
