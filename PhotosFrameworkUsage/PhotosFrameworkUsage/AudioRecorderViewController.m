//
//  AudioRecorderViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/31.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "AudioRecorderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioListViewController.h"

#define kMaxminuDuration 60
#define kRecorderAudio @"录音"
#define kPauseRecorderAudio @"暂停录音"
#define kStopRecoderAudio @"停止录音"
#define kPlayRecoderAudio @"播放录音"
#define kPausePlayAudio @"暂停播放录音"
#define kStopPlayAudio @"停止播放录音"
#define kAudioList @"录音列表"
#define kDeleteAllFiles @"清空文件列表"

@interface AudioRecorderViewController () <UITableViewDataSource,UITableViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    dispatch_source_t timer;
}

@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,assign) SystemSoundID soundID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)AVAudioPlayer *player;
@property (nonatomic,strong)NSArray *listArr;
@property (nonatomic,copy)NSString *audioFile;
@property (nonatomic,strong) AVAudioSession *audioSession;
@end

@implementation AudioRecorderViewController

- (NSArray *)listArr {
    if (_listArr == nil) {
        _listArr = @[kRecorderAudio,kPauseRecorderAudio,kStopRecoderAudio,kPlayRecoderAudio,kPausePlayAudio,kStopPlayAudio,kAudioList,kDeleteAllFiles];
    }
    return _listArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"AudioCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.listArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if ([text isEqualToString:kRecorderAudio]) {
        [self startRecorder];
    } else if ([text isEqualToString:kStopRecoderAudio]) {
        [self stopRecorder];
    } else if ([text isEqualToString:kPlayRecoderAudio]) {
        [self playAudio];
    } else if ([text isEqualToString:kPausePlayAudio]) {
        [self pauseAudio];
    } else if ([text isEqualToString:kStopPlayAudio]) {
        [self stopAudio];
    } else if ([text isEqualToString:kPauseRecorderAudio]) {
        [self pauseRecorderAudio];
    } else if ([text isEqualToString:kAudioList]) {
        [self audioList];
    } else if ([text isEqualToString:kDeleteAllFiles]) {
        [self deleteAllFiles];
    }
}

#pragma mark - 清空录音列表
- (void)deleteAllFiles {
    [FileUploadTool truncateFiles];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"删除完成";
    [hud hideAnimated:YES afterDelay:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [[[UIAlertView alloc] initWithTitle:@"permission" message:(granted?@"有权限":@"没有权限") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            
            self.audioSession = [AVAudioSession sharedInstance];
            [self.audioSession setActive:YES error:nil];
        });
    }];
}

#pragma mark - 录音列表
- (void)audioList {
    AudioListViewController *vc = [[AudioListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audioPlayerDidFinishPlaying - successfully");
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    NSLog(@"audioPlayerDecodeErrorDidOccur - error");
}

//播放（异步播放）
- (IBAction)playAudio {
    [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (_player == nil) {
        NSURL *url = self.recorder.url;
        NSError *error = nil;
        //2.创建AVAudioPlayer对象
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        if (error) {
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            return;
        }
        
        _player.delegate = self;
        NSLog(@"%f", _player.duration);
    }
    
    //3.准备播放（缓冲，提高播放的流畅性）
    [self.player prepareToPlay];
    [self.player play];
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

-(SystemSoundID)soundID{
    if (_soundID == 0) {
        //生成soundID
        CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle]URLForResource:@"buyao.wav" withExtension:nil];
        AudioServicesCreateSystemSoundID(url, &_soundID);
    }
    return _soundID;
}

- (IBAction)playSound {
    //播放音效
    AudioServicesPlaySystemSound(self.soundID);//不带震动效果
    //AudioServicesPlayAlertSound(<#SystemSoundID inSystemSoundID#>)//带震动效果
}

//懒加载
-(AVAudioRecorder *)recorder{
    if (_recorder == nil) {
        NSString *globallyUniqueString = [NSProcessInfo processInfo].globallyUniqueString;
        self.audioFile = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",globallyUniqueString]];
        
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        recordSettings[AVFormatIDKey] = @(kAudioFormatAppleLossless);
        recordSettings[AVSampleRateKey] = @44100.0f;
        recordSettings[AVNumberOfChannelsKey] = @2;
        
        // Initiate and prepare the recorder
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.audioFile] settings:recordSettings error:nil];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
    }
    return _recorder;
}

// 开始录音
- (IBAction)startRecorder {
    [self.audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [self.recorder prepareToRecord];
//    [self.recorder record];
    [self.recorder recordForDuration:kMaxminuDuration];
    [self activeTimer];
}

static int currentTime = 0;
- (void)activeTimer {
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(1,1));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%02d", (currentTime++)] style:UIBarButtonItemStylePlain target:nil action:nil];
        });
        
        if (currentTime == kMaxminuDuration) {
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
}

// 停止录音
- (IBAction)stopRecorder {
    currentTime = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%02d", (currentTime++)] style:UIBarButtonItemStylePlain target:nil action:nil];
    dispatch_source_cancel(timer);
    timer = nil;
    [self.recorder stop];
}

- (void)pauseRecorderAudio {
    dispatch_source_cancel(timer);
    [self.recorder pause];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"%@",[[NSFileManager defaultManager] attributesOfItemAtPath:recorder.url.path error:nil]);
    NSLog(@"audioRecorderDidFinishRecording - successfully");
    if (flag) {
        NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf", [NSUUID UUID].UUIDString]];
        [[NSFileManager defaultManager] createFileAtPath:filepath contents:[NSData dataWithContentsOfURL:recorder.url] attributes:nil];
        [FileUploadTool save:filepath];
    }
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    NSLog(@"audioRecorderEncodeErrorDidOccur - error");
}

@end
