//
//  PhotosViewController.m
//  AVPlayerDemo
//
//  Created by 瓜豆2018 on 2019/5/27.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCollectionViewCell.h"
#import <AVKit/AVKit.h>
#import "PhotoBrowserViewController.h"

#define kCellWH ([UIScreen mainScreen].bounds.size.width - 2 * 3 - 20) / 4.0
#define kCellScale [UIScreen mainScreen].scale

@interface PhotosViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation PhotosViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)setResults:(PHFetchResult<PHAsset *> *)results {
    _results = results;
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.results count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PHAsset *asset = self.results[indexPath.row];
    
    // 获取
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(kCellWH * kCellScale, kCellWH * kCellScale) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.image = result;
    }];
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        [[PHCachingImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            Float64 totalSeconds = CMTimeGetSeconds(asset.duration);
            int minutes = (int)(totalSeconds / 60);
            int seconds = (int)(totalSeconds - minutes * 60);
            cell.durationTime = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        }];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PHAsset *asset = [self.results objectAtIndex:indexPath.item];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        [[PHCachingImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            AVPlayerViewController *playerVc = [[AVPlayerViewController alloc] init];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
            playerVc.player = [AVPlayer playerWithPlayerItem:playerItem];
            playerVc.videoGravity = AVLayerVideoGravityResizeAspectFill;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:playerVc animated:YES completion:nil];
            });
        }];
    } else if (asset.mediaType == PHAssetMediaTypeImage) {
        PhotoBrowserViewController *photoBrowserVc = [[PhotoBrowserViewController alloc] init];
        photoBrowserVc.selectedIndex = indexPath.item;
        photoBrowserVc.results = self.results;
        [self presentViewController:photoBrowserVc animated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kCellWH, kCellWH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 10, 2, 10);
}

@end
