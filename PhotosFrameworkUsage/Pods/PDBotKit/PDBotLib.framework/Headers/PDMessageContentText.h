//
//  PDMessageContentText.h
//  PDBotLib
//
//  Created by wuyifan on 2017/12/27.
//  Copyright © 2017年 4Paradigm. All rights reserved.
//

#import "PDMessageContent.h"

@interface PDMessageContentText : PDMessageContent

@property (nonatomic, strong) NSString* text;

- (id)initWithText:(NSString*)text;

@end
