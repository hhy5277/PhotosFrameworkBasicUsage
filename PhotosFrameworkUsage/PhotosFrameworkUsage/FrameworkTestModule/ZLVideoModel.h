//
//  ZLVideoModel.h
//  AVPlayerDemo
//
//  Created by 瓜豆2018 on 2019/5/23.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol webJsExport <JSExport>
- (NSString *)playVideo:(NSString *)urlStr;
@end

@interface ZLVideoModel : NSObject <webJsExport>
@property (nonatomic, strong) NSURL *videoFileUrl;
@property (nonatomic, copy) NSString *mediaType;
@end

NS_ASSUME_NONNULL_END
