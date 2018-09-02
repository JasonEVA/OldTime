//
//  AudioDownloadManager.m
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/22.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "AudioDownloadManager.h"
#import "AudioDownloadDAL.h"

@interface AudioDownloadManager() <AudioDownloadDALDelegate>
{
    // 正在下载的音频资源，key：content(JSON),value:currIndex
    NSMutableDictionary *dictDownloading;
    NSInteger currIndex;            // 向量标记
}

@end
@implementation AudioDownloadManager

- (id)init
{
    if (self = [super init])
    {
        dictDownloading = [NSMutableDictionary dictionary];
        currIndex = 1;
    }
    return self;
}

/**
 *  增加下载任务 （该方法会自行去重）
 *
 *  @param model MessageBaseModel
 */
- (void)addTaskWithModel:(MessageBaseModel *)model
{
    if (![self isDownloadingWithModel:model])
    {
        // 向量持续叠加，永不重复
        currIndex ++;
        [dictDownloading setObject:model._content forKey:[NSNumber numberWithInteger:currIndex]];
        
        AudioDownloadDAL *downloader = [[AudioDownloadDAL alloc] init];
        [downloader setDelegate:self];
        [downloader startTaskWithModel:model taskIndex:currIndex];
    }
}

#pragma mark - Private Method

// 判断是否正在下载
- (BOOL)isDownloadingWithModel:(MessageBaseModel *)model
{
    NSArray *allKeys = [dictDownloading allKeys];
    for (NSNumber *key in allKeys)
    {
        id obj = [dictDownloading objectForKey:key];
        if (obj && [obj isKindOfClass:[NSString class]])
        {
            NSString *value = (NSString *)obj;
            if ([value isEqualToString:model._content])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark - AudioDownloadDAL Delegate

- (void)AudioDownloadDALDelegateCallBack_finishDownloadWith:(MessageBaseModel *)baseModel armSource:(NSData *)armSource taskIndex:(NSInteger)taskIndex isSuccess:(BOOL)isSuccess
{
    // 去除正在下载
    [dictDownloading removeObjectForKey:[NSNumber numberWithInteger:taskIndex]];
    
    if ([self.delegate respondsToSelector:@selector(AudioDownloadManagerDelegateCallBack_finishDownloadWith:armSource:isSuccess:)])
    {
        [self.delegate AudioDownloadManagerDelegateCallBack_finishDownloadWith:baseModel armSource:armSource isSuccess:isSuccess];
    }
}

@end
