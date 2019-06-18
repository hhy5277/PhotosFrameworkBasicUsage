//
//  PDUIEmojiPanel.h
//  PDBotKit
//
//  Created by wuyifan on 2018/11/14.
//  Copyright © 2018 4Paradigm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDUIEmojiPanel;


@protocol PDUIEmojiPanelDelegate <NSObject>

- (void)emojiPanel:(PDUIEmojiPanel*)pluginPanel selectEmoji:(NSString*)emoji;

@end


@interface PDUIEmojiPanel : UIView

@property (nonatomic, weak) id<PDUIEmojiPanelDelegate> delegate;

@end
