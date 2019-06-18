//
//  PDUISuggestionPanel.h
//  PDBotKit
//
//  Created by wuyifan on 2018/1/15.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDBotLib/PDBotLib.h>

@class PDUISuggestionPanel;


@protocol PDUISuggestionPanelDelegate <NSObject>

- (void)suggestionPanel:(PDUISuggestionPanel*)suggestionPanel clickedItem:(PDMenuItem*)item;

@end


@interface PDUISuggestionPanel : UIView

@property (nonatomic, weak) id<PDUISuggestionPanelDelegate> delegate;

- (void)setSuggestionArray:(NSArray*)array;

@end
