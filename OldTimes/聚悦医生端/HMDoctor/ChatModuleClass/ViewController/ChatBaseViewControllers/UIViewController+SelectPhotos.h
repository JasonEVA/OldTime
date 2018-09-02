//
//  UIViewController+SelectPhotos.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//  选择图片

#import <UIKit/UIKit.h>

typedef void(^SelectPhotoCompletionHandler)(NSArray<UIImage *> *photos);

@interface UIViewController (SelectPhotos)

@property (nonatomic, copy, readonly)  SelectPhotoCompletionHandler  completionHandler; // <##>
@property (nonatomic) NSInteger maxImageSelectedCount;

// 拍照
- (void)ats_selectPhotosFromCamera:(SelectPhotoCompletionHandler)completionHandler;

// 从自定义相册选择
- (void)ats_selectPhotosFromCustomAlbum:(SelectPhotoCompletionHandler)completionHandler;

@end
