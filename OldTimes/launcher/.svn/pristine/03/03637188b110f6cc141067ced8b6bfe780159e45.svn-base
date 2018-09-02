//
//  IMUploadFileSessionManager.h
//  launcher
//
//  Created by Lars Chen on 16/1/26.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <AFHTTPSessionManager.h>

@class IMAttachmentUploadRequest;
@class AttachmentUploadModel;
@class MessageBaseModel;

@protocol IMUploadFileSessionManagerDelegate <NSObject>

- (void)IMUploadFileSessionManagerDelegateCallBack_uploadFailedReason:(NSString *)reason uploadMesageModel:(MessageBaseModel *)uploadBaseModel;

- (void)IMUploadFileSessionManagerDelegateCallBack_finishWithAttachModel:(AttachmentUploadModel *)model uploadMesageModel:(MessageBaseModel *)uploadBaseModel progress:(double)progress;

@end

@interface IMUploadFileSessionManager : AFHTTPSessionManager

@property (nonatomic, weak) id<IMUploadFileSessionManagerDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *uploadImageProgressDictionary;

+ (IMUploadFileSessionManager *)share;

- (void)addRequest:(IMAttachmentUploadRequest *)request;

@end
