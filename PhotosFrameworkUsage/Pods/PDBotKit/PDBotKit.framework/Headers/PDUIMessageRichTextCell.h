//
//  PDUIMessageRichTextCell.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/18.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import "PDUIMessageBaseCell.h"

@class PDUIMessageRichTextCell;


@protocol PDUIMessageRichTextCellDelegate <NSObject>

- (void)richTextCell:(PDUIMessageRichTextCell* _Nonnull)richTextCell clickedContent:(PDMessageContentRichText* _Nonnull)content;

@end


@interface PDUIMessageRichTextCell : PDUIMessageBaseCell

/*
 图文封面图片
 */
@property (nonatomic, strong) UIImageView* _Nonnull richCoverView;

/*
 图文标题文字
 */
@property (nonatomic, strong) UILabel* _Nonnull richTitleLabel;

/*
 图文摘要文字
 */
@property (nonatomic, strong) UILabel* _Nonnull richDigestLabel;

@end
