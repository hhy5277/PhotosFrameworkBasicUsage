//
//  FileUploadTool.m
//  YYEEmployer
//
//  Created by 瓜豆2018 on 2019/5/17.
//  Copyright © 2019年 瓜豆2018. All rights reserved.
//

#import "FileUploadTool.h"
#import <CoreServices/CoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "FMDB.h"

static FMDatabase *_database;

@implementation FileUploadTool

+ (FMDatabase *)database {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"db_files.sqlite"];
        _database = [FMDatabase databaseWithPath:path];
        [_database open];
        [_database executeUpdate:@"CREATE TABLE IF NOT EXISTS tb_files (fileid integer primary key autoincrement, filedata blob, filepath varchar);"];
        [_database close];
    });
    return _database;
}

+ (NSArray *)getFiles {
    [self.database open];
    FMResultSet *rst = [self.database executeQuery:@"select fileid,filepath from tb_files;"];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    while (rst.next) {
        [arr addObject:[rst resultDictionary]];
    }
    [rst close];
    [self.database close];
    rst = nil;
    return arr;
}

+ (void)truncateFiles {
    [self.database open];
    [self.database executeUpdate:@"delete from tb_files;"];
    [self.database close];
}

+ (NSData *)getFileDataWithFileid:(NSInteger)fileid {
    [self.database open];
    FMResultSet *rst = [self.database executeQuery:@"select filedata from tb_files where fileid=?;" withArgumentsInArray:@[@(fileid)]];
    NSData *data = nil;
    if (rst.next) {
        data = [rst dataForColumn:@"filedata"];
    }
    [rst close];
    [self.database close];
    rst = nil;
    return data;
}

+ (void)save:(NSString *)filepath {
    [self.database open];
    BOOL flag = [self.database executeUpdate:@"insert into tb_files(filedata,filepath) values(?,?);" withArgumentsInArray:@[[NSData dataWithContentsOfFile:filepath],filepath]];
    [self.database close];
    NSLog(@"%d", flag);
}

+ (void)uploadAudio:(NSString *)path completionHandler:(void (^)(NSString *result, NSError *error))completionHandler {
    NSString *fieldName = @"recorder.caf";
    [self uploadFile:@[path] fieldName:fieldName completionHandler:completionHandler];
}

+ (void)uploadVideo:(NSString *)path completionHandler:(void (^)(NSString *result, NSError *error))completionHandler {
    NSString *fieldName = @"movie.mp4";
    [self uploadFile:@[path] fieldName:fieldName completionHandler:completionHandler];
}

+ (void)uploadFile:(NSArray *)paths fieldName:(NSString *)fieldName completionHandler:(void (^)(NSString *result, NSError *error))completionHandler {
    [self uploadFile:paths fieldNames:@[fieldName] completionHandler:completionHandler];
}

+ (void)uploadFile:(NSArray *)paths fieldNames:(NSArray *)fieldNames completionHandler:(void (^)(NSString *result, NSError *error))completionHandler {
    NSString *url = @"http://192.168.0.105:8080/MyApplicationPrj/FileUpload";
    NSString *boundary = [self generateBoundaryString];
    // 请求的Url
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    // 设置ContentType
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:nil paths:paths fieldNames:fieldNames];
    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@\n%@", result,error);
        if (completionHandler) {
            completionHandler(result,error);
        }
    }] resume];
}

+ (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldNames:(NSArray *)fieldNames {
    NSMutableData *httpBody = [NSMutableData data];
    // 文本参数
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 本地文件的NSData
    for (int i = 0; i < [paths count]; i++) {
        NSString *path = paths[i];
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        NSString *fieldName = fieldNames[i];
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}

+ (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    // 文本参数
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 本地文件的NSData
    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}

+ (NSString *)mimeTypeForPath:(NSString *)path {
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    CFRelease(UTI);
    if (mimetype == nil || [mimetype length] <= 0) {
        return [path lastPathComponent];
    }
    return mimetype;
}

+ (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

@end
