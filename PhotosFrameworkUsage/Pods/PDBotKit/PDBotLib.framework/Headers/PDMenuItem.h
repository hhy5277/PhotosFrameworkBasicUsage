//
//  PDMenuItem.h
//  PDBotLib
//
//  Created by wuyifan on 2017/12/27.
//  Copyright © 2017年 4Paradigm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDMessage.h"

typedef NS_ENUM(NSInteger, PDMessageMenuType)
{
    PDMessageMenuTypeMenu           = 0,
    PDMessageMenuTypeRecommend      = 1,
    PDMessageMenuTypeAcceptGroup    = 2,
};

@interface PDMenuItem : NSObject <NSCoding>

@property (strong, nonatomic) NSString* itemId;
@property (strong, nonatomic) NSString* content;
@property (assign, nonatomic) PDMessageContentType type;

- (id)initWithId:(NSString*)itemId andContent:(NSString*)content andType:(PDMessageContentType)type;

@end
