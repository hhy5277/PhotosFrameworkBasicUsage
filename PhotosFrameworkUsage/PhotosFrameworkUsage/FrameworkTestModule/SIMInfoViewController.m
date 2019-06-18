//
//  SIMInfoViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/17.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "SIMInfoViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "BaseTableViewCell.h"

@interface SIMInfoViewController () <UITableViewDataSource>
{
    // 声明变量
    CTTelephonyNetworkInfo *networkInfo;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SIMInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    // 当sim卡更换时弹出此窗口
    networkInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier * _Nonnull carrier) {
        [BaseViewController alertWithMessage:@"SIM Card change."];
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView];
    // 获取sim卡信息
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *text = @"";
    NSString *detailText = @"";
    switch (indexPath.row) {
        case 0: // 供应商名称（中国联通 中国移动）
            text = @"carrierName";
            detailText = carrier.carrierName;
            break;
        case 1: // 所在国家编号
            text = @"mobileCountryCode";
            detailText = carrier.mobileCountryCode;
            break;
        case 2: // 供应商网络编号
            text = @"mobileNetworkCode";
            detailText = carrier.mobileNetworkCode;
            break;
        case 3:
            text = @"isoCountryCode";
            detailText = carrier.isoCountryCode;
            break;
        case 4: // 是否允许voip
            text = @"allowsVOIP";
            detailText = carrier.allowsVOIP ? @"YES" : @"NO";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

@end
