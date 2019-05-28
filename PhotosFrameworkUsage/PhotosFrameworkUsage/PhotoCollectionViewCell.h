//
//  PhotoCollectionViewCell.h
//  AVPlayerDemo
//
//  Created by 瓜豆2018 on 2019/5/27.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *durationTime;
@property (nonatomic, weak) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
