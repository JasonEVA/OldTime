//
//  AttachmentDownloadDAL.h
//  launcher
//
//  Created by Lars Chen on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  IM附件等下载

#import <Foundation/Foundation.h>
#import "SGdownloader.h"
#import "MsgBaseDAL.h"
#import "MessageBaseModel.h"

@protocol AttachmentDownloadDALDelegate <NSObject>

// 下载成功的委托
- (void)AttachmentDownloadDALDelegateCallBack_finishWithDownloadMessageModel:(MessageBaseModel *)baseModel fileData:(NSData *)imgData;

// 处理下载内容进度的委托回调
- (void)AttachmentDownloadDALDelegateCallBack_managerDataWithProgress:(float)progress;

// 处理下载的附件失败的委托回调
- (void)AttachmentDownloadDALDelegateCallBack_failManagerReceiveAttachmentMessageWithBaseModel:(MessageBaseModel *)baseModel Message:(NSString *)message;

@end

@interface AttachmentDownloadDAL : MsgBaseDAL <SGdownloaderDelegate>
{
    SGdownloader *_downloader;      // 网络请求管理器
    
    MessageBaseModel *_baseModel;
    NSString *_strInterface;        // 接口名
}

@property (nonatomic,weak) id <AttachmentDownloadDALDelegate> delegate;


/**
 *  下载附件
 */
- (void)startDownloadFileWithBaseModel:(MessageBaseModel *)model;

@end
