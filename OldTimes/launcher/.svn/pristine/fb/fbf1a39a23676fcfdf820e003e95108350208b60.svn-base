//
//  ContactDetailModel+SQLUtil.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ContactDetailModel+SQLUtil.h"
#import <FMDB/FMResultSet.h>
#import "NSString+Manager.h"
#import <MJExtension/MJExtension.h>
#import "MessageBaseModel.h"
#import "MessageBaseModel+Private.h"
@implementation ContactDetailModel (SQLUtil)

+ (instancetype)sql_initWithResult:(FMResultSet *)result {
    ContactDetailModel *model = [[ContactDetailModel alloc] init];

    model._sqlId            = [result intForColumn:contact_sqlid];
    model._target           = [result stringForColumn:contact_target];
    model._nickName         = [result stringForColumn:contact_nickName];
    model._headPic          = [result stringForColumn:contact_headpic];
    model._content          = [result stringForColumn:contact_content];
    model._countUnread      = [result intForColumn:contact_countUnread];
    model._timeStamp        = [result longLongIntForColumn:contact_timeStamp];
    model._isGroup          = [result boolForColumn:contact_isGroup];
    model._isApp            = [result boolForColumn:contact_isApp];
    model._info             = [result stringForColumn:contact_info];
    model._muteNotification = [result intForColumn:contact_muteNotification];
    model._lastMsgId        = [result longLongIntForColumn:contact_lastMsgId];
    model._atMe             = [result boolForColumn:contact_atMe];
    model._lastMsg        = [result stringForColumn:contact_lastMsg];
    model._tag              = [result stringForColumn:
                               contact_tag];
    if (model._lastMsg.length) {
        NSDictionary *dict = [model._lastMsg mj_JSONObject];
        MessageBaseModel *baseModel = [[MessageBaseModel alloc] initWithDict:dict];
        model._lastMsgModel = baseModel;
    }

    NSData *data = [result dataForColumn:contact_draft];
    if (data) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        model._draft = [unarchiver decodeObjectForKey:contact_draft];
    } else {
        model._draft = [NSAttributedString new];
    }
    
    return model;
}

@end
