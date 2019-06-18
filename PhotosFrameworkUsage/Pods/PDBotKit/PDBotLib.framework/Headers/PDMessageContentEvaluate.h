//
//  PDMessageContentEvaluate.h
//  PDBotLib
//
//  Created by wuyifan on 2018/11/21.
//  Copyright © 2018 4Paradigm. All rights reserved.
//

#import <PDBotLib/PDBotLib.h>

@interface PDMessageContentEvaluate : PDMessageContent

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* message;

- (id)initWithUrl:(NSString*)url andMessage:(NSString*)message;

@end
