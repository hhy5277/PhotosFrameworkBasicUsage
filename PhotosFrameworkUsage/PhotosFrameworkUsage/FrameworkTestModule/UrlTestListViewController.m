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
    NSString *appId = @"1trYlRr_k7G32A7J6GkCZoqHVZ-oR0QJLrd06emKJOg";
    NSString *secret = @"IZqz3ovLxXpkQ3fSmIOOlk2mMtwEtGzhyP-HBkgYJ7E";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.saltedge.com/api/v5/customers"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"\"{\"\"data\"=\"{\"\"identifier\":\"test1\"\"}\"\"}\"" dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:appId forHTTPHeaderField:@"App-id"];
    [request setValue:secret forHTTPHeaderField:@"Secret"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }] resume];
    
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    session.requestSerializer = [AFHTTPRequestSerializer serializer];
//    session.requestSerializer.timeoutInterval = 20;
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/json", @"text/javascript", nil];
//
//    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
//    [session.requestSerializer setValue:appId forHTTPHeaderField:@"App-id"];
//    [session.requestSerializer setValue:secret forHTTPHeaderField:@"Secret"];
//
//    NSString *url = @"https://www.saltedge.com/api/v5/customers";
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
//    params[@"data"] = @{@"identifier":@"test1"};
//
//    [session POST:[NSString stringWithFormat:@"%@",url] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSLog(@"%@", error);
//    }];
    
}

@end
