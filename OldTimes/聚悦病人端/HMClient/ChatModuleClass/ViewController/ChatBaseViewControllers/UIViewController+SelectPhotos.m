//
//  UIViewController+SelectPhotos.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UIViewController+SelectPhotos.h"

//#import "WZPhotoPickerController.h"
#import <Photos/Photos.h>
#import "TZImagePickerController.h"

@interface UIViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end

@implementation UIViewController (SelectPhotos)

- (SelectPhotoCompletionHandler)completionHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCompletionHandler:(SelectPhotoCompletionHandler)completionHandler {
    objc_setAssociatedObject(self, @selector(completionHandler), completionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Interface Method

- (void)ats_selectPhotosFromCamera:(SelectPhotoCompletionHandler)completionHandler {
    [self p_selectPhotosFromCamera:YES systemAlbum:YES completionHandler:completionHandler];
}

- (void)ats_selectPhotosFromCustomAlbum:(SelectPhotoCompletionHandler)completionHandler {
    [self p_selectPhotosFromCamera:NO systemAlbum:NO completionHandler:completionHandler];
}

#pragma mark - Private Method

- (void)p_selectPhotosFromCamera:(BOOL)fromCamera systemAlbum:(BOOL)systemAlbum completionHandler:(SelectPhotoCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    if (systemAlbum) {
        // 系统相册，拍照
        [self pickImageisFromCamera:fromCamera];
    }
    else {
        // 自定义相册，拍照
        if (fromCamera) {
            // 自定义拍照
            [self pickImageisFromCamera:YES];
        }
        else {
            // 自定义相册
            [self p_selectImagesFromCustomAlbum];
        }
    }
}

- (void)pickImageisFromCamera:(BOOL)isFromCamera
{
    NSInteger sourceType;
    // 拍照
    if (isFromCamera)
    {
        // 判断是否有摄像头
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            return;
        }
    }
    // 相册
    else
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //判断用户的权限
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        // NSLog(@"允许状态");
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if (authStatus == AVAuthorizationStatusDenied)
    {
        //NSLog(@"不允许状态，可以弹出一个alertview提示用户在隐私设置中开启权限");
        
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的相机->设置->隐私->相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        // NSLog(@"系统还未知是否访问，第一次开启相机时");
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }

}

- (void)p_selectImagesFromCustomAlbum {
//    WZPhotoPickerController *pickerController = [[WZPhotoPickerController alloc] init];
    TZImagePickerController *pickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    pickerController.allowTakePicture = NO;
    pickerController.allowPickingVideo = NO;
    pickerController.oKButtonTitleColorNormal = [UIColor mainThemeColor];
    pickerController.oKButtonTitleColorDisabled = [UIColor lightGrayColor];

    __weak typeof(self) weakSelf = self;
    [pickerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *arrayImages, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (arrayImages && weakSelf.completionHandler) {
            weakSelf.completionHandler(arrayImages);
        }
    }];

//    [pickerController addPhotoPickerHandlerNoti:^(NSArray<UIImage *> *arrayImages) {
//        if (arrayImages && weakSelf.completionHandler) {
//            weakSelf.completionHandler(arrayImages);
//        }
//    }];
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate

// 选择后返回
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != nil)
    {
        if (self.completionHandler) {
            self.completionHandler(@[image]);
        }
    }
    
    if (picker) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 取消返回
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
