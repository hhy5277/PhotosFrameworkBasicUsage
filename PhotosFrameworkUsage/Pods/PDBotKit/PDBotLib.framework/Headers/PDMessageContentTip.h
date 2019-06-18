//
//  PDMessageContentTip.h
//  PDBotLib
//
//  Created by wuyifan on 2018/5/24.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import "PDMessageContent.h"

@interface PDMessageContentTip : PDMessageContent

@property (nonatomic, strong) NSString* tip;

- (id)initWithTip:(NSString*)tip;

@end
