//
//  HMPhotoPickerManager.m
//  HMClient
//
//  Created by lkl on 2017/8/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMPhotoPickerManager.h"
#import <Photos/Photos.h>
#import "TZImagePickerController.h"

static HMPhotoPickerManager *pickerManager;

@interface HMPhotoPickerManager ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imgPickController;
@property (nonatomic, copy) CallBackBlock selectImageBlock;

@end

@implementation HMPhotoPickerManager

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pickerManager = [[HMPhotoPickerManager alloc] init];
    });
    return pickerManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_imgPickController) {
            _imgPickController = [[UIImagePickerController alloc] init];
            _imgPickController.allowsEditing = YES;
            _imgPickController.delegate = self;
        }
    }
    return self;
}

- (void)addTarget:(UIViewController *)viewController showImageViewSelcteWithResultBlock:(CallBackBlock)selectImageBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet] ;
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //相机拍摄
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self creatWithSourceType:UIImagePickerControllerSourceTypeCamera target:viewController block:selectImageBlock];
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImagesFromCustomAlbumTarget:viewController block:selectImageBlock];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

//相机拍摄
- (void)creatWithSourceType:(UIImagePickerControllerSourceType)sourceType target:(UIViewController *)viewController block:selectImageBlock{
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //判断用户的权限
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        // NSLog(@"允许状态");
        // 跳转到相机或相册页面
        _imgPickController.sourceType = sourceType;
        _selectImageBlock = selectImageBlock;
        [viewController presentViewController:_imgPickController animated:YES completion:nil];
    }
    else if (authStatus == AVAuthorizationStatusDenied)
    {
        [viewController showAlertMessage:@"请您设置允许APP访问您的相机->设置->隐私->相机" title:@"温馨提示"];
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        _imgPickController.sourceType = sourceType;
        _selectImageBlock = selectImageBlock;
        [viewController presentViewController:_imgPickController animated:YES completion:nil];
    }

}

//图库
- (void)selectImagesFromCustomAlbumTarget:(UIViewController *)viewController block:selectImageBlock{

    TZImagePickerController *pickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    pickerController.allowTakePicture = NO;
    pickerController.allowPickingVideo = NO;
    pickerController.oKButtonTitleColorNormal = [UIColor mainThemeColor];
    pickerController.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    _selectImageBlock = selectImageBlock;
    __weak typeof(self) weakSelf = self;
    [pickerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *arrayImages, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (arrayImages && weakSelf.selectImageBlock) {
            weakSelf.selectImageBlock([arrayImages lastObject]);
        }
    }];
    [viewController presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark ---- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *theImage = nil;
    // 判断，图片是否允许修改。默认是可以的
    if ([picker allowsEditing]){
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    if (_selectImageBlock) {
        _selectImageBlock(theImage);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//取消返回
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

