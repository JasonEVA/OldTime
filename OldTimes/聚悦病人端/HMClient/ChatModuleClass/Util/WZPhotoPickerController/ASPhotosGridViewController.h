//
//  ASPhotosGridViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//  缩略图界面

#import <UIKit/UIKit.h>

@class  PHAssetCollection,WZPhotoPickerController;

@interface ASPhotosGridViewController : UICollectionViewController

@property (nonatomic, strong) WZPhotoPickerController *pickerController;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)collection;
@end
