//
//  PDUIMessageTextCell.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/8.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import "PDUIMessageBaseCell.h"

@class PDUIMessageTextCell;


@protocol PDUIMessageTextCellDelegate <NSObject>
    
- (void)textCell:(PDUIMessageTextCell* _Nonnull)textCell clickedUrl:(NSString* _Nonnull)url;
    
@end


@interface PDUIMessageTextCell : PDUIMessageBaseCell

/*
 显示消息内容的Label
 */
@property (nonatomic, strong) UILabel* _Nonnull textMessageLabel;

@end
