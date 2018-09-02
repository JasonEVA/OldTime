//
//  AudioDownloadManager.h
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/22.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  音频下载管理单例

#import <Foundation/Foundation.h>
#import "MessageBaseModel.h"

@protocol AudioDownloadManagerDelegate <NSObject>

@required
/**
 *  音频下载完成的委托回调
 *
 *  @param baseModel 消息model
 *  @param armSource arm格式数据
 *  @param isSuccess 是否成功
 */
- (void)AudioDownloadManagerDelegateCallBack_finishDownloadWith:(MessageBaseModel *)baseModel armSource:(NSData *)armSource  isSuccess:(BOOL)isSuccess;

@end

@interface AudioDownloadManager : NSObject
// 委托回调
@property (nonatomic,weak) id <AudioDownloadManagerDelegate> delegate;

/**
 *  增加下载任务 （该方法会自行去重）
 *
 *  @param model MessageBaseModel
 */
- (void)addTaskWithModel:(MessageBaseModel *)model;

@end
