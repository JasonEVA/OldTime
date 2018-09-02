//
//  AudioDownloadDAL.m
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/22.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "AudioDownloadDAL.h"
#import <MJExtension/MJExtension.h>
#import "MsgUserInfoMgr.h"

#define DICT_fileUrl        @"fileUrl"
#define DICT_AudioLength    @"audioLength"

#define AUDIO_TIMEOUT       10

@implementation AudioDownloadDAL

/**
 *  增加下载任务 （该方法会自行去重）
 *
 *  @param model MessageBaseModel
 *  @param taskIndex task唯一标记
 */
- (void)startTaskWithModel:(MessageBaseModel *)model taskIndex:(NSInteger)taskIndex
{
    msgBaseModel = model;
    NSString *strfullPath = [[[MsgUserInfoMgr share] getHttpIp] stringByAppendingString:model.attachModel.fileUrl];
    NSURL *url = [NSURL URLWithString:strfullPath];
    SGdownloader *downloader = [[SGdownloader alloc] initWithURLForGet:url timeout:AUDIO_TIMEOUT URL_ID:taskIndex];
    [downloader startWithDelegate:self];
}

#pragma mark - SGDownload Delegate

- (void)SGDownloadFinished:(NSData *)fileData withID:(NSInteger)ID
{    
    if ([self.delegate respondsToSelector:@selector(AudioDownloadDALDelegateCallBack_finishDownloadWith:armSource:taskIndex:isSuccess:)])
    {
        [self.delegate AudioDownloadDALDelegateCallBack_finishDownloadWith:msgBaseModel armSource:fileData taskIndex:ID isSuccess:YES];
    }
}

- (void)SGDownloadFail:(NSError *)error withID:(NSInteger)ID
{
    if ([self.delegate respondsToSelector:@selector(AudioDownloadDALDelegateCallBack_finishDownloadWith:armSource:taskIndex:isSuccess:)])
    {
        [self.delegate AudioDownloadDALDelegateCallBack_finishDownloadWith:msgBaseModel armSource:nil taskIndex:ID isSuccess:NO];
    }
}

@end

