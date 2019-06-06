//
//  PhotoCollectionViewCell.m
//  AVPlayerDemo
//
//  Created by 瓜豆2018 on 2019/5/27.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell ()

@property (nonatomic, weak) UILabel *durationLab;
@end

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        CGFloat durationLabH = 20;
        CGFloat durationLabX = 5;
        UILabel *durationLab = [[UILabel alloc] initWithFrame:CGRectMake(durationLabX, self.contentView.bounds.size.height - durationLabH, self.contentView.bounds.size.width - durationLabX * 2, durationLabH)];
        durationLab.font = [UIFont systemFontOfSize:12];
        durationLab.textColor = [UIColor whiteColor];
        durationLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:durationLab];
        self.durationLab = durationLab;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
    self.durationLab.hidden = YES;
}

- (void)setDurationTime:(NSString *)durationTime {
    _durationTime = durationTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.durationLab.text = durationTime;
        self.durationLab.hidden = NO;
    });
}

@end
