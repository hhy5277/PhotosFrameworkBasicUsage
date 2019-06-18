//
//  PDUIPluginPanel.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/15.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDUIPluginPanel;


@protocol PDUIPluginPanelDelegate <NSObject>

- (void)pluginPanel:(PDUIPluginPanel*)pluginPanel clickedItemWithTag:(NSInteger)tag;

@end


@interface PDUIPluginPanel : UIView

@property (nonatomic, weak) id<PDUIPluginPanelDelegate> delegate;

/*
 向扩展功能板中插入扩展项
 */
- (void)insertItemWithImage:(UIImage*)image title:(NSString*)title atIndex:(NSUInteger)index tag:(NSInteger)tag;

/*
 添加扩展项到扩展功能板，并在显示为最后一项
 */
- (void)insertItemWithImage:(UIImage*)image title:(NSString*)title tag:(NSInteger)tag;

/*
 更新指定扩展项
 */
- (void)updateItemAtIndex:(NSUInteger)index image:(UIImage*)image title:(NSString*)title;

/*
 更新指定扩展项
 */
- (void)updateItemWithTag:(NSInteger)tag image:(UIImage*)image title:(NSString*)title;

/*
 删除扩展功能板中的指定扩展项
 */
- (void)removeItemAtIndex:(NSUInteger)index;

/*
 删除扩展功能板中的指定扩展项
 */
- (void)removeItemWithTag:(NSInteger)tag;

/*
 删除扩展功能板中的所有扩展项
 */
- (void)removeAllItems;

/*
 隐藏指定扩展项
 */
- (void)hideItemAtIndex:(NSUInteger)index hidden:(BOOL)hidden;

/*
 隐藏指定扩展项
 */
- (void)hideItemWithTag:(NSInteger)tag hidden:(BOOL)hidden;

@end
