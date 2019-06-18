//
//  PDUIWebController.h
//  FPBotDemo
//
//  Created by wuyifan on 2018/1/18.
//  Copyright © 2018年 4Paradigm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUIWebController : UIViewController

+ (void)openWebWithTitle:(NSString*)title andURL:(NSURL*)url andRootController:(UIViewController*)rootController;
    
- (id)initWithTitle:(NSString*)title andURL:(NSURL*)url;

@end
