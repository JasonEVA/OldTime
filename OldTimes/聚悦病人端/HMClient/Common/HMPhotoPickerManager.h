//
//  HMPhotoPickerManager.h
//  HMClient
//
//  Created by lkl on 2017/8/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//  上传图片

#import <Foundation/Foundation.h>

typedef void(^CallBackBlock)(UIImage *img);  // 回调

@interface HMPhotoPickerManager : NSObject

+ (instancetype)shareInstance; // 单例

- (void)addTarget:(UIViewController *)viewController showImageViewSelcteWithResultBlock:(CallBackBlock)selectImageBlock;

@end
