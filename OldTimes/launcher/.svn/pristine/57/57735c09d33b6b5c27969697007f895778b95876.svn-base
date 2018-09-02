//
//  AudioMessageManager.m
//  Titans
//
//  Created by Remon Lv on 14-9-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "AudioMessageManager.h"
#import "MsgFilePathMgr.h"
#import "VoiceConverter.h"
#import "MsgSqlMgr.h"

#define T_WAV   @".wav"
#define T_AMR   @".amr"

@implementation AudioMessageManager

+ (NSString *)wavToAmr:(NSString *)wavPath queue:(dispatch_queue_t)queue completion:(void (^)())completion {
    NSString *amrPath = [AudioMessageManager replaceExtesionWithPath:wavPath To:extension_amr];
    
    dispatch_async(queue, ^{
        [VoiceConverter wavToAmr:wavPath amrSavePath:amrPath];
        dispatch_async(dispatch_get_main_queue(), completion);
    });
    
    return amrPath;
}

/**
 *  替换音频路径的后缀
 *
 *  @param path      原路径
 *  @param extension 格式标记
 *
 *  @return 新路径
 */
+ (NSString *)replaceExtesionWithPath:(NSString *)path To:(Extension_audio)extension
{
    // 得到新扩展名
    NSString *strNewExtension = (extension == extension_wav ? T_WAV : T_AMR);
    
    // 替换
    NSString *strPathAmr = [path substringToIndex:([path length] - 4)];
    strPathAmr = [strPathAmr stringByAppendingString:strNewExtension];
    
    return strPathAmr;
}

@end
