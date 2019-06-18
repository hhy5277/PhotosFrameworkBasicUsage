//
//  PDUIMessageAudioCell.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/17.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import "PDUIMessageBaseCell.h"

@class PDUIMessageAudioCell;


@protocol PDUIMessageAudioCellDelegate <NSObject>

- (void)audioCell:(PDUIMessageAudioCell* _Nonnull)audioCell clickedContent:(PDMessageContentAudio* _Nonnull)content;

@end


@interface PDUIMessageAudioCell : PDUIMessageBaseCell

/*
 显示音频符号
 */
@property (nonatomic, strong) UIImageView* _Nonnull audioImageView;

/*
 显示音频时长
 */
@property (nonatomic, strong) UILabel* _Nonnull audioDuration;

@end
