//
//  PhotosViewController.h
//  AVPlayerDemo
//
//  Created by 瓜豆2018 on 2019/5/27.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotosViewController : UIViewController
@property (nonatomic, strong) PHFetchResult<PHAsset *> *results;
@end

NS_ASSUME_NONNULL_END
