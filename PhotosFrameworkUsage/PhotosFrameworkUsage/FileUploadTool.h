//
//  FileUploadTool.h
//  YYEEmployer
//
//  Created by 瓜豆2018 on 2019/5/17.
//  Copyright © 2019年 瓜豆2018. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//mimeType:@"video/mpeg",@"image/jpeg",@"image/png"

@interface FileUploadTool : NSObject
+ (void)testUpload:(NSArray *)imgNameArray img:(NSArray *)imgArray params:(NSDictionary *)params success:(void (^)(void))success;
@end

NS_ASSUME_NONNULL_END
