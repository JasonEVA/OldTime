//
//  IMUploadFileSessionManager.m
//  launcher
//
//  Created by Lars Chen on 16/1/26.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMUploadFileSessionManager.h"
#import "IMAttachmentUploadRequest.h"
#import "MessageManager.h"
#import "ChatMsgManager.h"
#import "MessageBaseModel.h"
#import "AttachmentUploadModel.h"

@interface IMUploadFileSessionManager ()

@property (nonatomic, strong) NSMutableArray *arrUploadImageRequest;

@property (nonatomic, strong) NSMutableArray *arrUploadAudioRequest;

@property (nonatomic,assign) BOOL isImageRunning;

@property (nonatomic,assign) BOOL isAudioRunning;

@property (nonatomic, readonly) dispatch_queue_t uploadQueue;


@end

@implementation IMUploadFileSessionManager

+ (IMUploadFileSessionManager *)share
{
    static IMUploadFileSessionManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionManager = [[IMUploadFileSessionManager alloc] initWithSessionConfiguration:configuration];
        //设置最大并发数1
        sessionManager.operationQueue.maxConcurrentOperationCount = 1;
        sessionManager.isImageRunning = NO;
        sessionManager.isAudioRunning = NO;
    });

    return sessionManager;
}

#pragma mark - Interface Method

- (void)addRequest:(IMAttachmentUploadRequest *)request
{
    NSMutableArray *arrRequest = [self getArrWithFileType:request.baseModel._type];
    [arrRequest addObject:request];
    
    [self.uploadImageProgressDictionary setObject:@0 forKey:request.baseModel._nativeOriginalUrl];
    
    [self checkAndBeginUploadWithFileType:request.baseModel._type];
}

- (void)checkAndBeginUploadWithFileType:(Msg_type)type
{
    if (type == msg_personal_image)
    {
        if (self.isImageRunning)
        {
            return;
        }
    }
    
    else if (type == msg_personal_voice)
    {
        if (self.isAudioRunning)
        {
            return;
        }
    }
    
    [self nextTaskWithFileType:type];
}

#pragma mark - Private Method

- (NSMutableArray *)getArrWithFileType:(Msg_type)type
{
    if (type == msg_personal_voice)
    {
        return self.arrUploadAudioRequest;
    }
    
    return self.arrUploadImageRequest;
}

- (void)nextTaskWithFileType:(Msg_type)type
{
    NSMutableArray *arrRequest = [self getArrWithFileType:type];
    if (type == msg_personal_image)
    {
        self.isImageRunning = arrRequest.count;
    }
    else if (type == msg_personal_voice)
    {
        self.isAudioRunning = arrRequest.count;
    }
    
    if ([arrRequest count] == 0) {
        return;
    }
    
    dispatch_async(self.uploadQueue, ^{
        IMAttachmentUploadRequest *request = [arrRequest firstObject];

        [request resumeTaskWithCompletionHandler:^{
            [self sendMessageWithFileType:type];
        } progress:^(double progress) {
            [self sendProgressWithType:type progress:progress];
        } failure:^(NSString *reason) {
            [self failReUploadWithReason:reason type:type];
        }];
    });
}

- (void)sendProgressWithType:(Msg_type)type progress:(double)progress {
    NSArray *requestList = [self getArrWithFileType:type];
    if ([requestList count] == 0) {
        return;
    }
    
    IMAttachmentUploadRequest *request = [requestList firstObject];

    dispatch_async(dispatch_get_main_queue(), ^{
        AttachmentUploadModel *model = [request getAttachModel];
        
        [self.uploadImageProgressDictionary setObject:@(progress) forKey:request.baseModel._nativeOriginalUrl];
        
        if ([self.delegate respondsToSelector:@selector(IMUploadFileSessionManagerDelegateCallBack_finishWithAttachModel:uploadMesageModel:progress:)]) {
            [self.delegate IMUploadFileSessionManagerDelegateCallBack_finishWithAttachModel:model uploadMesageModel:request.baseModel progress:progress];
        }
    });
}

- (void)sendMessageWithFileType:(Msg_type)type
{
    NSMutableArray *arrRequest = [self getArrWithFileType:type];
    if ([arrRequest count] == 0) {
        return;
    }
    
    IMAttachmentUploadRequest *request = [arrRequest firstObject];
    [arrRequest removeObjectAtIndex:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AttachmentUploadModel *model = [request getAttachModel];
        if ([self.delegate respondsToSelector:@selector(IMUploadFileSessionManagerDelegateCallBack_finishWithAttachModel:uploadMesageModel:progress:)])
        {
            [self.delegate IMUploadFileSessionManagerDelegateCallBack_finishWithAttachModel:model uploadMesageModel:request.baseModel progress:1];
        }
        
        [self nextTaskWithFileType:type];
     
        // 进度完成 Cell显示之后移除掉
        [self.uploadImageProgressDictionary removeObjectForKey:request.baseModel._nativeOriginalUrl];
        
        NSString *uploadContent = @"";
        if (model.attachmentType == attachment_audio)
        {
            uploadContent = [model getJsonStringForAudioSocket];
        }
        else if (model.attachmentType == attachment_video)
        {
            uploadContent = [model getJsonStringForVideoSocket];
        }
        else
        {
            uploadContent = [model getJsonStringForSocket];
        }
        
        [[ChatMsgManager share] unmoorAttachMessageModel:request.baseModel content:uploadContent];
    });
}

- (void)failReUploadWithReason:(NSString *)reason type:(Msg_type)type
{
    NSMutableArray *arrRequest = [self getArrWithFileType:type];
    IMAttachmentUploadRequest *request = [arrRequest firstObject];
    // 上传失败，重新上传，一张图片2次机会
    if (request.reUploadTimes)
    {
        request.reUploadTimes --;
        // 重新开始发第一个包
        [request resetTaskConfig];
        [self nextTaskWithFileType:type];
        return;
    }
    
    [arrRequest removeObjectAtIndex:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(IMUploadFileSessionManagerDelegateCallBack_uploadFailedReason:uploadMesageModel:)])
        {
            [self.delegate IMUploadFileSessionManagerDelegateCallBack_uploadFailedReason:reason uploadMesageModel:request.baseModel];
        }
        
        [self nextTaskWithFileType:type];
        
        [self.uploadImageProgressDictionary removeObjectForKey:request.baseModel._nativeOriginalUrl];
        
        [[MessageManager share] markUploadingMessageToFaild:request.baseModel];
    });

}

- (NSMutableArray *)arrUploadImageRequest
{
    if (!_arrUploadImageRequest)
    {
        _arrUploadImageRequest = [NSMutableArray new];
    }
    
    return _arrUploadImageRequest;
}

- (NSMutableArray *)arrUploadAudioRequest
{
    if (!_arrUploadAudioRequest)
    {
        _arrUploadAudioRequest = [NSMutableArray new];
    }
    
    return _arrUploadAudioRequest;
}

@synthesize uploadQueue = _uploadQueue;

- (dispatch_queue_t)uploadQueue {
    if (!_uploadQueue) {
        _uploadQueue = dispatch_queue_create("IM.uploadImage", DISPATCH_QUEUE_SERIAL);
    }
    
    return _uploadQueue;
}

- (NSMutableDictionary *)uploadImageProgressDictionary
{
    if (!_uploadImageProgressDictionary)
    {
        _uploadImageProgressDictionary = [NSMutableDictionary new];
    }
    
    return _uploadImageProgressDictionary;
}

@end
