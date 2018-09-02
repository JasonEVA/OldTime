//
//  MessageRecallTable.m
//  launcher
//
//  Created by williamzhang on 16/1/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "MessageRecallTable.h"
#import "MessageBaseModel+SQLUtil.h"
#import "NSString+Manager.h"
#import "MsgUserInfoMgr.h"
#import "FMDatabase.h"

NSString *const kRecallTable = @"table_msg_recall";

@implementation MessageRecallTable

+ (void)createRecallTableWithDB:(FMDatabase *)db {
    NSString *sqlString = [NSString stringWithFormat:@"create table if not exists '%@' (%@ integer primary key autoincrement, %@ text, %@ text, %@ text, %@ text, %@ integer, %@ text, %@ text, %@ text, %@ text, %@ text, %@ integer, %@ text, %@ integer, %@ text, %@ integer, %@ integer, %@ integer, %@ integer, %@ integer, %@ integer)",
                           kRecallTable,
                           MSG_sqlId,
                           MSG_target,
                           MSG_fromLoginName,
                           MSG_toLoginName,
                           MSG_memberList,
                           MSG_clientMsgId,
                           MSG_content,
                           MSG_imgOriginalUrl,
                           MSG_imgthumbnailUrl,
                           MSG_fileName,
                           MSG_fileSize,
                           MSG_msgId,
                           MSG_info,
                           MSG_createDate,
                           MSG_type,
                           MSG_markReceive,
                           MSG_markReaded,
                           MSG_markCompleted,
                           MSG_markStatus,
                           MSG_modified,
                           MSG_markImportant];
   
    if (![db executeUpdate:sqlString]) {
        NSAssert(0, @"回撤表创建失败");
    }
}

@end

@implementation MessageRecallTable (Insert)

+ (BOOL)writeMessageWithDB:(FMDatabase *)db data:(MessageBaseModel *)model {
    if (model._type != msg_personal_reSend) {
        return NO;
    }
    
    // 回撤里面的消息，提取出来
    MessageBaseModel *internalMessage = [model getContentBaseModel];
    // 插入数据（type,msgId,content,clientMsgId需要使用internalMessage，其余使用model的字段）
    
    NSString *selectSQL = [NSString stringWithFormat:@"select * from '%@' where %@ = ? and %@ = ?",kRecallTable, MSG_clientMsgId, MSG_fromLoginName];
    
    FMResultSet *result = [db executeQuery:selectSQL, @(internalMessage._clientMsgId), model._fromLoginName];
    
    BOOL isExist = NO;
    while ([result next]) {
        isExist = YES;
    }
    
    NSString *executeSQL = @"";
    
    if (isExist) {
        if ([model._fromLoginName isEqualToString:[[MsgUserInfoMgr share] getUid]]) {
            executeSQL = [NSString stringWithFormat:@"update '%@' set %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?",kRecallTable,MSG_msgId, MSG_imgOriginalUrl, MSG_imgthumbnailUrl, MSG_createDate, MSG_markStatus, MSG_content, MSG_markImportant, MSG_markReaded, MSG_clientMsgId, MSG_fromLoginName];
            
            return [db executeUpdate:executeSQL, @(internalMessage._msgId), model._nativeOriginalUrl, model._nativeThumbnailUrl, @(model._createDate), @(model._markStatus), internalMessage._content, @(model._markImportant), @(model._markReaded), @(internalMessage._clientMsgId), model._fromLoginName];
        }
        
        executeSQL = [NSString stringWithFormat:@"update '%@' set %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?",kRecallTable,MSG_fromLoginName,MSG_toLoginName,MSG_imgOriginalUrl, MSG_imgthumbnailUrl, MSG_fileSize, MSG_msgId, MSG_createDate, MSG_type, MSG_markReceive, MSG_markCompleted, MSG_markStatus, MSG_content, MSG_markImportant, MSG_clientMsgId, MSG_fromLoginName];
        
        return [db executeUpdate:executeSQL, model._fromLoginName, model._toLoginName, model._nativeOriginalUrl, model._nativeThumbnailUrl, model._fileSize, @(internalMessage._msgId), @(model._createDate), [MessageBaseModel getStringFromMsgType:internalMessage._type], @(model._markFromReceive), @(model._markReaded), @(model._markCompleted), @(model._markStatus), internalMessage._content, @(model._markImportant), @(internalMessage._clientMsgId), model._fromLoginName];
    }
    
    executeSQL = [NSString stringWithFormat:@"insert into '%@' (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",kRecallTable,MSG_target,MSG_fromLoginName,MSG_toLoginName,MSG_content,MSG_imgOriginalUrl, MSG_imgthumbnailUrl, MSG_fileName, MSG_fileSize, MSG_clientMsgId, MSG_msgId, MSG_info, MSG_createDate, MSG_type, MSG_markReceive, MSG_markReaded, MSG_markCompleted, MSG_markStatus, MSG_markImportant];
    
    return [db executeUpdate:executeSQL, model._target, model._fromLoginName, model._toLoginName, internalMessage._content, model._nativeOriginalUrl, model._nativeThumbnailUrl, model._fileName, model._fileSize, @(internalMessage._clientMsgId), @(internalMessage._msgId), model._info, @(model._createDate), [MessageBaseModel getStringFromMsgType:internalMessage._type], @(model._markFromReceive), @(model._markReaded), @(model._markCompleted), @(model._markStatus), @(model._markImportant)];
}

@end

@implementation MessageRecallTable (Query)

+ (NSArray *)queryRecallMessageWithDB:(FMDatabase *)db compareData:(MessageBaseModel *)model {
    NSString *selectSQL = [NSString stringWithFormat:@"select * from '%@' where %@ = ? and %@ > ?",kRecallTable , MSG_target, MSG_msgId];
    FMResultSet *result = [db executeQuery:selectSQL, model._target, @(model._msgId)];

    NSMutableArray *resultList = [NSMutableArray new];
    while ([result next]) {
        MessageBaseModel *message = [MessageBaseModel sql_initWithResult:result];
        [resultList addObject:message];
    }
    
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from '%@' where %@ = ? and %@ > ?", kRecallTable, MSG_target, MSG_msgId];
    [db executeUpdate:deleteSQL, model._target, @(model._msgId)];
    
    return resultList;
}

@end
