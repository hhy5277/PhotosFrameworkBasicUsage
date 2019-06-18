//
//  PDUIMessageMenuCell.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/17.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import "PDUIMessageBaseCell.h"

@class PDUIMessageMenuCell;


@protocol PDUIMessageMenuCellDelegate <NSObject>

- (void)menuCell:(PDUIMessageMenuCell* _Nonnull)menuCell clickedItem:(PDMenuItem* _Nonnull)item withType:(PDMessageMenuType)type;

@end


@interface PDUIMessageMenuCell : PDUIMessageBaseCell

/*
 显示消息内容的背景
 */
@property (nonatomic, strong) UIView* _Nonnull menuBackView;

/*
 显示菜单标题的Label
 */
@property (nonatomic, strong) UILabel* _Nonnull menuHead;

/*
 显示菜单项目的List
 */
@property (nonatomic, strong) NSMutableArray* _Nonnull menuItemsList;

@end
