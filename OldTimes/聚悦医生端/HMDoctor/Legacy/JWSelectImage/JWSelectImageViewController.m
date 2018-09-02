//
//  JWSelectImageViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "JWSelectImageViewController.h"
#import "WZPhotoPickerController.h"
#import <MWPhotoBrowser-ADS/MWPhotoBrowser.h>
#import "UIViewController+SelectPhotos.h"

@interface JWSelectImageViewController ()<HMSelectImageEditViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;

@end

@implementation JWSelectImageViewController
- (instancetype)initWithMaxSelectedCount:(NSInteger)maxCount {
    if (self = [super init]) {
        self.selectImageView = [[HMSelectImageEditView alloc]initWithMaxSelectedCount:maxCount];
        [self.selectImageView setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/** 点击查看照片 */
- (void)selectShowImageAtIndex:(NSUInteger)selectedIndex {
    self.photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.photoBrowser.displayActionButton = YES;
    self.photoBrowser.alwaysShowControls = NO;
    self.photoBrowser.zoomPhotosToFill = YES;
    self.photoBrowser.enableGrid = NO;
    self.photoBrowser.enableSwipeToDismiss = YES;
    [self.photoBrowser showNextPhotoAnimated:YES];
    [self.photoBrowser showPreviousPhotoAnimated:YES];
    [self.navigationController pushViewController:self.photoBrowser animated:YES];
    [self.photoBrowser setCurrentPhotoIndex:selectedIndex];
}


- (void)HMSelectImageEditViewDelegateCallBack_addImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片", @"拍照", nil];
    [actionSheet showInView:self.view];
}

- (void)HMSelectImageEditViewDelegateCallBack_showBigImageWithIndex:(NSIndexPath *)indexPath {
    [self selectShowImageAtIndex:indexPath.row];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 附件上传照片
    if (buttonIndex == 1) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self at_postError:@"无摄像头或者不可用"];
            return;
        }
        __weak typeof(self) weakSelf = self;
        [self ats_selectPhotosFromCamera:^(NSArray<UIImage *> *photos) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.selectImageView updateDataListWithArray:photos];

        }];
    }
    
    else if (buttonIndex == 0) {
        NSInteger count = self.selectImageView.maxCount - self.selectImageView.selectedImageArr.count;
        [self setMaxImageSelectedCount:count];
        __weak typeof(self) weakSelf = self;
        [self ats_selectPhotosFromCustomAlbum:^(NSArray<UIImage *> *photos) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
          [strongSelf.selectImageView updateDataListWithArray:photos];
        }];
    }
    
}

#pragma mark - MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.selectImageView.selectedImageArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.selectImageView.selectedImageArr.count) {
        return [MWPhoto photoWithImage:self.selectImageView.selectedImageArr[index]];
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
