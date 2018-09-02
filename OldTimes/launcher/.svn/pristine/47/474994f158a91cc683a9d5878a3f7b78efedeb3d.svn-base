//
//  IMAttachmentUploadRequest.h
//  launcher
//
//  Created by Lars Chen on 16/1/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMBaseRequest.h"

@class AttachmentUploadModel;
@class MessageBaseModel;

typedef void(^IMUploadTaskProgressBlock)(double);
/// 上传成功回调
typedef void(^IMUploadTaskCompletedBlock)();
/// 上传失败回调
typedef void(^IMUploadTaskFailedBlock)(NSString *reason);

@interface IMAttachmentUploadRequest : IMBaseRequest

@property (nonatomic, strong) MessageBaseModel *baseModel;

/// 发送失败重发次数 暂定1次
@property (nonatomic) NSInteger reUploadTimes;

- (void)uploadWithAttach:(AttachmentUploadModel *)model;

// 开启任务
- (void)resumeTaskWithCompletionHandler:(IMUploadTaskCompletedBlock)completedBlock
                               progress:(IMUploadTaskProgressBlock)progressBlock
                                failure:(IMUploadTaskFailedBlock)failedBlock;

// 重启配置上传参数,第一次发送失败重新发送
- (void)resetTaskConfig;

- (AttachmentUploadModel *)getAttachModel;

@end
