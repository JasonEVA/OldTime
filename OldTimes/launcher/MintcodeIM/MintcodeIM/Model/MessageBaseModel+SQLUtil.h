//
//  MessageBaseModel+SQLUtil.h
//  launcher
//
//  Created by williamzhang on 16/1/26.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageBaseModel.h"

@class FMResultSet;

// 消息主体
#define MSG_sqlId               @"_sqlId"
#define MSG_fromLoginName       @"_fromLoginName"
#define MSG_toLoginName         @"_toLoginName"
#define MSG_target              @"_target"
#define MSG_memberList          @"_memberList"
#define MSG_content             @"_content"
#define MSG_imgOriginalUrl      @"_imgOriginalUrl"
#define MSG_imgthumbnailUrl     @"_imgthumbnailUrl"
#define MSG_fileName            @"_fileName"
#define MSG_fileSize            @"_fileSize"
#define MSG_clientMsgId         @"_clientMsgId"
#define MSG_msgId               @"_msgId"
#define MSG_info                @"_info"
#define MSG_createDate          @"_createDate"
#define MSG_type                @"_type"
#define MSG_modified            @"_modified"
// 消息标记
#define MSG_markReceive         @"_markReceive"
#define MSG_markStatus          @"_markStatus"
#define MSG_markReaded          @"_markReaded"
#define MSG_markCompleted       @"_markCompleted"      // 资源完整性
#define MSG_markImportant       @"_markImportant"      // 标为重点

@interface MessageBaseModel (SQLUtil)

+ (instancetype)sql_initWithResult:(FMResultSet *)result;

@end
