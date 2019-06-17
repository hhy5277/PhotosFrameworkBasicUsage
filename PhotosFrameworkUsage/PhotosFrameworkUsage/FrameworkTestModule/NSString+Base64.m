//
//  NSString+Base64.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/10.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)

- (NSString *)base64EncodeString {
    //1、先转换成二进制数据
    NSData *data =[self dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodeString {
    //注意：该字符串是base64编码后的字符串
    //1、转换为二进制数据（完成了解码的过程）
    NSData *data=[[NSData alloc] initWithBase64EncodedString:self options:0];
    //2、把二进制数据转换成字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
@end
