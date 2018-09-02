//
//  AttachmentDownloadDAL.m
//  launcher
//
//  Created by Lars Chen on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "AttachmentDownloadDAL.h"
#import <MJExtension/MJExtension.h>
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"

#define DURATION_TIMEOUT 10                           // 网络请求超时时长

@implementation AttachmentDownloadDAL

// 下载附件
- (void)startDownloadFileWithBaseModel:(MessageBaseModel *)model
{
    _baseModel = model;
    
    NSString *strUrl = [[[MsgUserInfoMgr share] getHttpIp] stringByAppendingPathComponent:model.attachModel.fileUrl];
    
    // 开启文件下载
    NSURL *url = [NSURL URLWithString:strUrl];
    _downloader = [[SGdownloader alloc] initWithURLForGet:url timeout:DURATION_TIMEOUT URL_ID:1];
    [_downloader startWithDelegate:self];
}

#pragma mark - SGDownload Delegate
// 文件下载成功
- (void)SGDownloadFinished:(NSData *)fileData withID:(NSInteger)ID
{
    if ([self.delegate respondsToSelector:@selector(AttachmentDownloadDALDelegateCallBack_finishWithDownloadMessageModel: fileData:)])
    {
        [self.delegate AttachmentDownloadDALDelegateCallBack_finishWithDownloadMessageModel:_baseModel fileData:fileData];
    }
}


- (void)SGDownloadProgress:(float)progress Percentage:(float)percentage
{
    if ([self.delegate respondsToSelector:@selector(AttachmentDownloadDALDelegateCallBack_managerDataWithProgress:)])
    {
        [self.delegate AttachmentDownloadDALDelegateCallBack_managerDataWithProgress:progress];
    }
}

- (void)SGDownloadFail:(NSError *)error
{
    // 发送失败委托
    if ([self.delegate respondsToSelector:@selector(AttachmentDownloadDALDelegateCallBack_failManagerReceiveAttachmentMessageWithBaseModel:Message:)])
    {
        [self.delegate AttachmentDownloadDALDelegateCallBack_failManagerReceiveAttachmentMessageWithBaseModel:_baseModel Message:self._message];
    }
}

@end
