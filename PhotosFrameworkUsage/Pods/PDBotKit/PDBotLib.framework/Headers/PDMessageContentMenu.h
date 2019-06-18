//
//  PDMessageContentMenu.h
//  PDBotLib
//
//  Created by wuyifan on 2017/12/27.
//  Copyright © 2017年 4Paradigm. All rights reserved.
//

#import "PDMessageContent.h"
#import "PDMenuItem.h"

@interface PDMessageContentMenu : PDMessageContent

@property (nonatomic, assign) PDMessageMenuType menuType;
@property (nonatomic, strong) NSString* menuName;
@property (nonatomic, strong) NSArray* menuItems;

- (id)initWithType:(PDMessageMenuType)menuType andName:(NSString*)menuName andItems:(NSArray*)menuItems;

@end
