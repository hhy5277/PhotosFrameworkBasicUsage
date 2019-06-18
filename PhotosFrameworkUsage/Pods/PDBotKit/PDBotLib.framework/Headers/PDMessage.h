//
//  PDMessage.h
//  PDBotLib
//
//  Created by wuyifan on 2017/12/27.
//  Copyright © 2017年 4Paradigm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDMessageContent.h"

typedef NS_ENUM(NSInteger, PDMessageDirection)
{
    PDMessageDirectionSend  = 0,
    PDMessageDirectionRecv  = 1,
};

typedef NS_ENUM(NSInteger, PDMessageContentType)
{
    PDMessageContentTypeNull           = 0,
    PDMessageContentTypeText           = 1,
    PDMessageContentTypeMenu           = 2,
    PDMessageContentTypeImage          = 3,
    PDMessageContentTypeRichText       = 4,
    PDMessageContentTypeAudio          = 5,
    PDMessageContentTypeVideo          = 6,
    PDMessageContentTypeTip            = 7,
    PDMessageContentTypeWorkorder      = 8,
    PDMessageContentTypeEvaluate       = 9,
};

@interface PDMessage : NSObject <NSCoding>

@property (nonatomic, assign) int msgId;
@property (nonatomic, strong) NSDate* sendTime;
@property (nonatomic, assign) PDMessageDirection direction;
@property (nonatomic, assign) PDMessageContentType contentType;
@property (nonatomic, strong) PDMessageContent* content;

@property (nonatomic, strong) NSString* feedbackId;

- (id)initWithDirection:(PDMessageDirection)direction
         andContentType:(PDMessageContentType)contentType
      andMessageContent:(PDMessageContent*)content;

- (id)initWithId:(int)msgId
     andSendTime:(NSDate*)sendTime
    andDirection:(PDMessageDirection)direction
  andContentType:(PDMessageContentType)contentType
andMessageContent:(PDMessageContent*)content;

+ (NSString*)contentTypeToString:(PDMessageContentType)type;
+ (PDMessageContentType)contentTypeFromString:(NSString*)type;

@end
