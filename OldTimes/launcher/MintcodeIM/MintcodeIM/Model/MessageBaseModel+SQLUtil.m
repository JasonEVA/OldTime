//
//  MessageBaseModel+SQLUtil.m
//  launcher
//
//  Created by williamzhang on 16/1/26.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageBaseModel+SQLUtil.h"
#import "IMApplicationManager.h"
#import <FMDB/FMResultSet.h>
#import "IMConfigure.h"

@implementation MessageBaseModel (SQLUtil)

+ (instancetype)sql_initWithResult:(FMResultSet *)result {
    MessageBaseModel *model = [[MessageBaseModel alloc] init];
    
    model._sqlId              = [result intForColumn:MSG_sqlId];
    model._target             = [result stringForColumn:MSG_target];
    model._content            = [result stringForColumn:MSG_content];
    model._nativeOriginalUrl  = [result stringForColumn:MSG_imgOriginalUrl];
    model._nativeThumbnailUrl = [result stringForColumn:MSG_imgthumbnailUrl];
    model._fileName           = [result stringForColumn:MSG_fileName];
    model._fileSize           = [result stringForColumn:MSG_fileSize];
    model._clientMsgId        = [result longLongIntForColumn:MSG_clientMsgId];
    model._msgId              = [result longLongIntForColumn:MSG_msgId];
    model._info               = [result stringForColumn:MSG_info];
    model._createDate         = [result longLongIntForColumn:MSG_createDate];
    model._markFromReceive    = [result boolForColumn:MSG_markReceive];
    model._markStatus         = (Msg_status)[result intForColumn:MSG_markStatus];
    model._markReaded         = [result boolForColumn:MSG_markReaded];
    model._markCompleted      = [result boolForColumn:MSG_markCompleted];
    model._fromLoginName      = [result stringForColumn:MSG_fromLoginName];
    model._toLoginName        = [result stringForColumn:MSG_toLoginName];
    model._markImportant      = [result boolForColumn:MSG_markImportant];

    NSString *typeString = [result stringForColumn:MSG_type];
    model._type = [MessageBaseModel getMsgTypeFromString:typeString];
    
    if (model._type == msg_personal_event) {
        model._type = model.appModel.eventType;
        if (![model isEventType]) {
            model._type = msg_personal_event;
        }
    }
    
    return model;
}

@end
