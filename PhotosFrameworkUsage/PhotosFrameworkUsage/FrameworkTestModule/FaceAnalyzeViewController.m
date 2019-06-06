//
//  FaceAnalyzeViewController.m
//  PhotosFrameworkUsage
//
//  Created by 瓜豆2018 on 2019/6/6.
//  Copyright © 2019年 hongyegroup. All rights reserved.
//

#import "FaceAnalyzeViewController.h"
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

@interface FaceAnalyzeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
- (IBAction)faceDetectionOnClick;

@end

@implementation FaceAnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    [self imagePickerControllerDidCancel:picker];
    @try {
        NSLog(@"%@", info);
        NSURL *fileUrl = info[UIImagePickerControllerImageURL];
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
        CFDictionaryRef imageInfo = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        NSDictionary *dict = (__bridge_transfer NSDictionary *)imageInfo;
        NSLog(@"%@", dict);
        
        //    [self faceDetection:originalImage];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}

- (void)faceDetection:(UIImage *)originalImage {
    CIImage *coreImage = [[CIImage alloc] initWithImage:originalImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:coreImage];
    if ([features count] > 0) {
        CIFaceFeature *faceFeature = [features lastObject];
        
        // 是否面带微笑
        NSLog(@"%d", [faceFeature hasSmile]);
        
        
        CIImage *faceImage = [coreImage imageByCroppingToRect:[[features lastObject] bounds]];
        UIImage *face = [UIImage imageWithCGImage:[context createCGImage:faceImage fromRect:faceImage.extent]];
        
        self.faceImageView.image = face;
        self.faceImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [BaseViewController hudWithTitle:[NSString stringWithFormat:@"%ld Face(s) Found", [features count]]];
    } else {
        [BaseViewController hudWithTitle:@"No Faces Found"];
    }
}

- (IBAction)faceDetectionOnClick {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    void (^handlerBlock)(UIAlertAction  * _Nonnull action) = ^(UIAlertAction  * _Nonnull action){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if ([action.title isEqualToString:@"相机"]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else if ([action.title isEqualToString:@"相册"]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self presentViewController:picker animated:YES completion:nil];
    };
    [alertVc addAction: [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:handlerBlock]];
    [alertVc addAction: [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:handlerBlock]];
    [alertVc addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
