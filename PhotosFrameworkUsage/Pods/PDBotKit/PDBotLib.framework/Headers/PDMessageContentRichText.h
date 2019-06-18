//
//  PDMessageContentRichText.h
//  PDBotLib
//
//  Created by wuyifan on 2018/1/18.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import "PDMessageContent.h"

@interface PDMessageContentRichText : PDMessageContent

@property (nonatomic, strong) NSString* coverPath;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* digest;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, assign) BOOL directShow;

- (id)initWithCover:(NSString*)coverPath andTitle:(NSString*)title andDigest:(NSString*)digest andUrl:(NSString*)url;

@end
