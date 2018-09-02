//
//  WZPhotoPickerController.h
//  WZPhotoPickerController
//
//  Created by williamzhang on 15/10/23.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZPhotoPickerController;

typedef void(^ASPhotoPickerCompletionHandler)(NSArray<UIImage *> *arrayImages);

@interface WZPhotoPickerController : UIViewController

/// 默认YES
@property (nonatomic, assign) BOOL allowMutipleSelection;
/// 默认9张
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

@property (nonatomic, copy)  ASPhotoPickerCompletionHandler  photoPickerHandler; // <##>

- (void)addPhotoPickerHandlerNoti:(ASPhotoPickerCompletionHandler)handler;

@end
