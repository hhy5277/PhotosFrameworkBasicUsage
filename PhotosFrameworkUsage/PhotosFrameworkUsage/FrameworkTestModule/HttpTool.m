//
//  HttpTool.m
//  YYAudit
//
//  Created by 瓜豆2018 on 2019/5/7.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

@implementation HttpTool

+ (void)downloadWithUrl:(NSString *)url success:(void (^)(NSData *fileData))success failure:(void (^)(NSError *error))failure {
    @try {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (error) {
                if (failure) {
                    failure(error);
                }
            } else {
                if (success) {
                    success([NSData dataWithContentsOfFile:location.path]);
                }
            }
        }] resume];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass success:(void (^)(id resultObj))success failure:(void (^)(NSError *error))failure {
    @try {
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [self setupSessionAttribute:session];
        [session POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (success) {
                success([resultClass mj_objectWithKeyValues:responseObject]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (failure) {
                failure(error);
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params datas:(NSArray *)datas resultClass:(Class)resultClass success:(void (^)(id resultObj))success failure:(void (^)(NSError *error))failure {
    @try {
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [self setupSessionAttribute:session];
        [session POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (NSData *data in datas) {
                [formData appendPartWithFileData:data name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (success) {
                success([resultClass mj_objectWithKeyValues:responseObject]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (failure) {
                failure(error);
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

+ (void)getWithUrl:(NSString *)url params:(NSDictionary *)params resultClass:(Class)resultClass success:(void (^)(id resultObj))success failure:(void (^)(NSError *error))failure {
    @try {
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [self setupSessionAttribute:session];
        [session GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (success) {
                success([resultClass mj_objectWithKeyValues:responseObject]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (failure) {
                failure(error);
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

+ (void)setupSessionAttribute:(AFHTTPSessionManager *)session {
    @try {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        session.requestSerializer = [AFHTTPRequestSerializer serializer];
        session.requestSerializer.timeoutInterval = 20;
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
        [session.requestSerializer setValue:@"eyJhbGciOiJIUzI1NiJ9.eyJpc3MiIDogImh0dHBzOi8vY2FwaS5kYnMuY29tIiwiaWF0IiA6IDE1NTk3MDI1OTcxNTYsICJleHAiIDogMTU1OTcwNjE5NzE1Niwic3ViIiA6ICJaR1Z0Ync9PSIsInB0eXR5cGUiIDogMywiY2xuaWQiIDogImNsaWVudElkMyIsImNsbnR5cGUiIDogIjIiLCAiYWNjZXNzIiA6ICIxRkEiLCJzY29wZSIgOiAiUkVBRCIgLCJhdWQiIDogImh0dHBzOi8vY2FwaS5kYnMuY29tL2FjY2VzcyIgLCJqdGkiIDogIjc0NzkxODgyODA1MjY3ODI4MjMiIH0.GCADkSmM0frxV6_teCTQEZYdo5nb5t1tU4FzegcQ4zA" forHTTPHeaderField:@"accessToken"];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",@"text/json", @"text/javascript", nil];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

@end
