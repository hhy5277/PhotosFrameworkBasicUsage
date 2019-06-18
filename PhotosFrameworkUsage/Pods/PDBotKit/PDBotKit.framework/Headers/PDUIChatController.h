//
//  PDUIChatController.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/4.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBotKitClient.h"
#import "PDUIEmojiPanel.h"
#import "PDUIPluginPanel.h"
#import "PDUISuggestionPanel.h"
#import "PDUIMessageTextCell.h"
#import "PDUIMessageMenuCell.h"
#import "PDUIMessageImageCell.h"
#import "PDUIMessageAudioCell.h"
#import "PDUIMessageRichTextCell.h"
#import "PDUIMessageTipCell.h"
#import "PDUIMessageWorkorderCell.h"
#import "PDUIMessageEvaluateCell.h"

@interface PDUIChatController : UIViewController <PDUIEmojiPanelDelegate, PDUIPluginPanelDelegate, PDUISuggestionPanelDelegate, PDUIMessageTextCellDelegate, PDUIMessageMenuCellDelegate, PDUIMessageImageCellDelegate, PDUIMessageAudioCellDelegate, PDUIMessageRichTextCellDelegate, PDUIMessageWorkorderCellDelegate, PDUIMessageEvaluateCellDelegate, PDBotLibClientDelegate>

/* 聊天列表 */
@property (nonatomic, strong) UITableView* messageTableView;

- (void)reloadMessageList;
- (void)registerCellClass:(Class)cellClass forMessageType:(PDMessageContentType)type;
- (void)appendMessageList:(PDMessage*)message;

@end
