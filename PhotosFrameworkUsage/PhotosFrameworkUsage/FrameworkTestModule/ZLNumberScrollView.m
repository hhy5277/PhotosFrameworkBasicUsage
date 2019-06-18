//
//  ZLNumberScrollView.m
//  PhotosFrameworkUsage
//
//  Created by ZhangLiang on 2019/6/18.
//  Copyright © 2019 hongyegroup. All rights reserved.
//

#import "ZLNumberScrollView.h"
#import "NumberCollectionViewCell.h"

#define kNumberFont [UIFont systemFontOfSize:15]

@interface ZLNumberScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *numbersArr;
@property (nonatomic, strong) NSMutableArray *collectionsArr;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, copy) NSString *pointsStr;
@property (nonatomic, strong) NSMutableArray *charactersArr;
@end

@implementation ZLNumberScrollView

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
    ZLNumberScrollView *animationView = [[ZLNumberScrollView alloc] initWithFrame:frame];
    animationView.pointsStr = numberStr;
    NSUInteger length = [numberStr length];
    
    CGSize viewSize = [numberStr boundingRectWithSize:CGSizeMake(320, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kNumberFont} context:nil].size;
    CGFloat contentViewW = ceil(viewSize.width) + length * 1.5;
    CGFloat contentViewH = ceil(viewSize.height);
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - contentViewW) * 0.5, (frame.size.height - contentViewH) * 0.5, contentViewW, contentViewH)];
    contentView.backgroundColor = [UIColor clearColor];
    [animationView addSubview:contentView];
    animationView.contentView = contentView;
    
    animationView.charactersArr = [NSMutableArray arrayWithCapacity:length];
    animationView.collectionsArr = [NSMutableArray arrayWithCapacity:length];
    CGFloat tableViewW = contentViewW / length;
    for (int i = 0; i < length; i++) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(tableViewW, contentViewH);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(tableViewW * i, 0, tableViewW, contentViewH) collectionViewLayout:layout];
        collectionView.dataSource = animationView;
        collectionView.delegate = animationView;
        collectionView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:collectionView];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [animationView.collectionsArr addObject:collectionView];
        
        [collectionView registerNib:[UINib nibWithNibName:@"NumberCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
        
        NSString *str = [numberStr substringWithRange:NSMakeRange(i, 1)];
        [animationView.charactersArr addObject:str];
        if ([str isEqualToString:@","]) {
            collectionView.tag = 1000;
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        
        UICollectionView *collectionView = self.collectionsArr[i];
        int index = [str intValue];
        if (index == 9) {
            [collectionView setContentOffset:CGPointMake(0, collectionView.frame.size.height * index) animated:YES];
        } else {
            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.numbersArr count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NumberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.numLab.font = kNumberFont;
    if (collectionView.tag == 1000) {
        cell.numLab.text = @",";
        return cell;
    }
    
    cell.numLab.text = self.numbersArr[indexPath.item];
    return cell;
}

@end
