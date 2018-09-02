//
//  AttachmentUploadModel.m
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/18.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "AttachmentUploadModel.h"
#import <MJExtension/MJExtension.h>
#import <AVFoundation/AVFoundation.h>

@implementation AttachmentUploadModel

- (id)initWithFile:(NSData *)data fileName:(NSString *)fileName type:(AttachmentType)type
{
    if (self = [super init])
    {
        // 考虑到另一个线程持有data写入沙盒，防止资源死锁，采用深拷贝
        self.dataAll = [data mutableCopy];
        self.fileName = fileName;
        self.srcOffset = 0;
        self.fileUrl = @"";
        self.fileStatus = 0;
        self.attachmentType = type;
    }
    return self;
}

/**
 *  应用层传入的音频数据初始化，准备上传附件
 *
 *  @param amrPath amr音频文件的沙盒路径
 *
 *  @return AttachmentUploadModel
 */
- (id)initWithPath:(NSString *)path type:(AttachmentType)type
{
    if (self = [super init])
    {
        self.dataAll = [NSData dataWithContentsOfFile:path];
        self.fileName = path.lastPathComponent;
        self.srcOffset = 0;
        self.fileUrl = @"";
        self.fileStatus = 0;
        self.attachmentType = type;
    }
    return self;
}
/**
 *  为发送socket输出JSON语句
 *
 *  @return "{\"fileName\":\"emoji.jpg\",\"fileSize\":95709,\"thumbnail\":\"/attachment/20150430/guid.jpg\",\"fileUrl\":\"/attachment/20150430/guid.jpg\"}"
 */
- (NSString *)getJsonStringForSocket
{
    NSMutableDictionary *dictForJson = [NSMutableDictionary dictionary];
    dictForJson[DICT_fileName] = self.fileName;
    dictForJson[DICT_fileSize] = [NSNumber numberWithLong:self.fileSize];
    dictForJson[DICT_thumbnail] = self.thumbnail;
    dictForJson[DICT_fileUrl] = self.fileUrl;
    dictForJson[DICT_thumbnailWidth] = @(self.thumbnailWidth);
    dictForJson[DICT_thumbnailHeight] = @(self.thumbnailHeight);
    
    return [dictForJson mj_JSONString];
}

/**
 *  为发送AudioSocket输出JSON语句
 *
 *  @return "{\"fileUrl\":\"/attachment/20150430/guid.mp4\",\"audioLength\":3}"
 */
- (NSString *)getJsonStringForAudioSocket
{
    NSMutableDictionary *dictForJson = [NSMutableDictionary dictionary];
    dictForJson[DICT_fileUrl] = self.fileUrl;
    AVAudioPlayer *play_tmp = [[AVAudioPlayer alloc] initWithData:self.dataAll error:nil];
    NSTimeInterval k = play_tmp.duration;

    dictForJson[DICT_audioLength] = [NSNumber numberWithFloat:k];
    return [dictForJson mj_JSONString];
}

/**
 *  为发送VideoSocket输出JSON语句
 *
 *  @return "{\"fileUrl\":\"/attachment/20150430/guid.mp4\",\"fileSize\":95709,\"videoLength\":12,\"thumbnail\":\"/attachment/20150430/guid.jpg\"}"
 */
- (NSString *)getJsonStringForVideoSocket{
    
    NSMutableDictionary *dictForJson = [NSMutableDictionary dictionary];
//    dictForJson[DICT_fileName] = self.fileName;
    dictForJson[DICT_fileUrl] = self.fileUrl;
    dictForJson[DICT_fileSize] = [NSNumber numberWithLong:self.fileSize];
    dictForJson[DICT_thumbnail] = self.thumbnail;
    AVAudioPlayer *play_tmp = [[AVAudioPlayer alloc] initWithData:self.dataAll error:nil];
    NSTimeInterval k = play_tmp.duration;
    dictForJson[DICT_videoLength] = [NSNumber numberWithFloat:k];

    return [dictForJson mj_JSONString];
}

@end
