//
//  PDUIMessageEvaluateCell.h
//  PDBotKit
//
//  Created by wuyifan on 2018/11/21.
//  Copyright © 2018 4Paradigm. All rights reserved.
//

#import "PDUIMessageBaseCell.h"

@class PDUIMessageEvaluateCell;


@protocol PDUIMessageEvaluateCellDelegate <NSObject>

- (void)evaluateCell:(PDUIMessageEvaluateCell* _Nonnull)evaluateCell clickedContent:(PDMessageContentEvaluate* _Nonnull)content;

@end


@interface PDUIMessageEvaluateCell : PDUIMessageBaseCell

@property (nonatomic, strong) UILabel* _Nonnull textMessageLabel;

@end
