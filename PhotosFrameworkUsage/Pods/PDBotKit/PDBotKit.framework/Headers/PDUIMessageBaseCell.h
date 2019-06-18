//
//  PDUIMessageBaseCell.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/8.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUIMessageModel.h"

@interface PDUIMessageBaseCell : UITableViewCell

/*
 消息Cell的数据模型
 */
@property (nonatomic, strong) PDUIMessageModel* _Nonnull model;

/*
 显示时间
 */
@property (nonatomic, strong) UILabel* _Nonnull messageTimeLabel;

/*
 显示消息发送者的用户头像
 */
@property (nonatomic, strong) UIImageView* _Nonnull portraitImageView;

/*
 显示消息气泡
 */
@property (nonatomic, strong) UIImageView* _Nonnull messageBubbleView;

/*
 顶按钮
 */
@property (nonatomic, strong) UIImageView* _Nonnull feedbackLikeView;

/*
 踩按钮
 */
@property (nonatomic, strong) UIImageView* _Nonnull feedbackDislikeView;

/*
 显示的内容
 */
@property (nonatomic, strong) UIView* _Nonnull messageContentView;

/*
 消息处理代理
 */
@property (nonatomic, weak) _Nullable id delegate;

/*
 初始化消息Cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;

/*
 设置当前消息Cell的数据模型
 */
- (void)setMessageModel:(nonnull PDUIMessageModel*)model;

/*
 设置消息Cell的大小
 */
+ (void)setCellSizeForMessage:(nonnull PDUIMessageModel*)model withMaxWidth:(CGFloat)maxWidth;

/*
 计算消息内容的高度
 */
+ (CGSize)contentSizeForMessage:(nonnull PDUIMessageModel*)model withMaxWidth:(CGFloat)maxWidth;

@end
