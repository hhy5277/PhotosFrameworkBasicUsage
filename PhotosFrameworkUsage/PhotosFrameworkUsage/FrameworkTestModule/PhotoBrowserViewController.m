//
//  PhotoBrowserViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/5/28.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import <AVKit/AVKit.h>

#define reuseIdentifier @"cellId"

@interface PhotoBrowserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collectionView.contentOffset = CGPointMake(self.selectedIndex * self.collectionView.bounds.size.width, 0);
    });
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.results count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PHAsset *asset = [self.results objectAtIndex:indexPath.item];
//    if (asset.mediaType == PHAssetMediaTypeVideo) {
//
//
//    } else if (asset.mediaType == PHAssetMediaTypeImage) {
        [[cell.contentView viewWithTag:101] removeFromSuperview];
        UIImageView *imv = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imv.tag = 101;
        [cell.contentView addSubview:imv];
        [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            imv.image = [UIImage imageWithData:imageData];
        }];
//    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size;
}

@end
