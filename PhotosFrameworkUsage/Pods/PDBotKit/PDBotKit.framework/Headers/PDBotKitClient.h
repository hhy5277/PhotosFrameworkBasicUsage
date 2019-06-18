//
//  PDBotKitClient.h
//  PDBotKit
//
//  Created by wuyifan on 2018/7/3.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDBotLib/PDBotLib.h>

@interface PDBotKitClient : PDBotLibClient

@property (strong, nonatomic) UIImage* userPortrait;
@property (strong, nonatomic) UIImage* robotPortrait;

+ (instancetype)sharedClient;

@end
