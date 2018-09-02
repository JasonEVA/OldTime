//
//  AttachmentUploadRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/16.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  附件上传兼头像上传

#import "BaseRequest.h"
#import "AttachmentUtil.h"

@class ApplicationAttachmentModel;

@interface AttachmentUploadResponse : BaseResponse

@property (nonatomic, copy) NSString *attachmentShowId;
@property (nonatomic, strong) ApplicationAttachmentModel *appAttachmentModel;

/**
 *  批量上传时用于区分是哪个附件
 */
@property (nonatomic, readonly) NSInteger identifier;

@end

@interface AttachmentUploadRequest : BaseRequest

/**
 *  上传头像所用
 *
 *  @param data 头像二进制
 */
- (void)uploadImageData:(NSData *)data;
/**
 *   上传处理后的文件
 *   上传数据存放在Params中——————
 *   此时Params不作为字典使用
 *
 *   0--3字节：INT类型，表示json用UTF-8编码转成字节数组的长度
 *   4--n字节：Message类型，json UTF-8编码
 *   n+1—结束：byte[]
 */
- (void)uploadImageData:(NSData *)data appShowIdType:(AttachmentAppShowIdType)appShowIdType;

- (void)uploadImageData:(NSData *)data appShowId:(NSString *)showId;

@end
