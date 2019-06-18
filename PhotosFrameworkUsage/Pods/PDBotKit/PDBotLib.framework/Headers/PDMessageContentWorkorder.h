//
//  PDMessageContentWorkorder.h
//  PDBotLib
//
//  Created by wuyifan on 2018/9/7.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import "PDMessageContent.h"

@interface PDMessageContentWorkorder : PDMessageContent

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* message;

- (id)initWithUrl:(NSString*)url andMessage:(NSString*)message;

@end
