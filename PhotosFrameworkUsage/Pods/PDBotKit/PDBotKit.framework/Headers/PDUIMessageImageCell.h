//
//  PDUIMessageImageCell.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/17.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import "PDUIMessageBaseCell.h"

@class PDUIMessageImageCell;


@protocol PDUIMessageImageCellDelegate <NSObject>

- (void)imageCell:(PDUIMessageImageCell* _Nonnull)imageCell clickedContent:(PDMessageContentImage* _Nonnull)content;

@end


@interface PDUIMessageImageCell : PDUIMessageBaseCell

/*
 显示消息内容的图片
 */
@property (nonatomic, strong) UIImageView* _Nonnull imageContentView;

@end
