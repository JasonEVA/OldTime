//
//  AudioMessageManager.h
//  Titans
//
//  Created by Remon Lv on 14-9-27.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  语音消息管理器（非单例）

#import <Foundation/Foundation.h>

@interface AudioMessageManager : NSObject

/**
 *  通过wav路径生成amr格式音频并写入沙盒
 *
 *  @param wavPath    wav音频路径
 *  @param queue      分线程queue
 *  @param completion 完成回调
 *
 *  @return amr音频路径
 */
+ (NSString *)wavToAmr:(NSString *)wavPath queue:(dispatch_queue_t)queue completion:(void (^)())completion;
@end
