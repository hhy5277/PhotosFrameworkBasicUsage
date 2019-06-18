//
//  PDUIMessageWorkorderCell.h
//  PDBotKit
//
//  Created by wuyifan on 2018/9/7.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import "PDUIMessageBaseCell.h"

@class PDUIMessageWorkorderCell;


@protocol PDUIMessageWorkorderCellDelegate <NSObject>

- (void)workorderCell:(PDUIMessageWorkorderCell* _Nonnull)workorderCell clickedContent:(PDMessageContentWorkorder* _Nonnull)content;

@end


@interface PDUIMessageWorkorderCell : PDUIMessageBaseCell

@property (nonatomic, strong) UILabel* _Nonnull textMessageLabel;

@end
