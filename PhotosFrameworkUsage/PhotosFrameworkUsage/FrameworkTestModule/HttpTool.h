//
//  HttpTool.h
//  YYAudit
//
//  Created by 瓜豆2018 on 2019/5/7.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpTool : NSObject

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass success:(void (^)(id resultObj))success failure:(void (^)(NSError *error))failure;

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params datas:(NSArray *)datas resultClass:(Class)resultClass success:(void (^)(id resultObj))success failure:(void (^)(NSError *error))failure;

+ (void)getWithUrl:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass success:(void (^)(id resultObj))success failure:(void (^)(NSError *error))failure;

+ (void)downloadWithUrl:(NSString *)url success:(void (^)(NSData *fileData))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
