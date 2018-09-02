//
//  AudioDownloadDAL.h
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/22.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  音频资源下载管理

#import <Foundation/Foundation.h>
#import "MessageBaseModel.h"
#import "SGdownloader.h"

@protocol AudioDownloadDALDelegate <NSObject>

@required
- (void)AudioDownloadDALDelegateCallBack_finishDownloadWith:(MessageBaseModel *)baseModel armSource:(NSData *)armSource taskIndex:(NSInteger)taskIndex isSuccess:(BOOL)isSuccess;


@end

@interface AudioDownloadDAL : NSObject <SGdownloaderDelegate>
{
    MessageBaseModel *msgBaseModel;
}

@property (nonatomic,weak) id <AudioDownloadDALDelegate> delegate;

/**
 *  增加下载任务 （该方法会自行去重）
 *
 *  @param model MessageBaseModel
 */
- (void)startTaskWithModel:(MessageBaseModel *)model taskIndex:(NSInteger)taskIndex;

@end
