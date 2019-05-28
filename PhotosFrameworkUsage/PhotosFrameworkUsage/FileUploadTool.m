//
//  FileUploadTool.m
//  YYEEmployer
//
//  Created by 瓜豆2018 on 2019/5/17.
//  Copyright © 2019年 瓜豆2018. All rights reserved.
//

#import "FileUploadTool.h"

@implementation FileUploadTool

+ (void)testUpload:(NSArray *)imgNameArray img:(NSArray *)imgArray params:(NSDictionary *)params success:(void (^)(void))success {
//    NSString *boundary = [self generateBoundaryString];
//    // 请求的url
//    NSURL *url = [NSURL URLWithString:Revise_Attendance_URL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    // 设置Content-Type
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
//    [request setValue:NETWORK_HEADER_VERSION(4) forHTTPHeaderField:@"Accept"];
//    NSString *tokenStr = [NSString stringWithFormat:@"bearer%@", [UserData currentUser].token];
//    if ([[ToolBox dataOperation] isHasValue:[UserData currentUser].token]) {
//        [request setValue:tokenStr forHTTPHeaderField:@"Authorization"];
//    }else{
//        [request setValue:nil forHTTPHeaderField:@"Authorization"];
//    }
//    
//    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:[imgArray count]];
//    for (UIImage *image in imgArray) {
//        [datas addObject:UIImageJPEGRepresentation(image, 0.6)];
//    }
//    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params fileDatas:datas fileNames:imgNameArray];
//    NSURLSessionTask *task = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"error = %@", error);
//            return;
//        }
//        
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"FlyElephany-返回结果---result = %@", result);
//        if (success) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                success();
//            });
//            
//        }
//    }];
//    [task resume];
}

+ (NSData *)createBodyWithBoundary:(NSString *)boundary parameters:(NSDictionary *)parameters fileDatas:(NSArray *)fileDatas fileNames:(NSArray *)fileNames {
    NSMutableData *httpBody = [NSMutableData data];
    // 文本参数
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull parameterKey, id  _Nonnull parameterValue, BOOL * _Nonnull stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition; form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 文件的NSData
    NSString *mimeType = @"image/jpeg";
    for (int i = 0; i < [fileDatas count]; i++) {
        NSData *fileData = [fileDatas objectAtIndex:i];
        NSString *name = [fileNames objectAtIndex:i];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition; form-data; name=\"%@\"; filename=\"image\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:fileData];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

+ (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary--%@", [[NSUUID UUID] UUIDString]];
}

@end
