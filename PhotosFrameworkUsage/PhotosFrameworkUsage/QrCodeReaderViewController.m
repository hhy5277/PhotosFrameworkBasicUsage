//
//  QrCodeReaderViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/30.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "QrCodeReaderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRScanView.h"

@interface QrCodeReaderViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureMetadataOutput *output;
    AVCaptureVideoPreviewLayer *layer;
    CGRect _scanRect;
}
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation QrCodeReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        // 如果不设置，整个屏幕都可以扫
        output.rectOfInterest = [layer metadataOutputRectOfInterestForRect:_scanRect];
    }];
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        [output setRectOfInterest:[layer metadataOutputRectOfInterestForRect:CGRectMake(80, 80, 160, 160)]];
//    }];
    
    CGFloat scanWH = 220;
    CGFloat scanX = (kScreenWidth - scanWH) * 0.5;
    CGFloat scanY = (kScreenHeight - scanWH) * 0.5;
    _scanRect = CGRectMake(scanX, scanY, scanWH, scanWH);
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusRestricted) {
        [self loadScanView];
    } else if (status == AVAuthorizationStatusNotDetermined) {
        // 请求使用相机权限
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadScanView];
                });
            } else {
                [[[UIAlertView alloc] initWithTitle:@"无权限访问相机" message:@"无权限访问相机" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"无权限访问相机" message:@"无权限访问相机" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)loadScanView {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建设备输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建元数据输出流
    output = [[AVCaptureMetadataOutput alloc]init];
    //为输出流对象设置代理 并在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //设置高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    // 添加设备输入流
    [self.session addInput:input];
    // 添加设备输出流
    [self.session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,//二维码
                                 //以下为条形码，如果项目只需要扫描二维码，下面都不要写
                                 AVMetadataObjectTypeEAN13Code,
                                 AVMetadataObjectTypeEAN8Code,
                                 AVMetadataObjectTypeUPCECode,
                                 AVMetadataObjectTypeCode39Code,
                                 AVMetadataObjectTypeCode39Mod43Code,
                                 AVMetadataObjectTypeCode93Code,
                                 AVMetadataObjectTypeCode128Code,
                                 AVMetadataObjectTypePDF417Code];
    
    layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    layer.frame = self.view.layer.bounds;
    layer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    // 添加扫描视图
    QRScanView *scanView = [[QRScanView alloc] initWithScanRect:_scanRect];
    [self.view addSubview:scanView];
    
    //开始捕获
    [self.session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [self.session stopRunning];
        [self.session startRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        if (self.qrcodeValueBlock) {
            self.qrcodeValueBlock(metadataObject.stringValue);
        }
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    NSLog(@"QrCodeReader - dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.session stopRunning];
    self.session = nil;
}

@end
