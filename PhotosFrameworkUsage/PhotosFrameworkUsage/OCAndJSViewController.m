//
//  OCAndJSViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/3.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "OCAndJSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ZLVideoModel.h"

@interface OCAndJSViewController () <UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) ZLVideoModel *videoModel;
@end

@implementation OCAndJSViewController

- (ZLVideoModel *)videoModel {
    if (_videoModel == nil) {
        _videoModel = [[ZLVideoModel alloc] init];
        _videoModel.videoFileUrl = [NSURL URLWithString:@"http://localhost:8080/MyApplicationPrj/videos/movie.mp4"];
        _videoModel.mediaType = @"public.movie.mp4";
    }
    return _videoModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"executeJS" style:UIBarButtonItemStylePlain target:self action:@selector(executeJS)];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"OCAndJS" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [webView loadRequest:request];
}

- (void)executeJS {
    if (!self.context) {
        [BaseViewController hudWithTitle:@"Context为nil"];
        return;
    }
    
    // 第一种方法
//    [self.context evaluateScript:@"share()"];
    
    // 第二种方法
//    JSValue *shareValue = self.context[@"share"];
//    [shareValue callWithArguments:@[]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"videoModel"] = self.videoModel;
    // 第一种方法
    self.context[@"test"] = ^() {
        // 获取该方法的所有参数
        NSArray *args = [JSContext currentArguments];
        for (JSValue *arg in args) {
            NSLog(@"%@ - 1", arg);
        }
    };
    
    // 第二种方法
//    self.context[@"test"] = ^(NSString *str1, NSString *str2) {
//        NSLog(@"%@ - %@", str1,str2);
//    };
}

@end
