//
//  BaseTableViewCell.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/6.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"BaseTableViewCell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UINib nibWithNibName:@"BaseTableViewCell" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

@end
