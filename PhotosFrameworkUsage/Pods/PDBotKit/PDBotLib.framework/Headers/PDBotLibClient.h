//
//  PDBotLibClient.h
//  PDBotLib
//
//  Created by wuyifan on 2017/12/26.
//  Copyright © 2017年 4Paradigm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDVisitorInfo.h"
#import "PDMessage.h"
#import "PDMenuItem.h"

#define PDBotLibVersion @"2.5.1"

typedef NS_ENUM(NSInteger, PDConnectionState)
{
    PDConnectionIdel            = 0,
    PDConnectionConnecting      = 1,
    PDConnectionConnectedRobot  = 2,
    PDConnectionConnectedHuman  = 3,
    PDConnectionError           = 4,
};

@protocol PDBotLibClientDelegate <NSObject>

@required

- (void)onReceivedSuggestion:(NSArray*)suggestions;
- (void)onAppendMessage:(PDMessage*)message;

- (void)onConnectionStateChanged:(PDConnectionState)state;

@end

@interface PDBotLibClient : NSObject

@property (nonatomic, weak) id<PDBotLibClientDelegate> delegate;
@property (nonatomic, assign) PDConnectionState connectionState;
@property (nonatomic, strong) NSString* accessKey;
@property (nonatomic, strong) NSString* robotName;
@property (nonatomic, assign) BOOL enableHuman;
@property (nonatomic, assign) BOOL enableEvaluate;
@property (nonatomic, assign) BOOL enableFeedback;

+ (instancetype)sharedClient;

- (void)initWithAccessKey:(NSString*)accessKey;
- (void)setVisitor:(PDVisitorInfo*)visitorInfo;
- (void)connect;
- (void)disconnect;
- (void)askSuggestion:(NSString*)text;
- (void)askQuestion:(NSString*)text;
- (void)askQuestionByMenu:(PDMenuItem*)item andType:(PDMessageMenuType)type;
- (void)askQuestionByImage:(NSURL*)file;
- (void)askQuestionByAudio:(NSURL*)file;
- (void)transferToHumanServices;
- (void)sendFeedbackById:(NSString*)feedbackId isLike:(BOOL)like;

- (NSArray*)getMessageList;
- (NSArray*)getMessageListBrfore:(int)msgId maxSize:(int)size;
- (void)removeMessage:(PDMessage*)message;
- (void)removeMessageBefore:(NSDate*)date;
- (void)removeAllMessages;

- (NSString*)getAvatarPath;
- (NSString*)getLeaveMessageUrl;
- (NSString*)getHumanEvaluateUrl;

@end
