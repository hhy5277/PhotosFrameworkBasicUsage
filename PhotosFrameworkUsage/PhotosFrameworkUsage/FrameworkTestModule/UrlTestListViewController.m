//
//  UrlTestListViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/4.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "UrlTestListViewController.h"
#import "OCAndJSViewController.h"

@interface UrlTestListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *urlListArr;
@end

@implementation UrlTestListViewController

- (NSArray *)urlListArr {
    if (_urlListArr == nil) {
        _urlListArr = @[@"test url"];
    }
    
    return _urlListArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.urlListArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.urlListArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    OCAndJSViewController *vc = [[OCAndJSViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.urlString = dict[@"url"];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.requestSerializer.timeoutInterval = 20;
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/json", @"text/javascript", nil];
    
    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [session.requestSerializer setValue:@"clientId3" forHTTPHeaderField:@"clientId"];
    [session.requestSerializer setValue:@"eyJhbGciOiJIUzI1NiJ9.eyJpc3MiIDogImh0dHBzOi8vY2FwaS5kYnMuY29tIiwiaWF0IiA6IDE1NTk3ODkwNjAxNTIsICJleHAiIDogMTU1OTc5MjY2MDE1Miwic3ViIiA6ICJaR1Z0Ync9PSIsInB0eXR5cGUiIDogMywiY2xuaWQiIDogImNsaWVudElkMyIsImNsbnR5cGUiIDogIjIiLCAiYWNjZXNzIiA6ICIxRkEiLCJzY29wZSIgOiAiUkVBRCIgLCJhdWQiIDogImh0dHBzOi8vY2FwaS5kYnMuY29tL2FjY2VzcyIgLCJqdGkiIDogIjM3NzYwMDU1NDExMTI3OTM2ODciIH0.qb9ngG5Fv2OKfjVt5PCD0L9X5AptBm19DBg8bpT-aTo" forHTTPHeaderField:@"accessToken"];
//20e892e785644b9a8ae0ce3f32311
    NSString *url = @"https://www.dbs.com/sandbox/api/sg/v1/cards/";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    
    [session GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"%@", error);
    }];
    
}

@end
