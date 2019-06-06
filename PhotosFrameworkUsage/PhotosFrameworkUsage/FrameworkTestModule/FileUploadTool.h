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

+ (void)truncateFiles;

+ (NSArray *)getFiles;

+ (NSData *)getFileDataWithFileid:(NSInteger)fileid;

+ (void)save:(NSString *)path;

+ (void)uploadAudio:(NSString *)path completionHandler:(void (^)(NSString *result, NSError *error))completionHandler;

+ (void)uploadVideo:(NSString *)path completionHandler:(void (^)(NSString *result, NSError *error))completionHandler;

+ (void)uploadFile:(NSArray *)paths fieldName:(NSString *)fieldName completionHandler:(void (^)(NSString *result, NSError *error))completionHandler;

+ (void)uploadFile:(NSArray *)paths fieldNames:(NSArray *)fieldNames completionHandler:(void (^)(NSString *result, NSError *error))completionHandler;

+ (NSString *)mimeTypeForPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
