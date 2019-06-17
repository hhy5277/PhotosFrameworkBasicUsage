//
//  SpeechRecognitionViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/6.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "SpeechRecognitionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

#define LoadingText @"正在录音。。。"

@interface SpeechRecognitionViewController () <SFSpeechRecognizerDelegate>
@property (nonatomic, strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic, weak) IBOutlet UILabel *resultStringLabel;
@property (nonatomic, weak) IBOutlet UIButton *recordButton;
@end

@implementation SpeechRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recordButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof(self) wekself = self;
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    wekself.recordButton.enabled = NO;
                    [wekself.recordButton setTitle:@"语音识别未授权" forState:UIControlStateNormal];
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    wekself.recordButton.enabled = NO;
                    [wekself.recordButton setTitle:@"用户未授权使用语音识别" forState:UIControlStateNormal];
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    wekself.recordButton.enabled = NO;
                    [wekself.recordButton setTitle:@"语音识别在这台设备上受到限制" forState:UIControlStateNormal];
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    wekself.recordButton.enabled = YES;
                    [wekself.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        });
    }];
}

#pragma mark - action
/**
 识别本地音频文件
 */
- (IBAction)recognizeLocalAudioFile {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    SFSpeechRecognizer *localRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"录音.m4a" withExtension:nil];
    if (!url) return;
    SFSpeechURLRecognitionRequest *res = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
    __weak typeof(self) wekself = self;
    [localRecognizer recognitionTaskWithRequest:res resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSString *errMsg = [NSString stringWithFormat:@"语音识别解析失败, %@", error];
            [BaseViewController hudWithTitle:errMsg];
            NSLog(@"%@", errMsg);
        } else {
            wekself.resultStringLabel.text = result.bestTranscription.formattedString;
        }
    }];
}

- (IBAction)recordButtonClicked {
    if ([self.audioEngine isRunning]) {
        [self endRecording];
        [self.recordButton setTitle:@"正在停止" forState:UIControlStateDisabled];
    } else {
        [self startRecoding];
        [self.recordButton setTitle:@"停止录音" forState:UIControlStateNormal];
    }
}

- (void)endRecording {
    [self.audioEngine stop];
    if (_recognitionRequest) {
        [_recognitionRequest endAudio];
    }
    
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    
    self.recordButton.enabled = NO;
    
    if ([self.resultStringLabel.text isEqualToString:LoadingText]) {
        self.resultStringLabel.text = @"";
    }
}

- (IBAction)startRecoding {
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    
    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = [self.audioEngine inputNode];
    
    NSAssert(inputNode, @"录入设备没有准备好");
    NSAssert(_recognitionRequest, @"请求初始化失败");
    
    _recognitionRequest.shouldReportPartialResults = YES;
    __weak typeof(self) wekself = self;
    _recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        __strong typeof(wekself) strongself = wekself;
        BOOL isFinal = NO;
        if (result) {
            NSLog(@"%@", result.bestTranscription.formattedString);
            strongself.resultStringLabel.text = result.bestTranscription.formattedString;
            isFinal = result.isFinal;
        }
        
        if (error || isFinal) {
            [wekself.audioEngine stop];
            [inputNode removeTapOnBus:0];
            strongself.recognitionTask = nil;
            strongself.recognitionRequest = nil;
            strongself.recordButton.enabled = YES;
            [strongself.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
        }
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    // 在添加tap之前先移除上一个 不然可能报错
    [inputNode removeTapOnBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(wekself) strongself = wekself;
        if (strongself.recognitionRequest) {
            [strongself.recognitionRequest appendAudioPCMBuffer:buffer];
        }
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    NSParameterAssert(!error);
    self.resultStringLabel.text = LoadingText;
}

#pragma mark - property
- (AVAudioEngine *)audioEngine {
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    
    return _audioEngine;
}

- (SFSpeechRecognizer *)speechRecognizer {
    if (!_speechRecognizer) {
        // 要为语音识别对象设置语音，这里设置的是中文
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
        _speechRecognizer.delegate = self;
    }
    
    return _speechRecognizer;
}

#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    if (available) {
        self.recordButton.enabled = YES;
        [self.recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
    } else {
        self.recordButton.enabled = NO;
        [self.recordButton setTitle:@"语音识别不可用" forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    NSLog(@"speechRecognizer - dealloc.");
}

@end
