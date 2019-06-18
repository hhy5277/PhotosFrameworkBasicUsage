//
//  PDMessageContentImage.h
//  PDBotLib
//
//  Created by wuyifan on 2017/12/28.
//  Copyright © 2017年 4Paradigm. All rights reserved.
//

#import "PDMessageContent.h"

@interface PDMessageContentImage : PDMessageContent

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* dataPath;

- (id)initWithUrl:(NSString*)url andDataPath:(NSString*)dataPath;

@end
