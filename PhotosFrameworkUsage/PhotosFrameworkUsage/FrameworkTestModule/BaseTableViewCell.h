//
//  BaseTableViewCell.h
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/6.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end

NS_ASSUME_NONNULL_END
