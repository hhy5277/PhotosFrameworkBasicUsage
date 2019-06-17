//
//  NSString+Base64.h
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/10.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Base64)
- (NSString *)base64EncodeString;

- (NSString *)base64DecodeString;
@end

NS_ASSUME_NONNULL_END
