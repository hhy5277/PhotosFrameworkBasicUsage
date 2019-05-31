//
//  AudioListViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/31.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "AudioListViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioListViewController ()<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>

@property (nonatomic, strong) NSArray *files;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation AudioListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.files = [FileUploadTool getFiles];
    [self.tableView reloadData];
    
    self.audioSession = [AVAudioSession sharedInstance];
    [self.audioSession setActive:YES error:nil];
    [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"share audio" style:UIBarButtonItemStylePlain target:self action:@selector(shareOnClick)];
}

- (void)shareOnClick {
    if ([self.files count] <= 0) {
        [[[UIAlertView alloc] initWithTitle:@"not have files." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.files.count];
    
//    for (NSDictionary *dict in self.files) {
        NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf", [NSUUID UUID].UUIDString]];
        NSData *data = [FileUploadTool getFileDataWithFileid:[[self.files firstObject][@"fileid"] integerValue]];
        BOOL flag = [data writeToFile:filepath atomically:YES];
//        BOOL flag = [[NSFileManager defaultManager] createFileAtPath:filepath contents:data attributes:nil];
        [arr addObject:filepath];
        NSLog(@"%d\n%@", flag,filepath);
//    }
    
    [SystemShareViewController sendEmailWithFilePath:arr viewController:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.files count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"AudioFileCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dict = self.files[indexPath.row];
    cell.textLabel.text = [dict[@"fileid"] stringValue];
    cell.detailTextLabel.text = [dict[@"filepath"] lastPathComponent];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_player isPlaying]) {
        [self stopAudio];
    } else {
        NSDictionary *dict = self.files[indexPath.row];
        NSData *fileData = [FileUploadTool getFileDataWithFileid:[dict[@"fileid"] integerValue]];
        //    if (_player == nil) {
        NSError *error = nil;
        //2.创建AVAudioPlayer对象
        _player = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        if (error) {
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            return;
        }
        
        _player.delegate = self;
        NSLog(@"%f", _player.duration);
        //    }
        
        //3.准备播放（缓冲，提高播放的流畅性）
        [self.player prepareToPlay];
        [self.player play];
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying - successfully");
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"audioPlayerDecodeErrorDidOccur - error");
}

//暂停音乐，暂停后再开始从暂停的地方开始
- (IBAction)pauseAudio {
    [self.player pause];
}

//停止音乐，停止后再开始从头开始
- (IBAction)stopAudio {
    [self.player stop];
    //这里要置空
    self.player = nil;
}

- (void)dealloc {
    [self.player stop];
    self.audioSession = nil;
    self.player = nil;
    
}

@end
