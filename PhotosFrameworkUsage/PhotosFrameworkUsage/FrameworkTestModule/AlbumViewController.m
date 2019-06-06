//
//  AlbumViewController.m
//  AVPlayerDemo
//
//  Created by 瓜豆2018 on 2019/5/27.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "AlbumViewController.h"
#import <Photos/Photos.h>
#import "PhotosViewController.h"

#define kAlbumCellId @"AlbumCellId"

typedef NS_ENUM(NSInteger, PhotoAlbumType) {
    PhotoAlbumTypeAllPhotos = 0,
    PhotoAlbumTypeSmartAlbum,
    PhotoAlbumTypeAlbum
};

@interface AlbumViewController ()
{
    PHFetchResult<PHAssetCollection *> *_smartAlbumResult;
    PHFetchResult<PHAssetCollection *> *_albumResult;
    PHFetchResult<PHAsset *> *_assets;
    NSArray *_headTitles;
}

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (status == PHAuthorizationStatusAuthorized) {
            _headTitles = @[@"", @"Smart Album", @"Album"];
            
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            // 根据创建时间升序排序
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            // 获取所有的图片
            _assets = [PHAsset fetchAssetsWithOptions:options];
            // 获取智能相册
            _smartAlbumResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            // 获取相册
            _albumResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"not have authorization." message:@"not have authorization." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_headTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case PhotoAlbumTypeAllPhotos:
            return 1;
            break;
        case PhotoAlbumTypeSmartAlbum:
            return [_smartAlbumResult count];
            break;
        case PhotoAlbumTypeAlbum:
            return [_albumResult count];
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _headTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlbumCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kAlbumCellId];
    }
    NSInteger count = 0;
    switch (indexPath.section) {
        case PhotoAlbumTypeAllPhotos: {
            count = [_assets count];
            cell.textLabel.text = @"All Photos";
        }
            break;
        case PhotoAlbumTypeSmartAlbum: {
            count = [[PHAsset fetchAssetsInAssetCollection:[_smartAlbumResult objectAtIndex:indexPath.row] options:nil] count];
            cell.textLabel.text = [[_smartAlbumResult objectAtIndex:indexPath.row] localizedTitle];
        }
            break;
        case PhotoAlbumTypeAlbum: {
            count = [[PHAsset fetchAssetsInAssetCollection:[_albumResult objectAtIndex:indexPath.row] options:nil] count];
            cell.textLabel.text = [[_albumResult objectAtIndex:indexPath.row] localizedTitle];
        }
            break;
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotosViewController *photosVc = [[PhotosViewController alloc] init];
    switch (indexPath.section) {
        case 0:
            photosVc.results = _assets;
            break;
        case 1:
            // 获取某个相册下的所有照片
            photosVc.results = [PHAsset fetchAssetsInAssetCollection:[_smartAlbumResult objectAtIndex:indexPath.row] options:nil];
            break;
        case 2:
            photosVc.results = [PHAsset fetchAssetsInAssetCollection:[_albumResult objectAtIndex:indexPath.row] options:nil];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:photosVc animated:YES];
}

@end
