//
//  HMStepUploadManager.h
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//  步数上传manager

#import <Foundation/Foundation.h>


typedef void(^stepUploadBlock)(BOOL success);

@interface HMStepUploadManager : NSObject

+ (id)shareInstance;
- (void)upLoadCurrentStep:(stepUploadBlock)block;
- (void)JWCanUploadStepData;

- (void)startUploadStepRequest:(NSInteger)steps;

@end
