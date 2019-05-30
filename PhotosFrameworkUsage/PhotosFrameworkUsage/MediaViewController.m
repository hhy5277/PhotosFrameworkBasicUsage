//
//  MediaViewController.m
//  AVPlayerDemo
//
//  Created by 瓜豆2018 on 2019/5/23.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "MediaViewController.h"
#import <CoreServices/CoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "ZLVideoModel.h"
#import "AlbumViewController.h"
#import "ContactsViewController.h"
#import "OtherLoginViewController.h"
#import "PlayerLayerViewController.h"

#define kVideoMaximumDuration 5

#define kRecordVideoUseImagePickerController @"使用UIImagePickerController录制视频"
#define kPlayVideoWithAVPlayerViewController @"使用AVPlayerViewController播放视频"
#define kVideoSaveToAlbum @"将视频保存到相簿"
#define kGetMediaInfoWithAVAsset @"使用AVAsset抽象类获取媒体信息"
#define kVideoList @"视频列表"
#define kConvertWithAVAssetExportSession @"将MOV转换为MP4文件并保存到相册"
#define kCompressWithAVAssetExportSession @"使用AVAssetExportSession对视频进行压缩"
#define kVideoFrameWithAVAssetImageGenerator @"使用AVAssetImageGenerator取视频帧"
#define kUploadVideoToServer @"上传视频到服务器"
#define kSelectVideoOfPhotoLibrary @"从相册库选择视频"
#define kPhotosFrameworkUsage @"Photos框架的基本使用"
#define kContactsFrameworkUsage @"使用Contacts框架处理通讯录联系人信息"
#define kToOtherLoginVc @"第三方登陆"
#define kAVPlayerLayerUsage @"AVPlayerView的使用"

@interface MediaViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) NSMutableArray *videoList;
@end

@implementation MediaViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if ([text isEqualToString:kRecordVideoUseImagePickerController]) {
        [self recordVideo];
    } else if ([text isEqualToString:kVideoSaveToAlbum]) {
        [self saveVideoToAlbum];
    } else if ([text isEqualToString:kPlayVideoWithAVPlayerViewController]) {
        [self playVideo];
    } else if ([text isEqualToString:kGetMediaInfoWithAVAsset]) {
        [self getInfoWithAVAsset];
    } else if ([text isEqualToString:kConvertWithAVAssetExportSession]) {
        [self convertVideoCode];
    } else if ([text isEqualToString:kCompressWithAVAssetExportSession]) {
        [self compressVideo];
    } else if ([text isEqualToString:kVideoFrameWithAVAssetImageGenerator]) {
        [self videoFrameWithGenerator];
    } else if ([text isEqualToString:kUploadVideoToServer]) {
        [self uploadVideoFileToServer];
    } else if ([text isEqualToString:kSelectVideoOfPhotoLibrary]) {
        [self selectVideoOfPhotoLibrary];
    } else if ([text isEqualToString:kPhotosFrameworkUsage]) {
        [self photosFrameworkUsage];
    } else if ([text isEqualToString:kContactsFrameworkUsage]) {
        [self contactsFrameworkUsage];
    } else if ([text isEqualToString:kToOtherLoginVc]) {
        [self toOtherLogin];
    } else if ([text isEqualToString:kAVPlayerLayerUsage]) {
        [self avplayerLayerUsage];
    }
}

#pragma mark - AVPlayerView的使用
- (void)avplayerLayerUsage {
    PlayerLayerViewController *plVc = [[PlayerLayerViewController alloc] init];
    [self.navigationController pushViewController:plVc animated:YES];
}

#pragma mark - 第三方登陆
- (void)toOtherLogin {
    OtherLoginViewController *otherLoginVc = [[OtherLoginViewController alloc] init];
    [self.navigationController pushViewController:otherLoginVc animated:YES];
}

#pragma mark - Contacts.framework处理通讯录联系人信息
- (void)contactsFrameworkUsage {
    ContactsViewController *contactsVc = [[ContactsViewController alloc] init];
    [self.navigationController pushViewController:contactsVc animated:YES];
}

#pragma mark - Photos框架的基本使用
- (void)photosFrameworkUsage {
    AlbumViewController *albumVc = [[AlbumViewController alloc] init];
    [self.navigationController pushViewController:albumVc animated:YES];
}

#pragma mark - 从相册库选择视频
- (void)selectVideoOfPhotoLibrary {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.videoMaximumDuration = kVideoMaximumDuration;
    NSString *movieType = (__bridge NSString *)kUTTypeMovie;
    picker.mediaTypes = @[movieType];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 上传视频文件到服务器
- (void)uploadVideoFileToServer {
    if ([self.videoList count] <= 0) {
        return;
    }
    
    ZLVideoModel *model = [self.videoList firstObject];
    AVAsset *asset = [AVAsset assetWithURL:model.videoFileUrl];
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"movie.mp4"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    exportSession.outputURL = [NSURL fileURLWithPath:filePath];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            
            NSString *boundary = [self generateBoundaryString];
            // 请求的Url
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.0.122:8080/MyApplicationPrj/FileUpload"]];
            [request setHTTPMethod:@"POST"];
            // 设置ContentType
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
            NSString *fieldName = @"movie.mp4";
            NSData *httpBody = [self createBodyWithBoundary:boundary parameters:nil paths:@[exportSession.outputURL.path] fieldName:fieldName];
           [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@\n%@", result,error);
            }] resume];
        } else {
            NSLog(@"%@", exportSession.error);
        }
    }];
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    // 文本参数
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 本地文件的NSData
    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}

- (NSString *)mimeTypeForPath:(NSString *)path {
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    CFRelease(UTI);
    return mimetype;
}

- (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

#pragma mark - 取出视频中的一个帧
- (void)videoFrameWithGenerator {
    if ([self.videoList count] <= 0) {
        NSLog(@"not have video.");
        return;
    }
    
    ZLVideoModel *model = [self.videoList firstObject];
    AVAsset *asset = [AVAsset assetWithURL:model.videoFileUrl];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    // 这个是什么属性
    imageGenerator.appliesPreferredTrackTransform = YES;
    Float64 duration = CMTimeGetSeconds([asset duration]);
    /**
     取某个帧的时间，参数1表示哪个时间(秒), 参数2表示每秒多少帧
     通常来说，600是一个常用的公共参数，苹果有说明：
     24 frames per second (fps) for film, 30 fps for NTSC (used for TV in North America and
     Japan), and 25 fps for PAL (used for TV in Europe).
     Using a timescale of 600, you can exactly represent any number of frames in these systems
     */
    CMTime midpoint = CMTimeMakeWithSeconds(duration * 0.5, 600);
    // get the image from
    CMTime actualTime;
    NSError *error = nil;
    CGImageRef centerFrameImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
    
    if (centerFrameImage != NULL) {
        UIImage *image = [UIImage imageWithCGImage:centerFrameImage];
        CGImageRelease(centerFrameImage);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.userInteractionEnabled = YES;
        imageView.frame = [UIScreen mainScreen].bounds;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGeneratorImage:)]];
        [[[UIApplication sharedApplication] keyWindow] addSubview:imageView];
    }
}

- (void)dismissGeneratorImage:(UIGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
}

#pragma mark - 视频播放
- (void)playVideo {
    if ([self.videoList count] <= 0) {
        NSLog(@"not have video.");
        return;
    }
    
    ZLVideoModel *model = [self.videoList firstObject];
    
    /** AVPlayerViewController是UIViewController的子类,它可以用来显示AVPlayer对象的视觉内容和标准的播放控制。
     AVPlayerViewController，它不支持UI自定义，实现比较简单，代码如下：*/
    
    AVPlayerViewController *playerVc = [[AVPlayerViewController alloc] init];
    playerVc.player = [AVPlayer playerWithURL:model.videoFileUrl];
    // 这个属性和UIImageView的contentMode = UIViewContentModeAspect; 属性相同，具有拉伸内容大小的作用
//    playerVc.videoGravity = AVLayerVideoGravityResizeAspect;
    playerVc.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self presentViewController:playerVc animated:YES completion:nil];
}

#pragma mark - 压缩视频
- (void)compressVideo {
    
}

#pragma mark - 视频转码
- (void)convertVideoCode {
    if ([self.videoList count] <= 0) {
        NSLog(@"not have video.");
        return;
    }
    
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filenames = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *filename in filenames) {
        [fileManager removeItemAtPath:[dirPath stringByAppendingPathComponent:filename] error:nil];
    }
    
    ZLVideoModel *model = [self.videoList firstObject];
    AVAsset *asset = [AVAsset assetWithURL:model.videoFileUrl];
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:[dirPath stringByAppendingPathComponent:@"autoydyne.mp4"]];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            // 保存到相册
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"转码成功" message:@"是否保存到相册?" preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UISaveVideoAtPathToSavedPhotosAlbum(exportSession.outputURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), @"exportSession");
                    NSLog(@"%@",exportSession.outputURL);
                }]];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertVc animated:YES completion:nil];
            });
            
        } else {
            NSLog(@"转码失败!\n%@", exportSession.error.localizedDescription);
        }
    }];
}

#pragma mark - 获取媒体资源信息
- (void)getInfoWithAVAsset {
    if ([self.videoList count] <= 0) {
        NSLog(@"not have video.");
        return;
    }
    
    ZLVideoModel *model = [self.videoList firstObject];
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:model.videoFileUrl];
    CMTime time = [avUrl duration];
    // ceil 函数：向上取整
    int second = ceil(time.value / time.timescale);
    NSLog(@"%d", second);
}

#pragma mark - 保存视频到相簿
- (void)saveVideoToAlbum {
    if ([self.videoList count] <= 0) {
        NSLog(@"not have video.");
        return;
    }
    
    ZLVideoModel *model = [self.videoList firstObject];
    NSString *filePath = model.videoFileUrl.path;
    // 判断指定的视频资源是否可以保存到相册中
    BOOL flag = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath);
    NSLog(@"%@", filePath);
    
    if (flag) {
        UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), @"{\"key\":\"value\"}");
    }
    
    NSLog(@"%d", flag);
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        NSLog(@"save successful.");
    } else {
        NSLog(@"save failed. \n%@", error);
    }
}

#pragma mark - 录制视频
- (void)recordVideo {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    // 设置使用相机的类型
    NSString *mediaType = (__bridge NSString *)kUTTypeMovie;
    picker.mediaTypes = @[mediaType];
    picker.delegate = self;
    // 设置录像的视频质量
//    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    // 设置最大限制的录制时间
    picker.videoMaximumDuration = kVideoMaximumDuration;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    NSString *movieType = (__bridge NSString *)kUTTypeMovie;
    
//    NSLog(@"%@ - %@", mediaType, movieType);
    // 经比较，movieType 等于 mediaType : @"public.movie" - @"public.movie"
    if ([movieType isEqualToString:mediaType]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        ZLVideoModel *model = [[ZLVideoModel alloc] init];
        model.videoFileUrl = url;
        model.mediaType = mediaType;
        [self.videoList addObject:model];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"Record Stop.");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)listArray {
    if (!_listArray) {
        _listArray = @[kContactsFrameworkUsage,kRecordVideoUseImagePickerController,kPlayVideoWithAVPlayerViewController,kVideoSaveToAlbum,kGetMediaInfoWithAVAsset,kConvertWithAVAssetExportSession,kCompressWithAVAssetExportSession,kVideoFrameWithAVAssetImageGenerator,kUploadVideoToServer,kSelectVideoOfPhotoLibrary,kPhotosFrameworkUsage,kToOtherLoginVc,kAVPlayerLayerUsage];
    }
    
    return _listArray;
}

- (NSMutableArray *)videoList {
    if (_videoList == nil) {
        _videoList = [NSMutableArray arrayWithCapacity:1];
    }
    return _videoList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"mediaCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.listArray[indexPath.row];
    
    return cell;
}

@end
