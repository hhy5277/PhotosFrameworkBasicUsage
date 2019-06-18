//
//  PDUIMessageModel.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/9.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PDBotLib/PDBotLib.h>

/*
 消息Cell的数据模型类
 */
@interface PDUIMessageModel : NSObject

/*
 消息方向
 */
@property (nonatomic, assign) PDMessageDirection direction;

/*
 消息的类型名
 */
@property (nonatomic, assign) PDMessageContentType contentType;

/*
 消息的发送时间
 */
@property (nonatomic, strong) NSDate* sendTime;

/*
 消息的内容
 */
@property (nonatomic, strong) PDMessageContent* content;

/*
 反馈编号
 */
@property (nonatomic, strong) NSString* feedbackId;

/*
 反馈结果
 */
@property (nonatomic, strong) NSNumber* feedbackResult;

/*
 是否显示时间
 */
@property (nonatomic, assign) BOOL isDisplayMessageTime;

/*
 消息发送者头像
 */
@property (nonatomic, strong) UIImage* portraitImage;

/*
 消息展示时的Cell高度
 */
@property (nonatomic, assign) CGSize cellSize;

/*
 消息展示时的内容高度
 */
@property (nonatomic, assign) CGSize contentSize;

/*
 初始化消息Cell的数据模型
 */
+ (instancetype)modelWithMessage:(PDMessage*)message;

/*
 初始化消息Cell的数据模型
 */
- (instancetype)initWithMessage:(PDMessage *)message;

@end
