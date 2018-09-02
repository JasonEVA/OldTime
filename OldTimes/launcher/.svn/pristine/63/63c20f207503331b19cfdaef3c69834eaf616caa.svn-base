//
//  MessageTable.m
//  launcher
//
//  Created by Andrew Shen on 15/9/24.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MessageTable.h"
#import "FMDatabase.h"
#import "MessageBaseModel+SQLUtil.h"
#import "MsgDefine.h"
#import "MsgUserInfoMgr.h"
#import "NSString+Manager.h"
#import <MJExtension/MJExtension.h>
#import "MessageRecallTable.h"

NSString *const kTableMessage = @"table_msg";
@implementation MessageTable
/**
 *  创建表
 */
+ (void)createMessageTableWithDB:(FMDatabase *)db {
    NSString *strSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (%@ INTEGER primary key autoincrement,%@ TEXT,%@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT, %@ INTEGER, %@ TEXT, %@ INTEGER, %@ INTEGER,%@ INTEGER, %@ INTEGER, %@ INTEGER, %@ INTEGER);" ,
                        kTableMessage,
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
    // 创建表
    if (![db executeUpdate:strSql])
    {
        NSAssert(0, @"消息表创建失败");
    }
    
    [MessageRecallTable createRecallTableWithDB:db];
}

#pragma mark - Update
/**
 *  插入消息
 *
 *  @param db    db
 *  @param array 消息数组
 *
 */
+ (void)insertMessageWithDB:(FMDatabase *)db batchData:(NSArray *)array {
    for (MessageBaseModel *model in array) {
        // 先判断是不是撤回消息
        if (model._type == msg_personal_reSend)
        {
            BOOL isContinue = [self updateReSendMessageWithDB:db baseModel:model];
            if (isContinue) {
                // 存在了，删除掉该条
                [self deleteMessageWithDB:db baseModel:model];
                continue;
            }
        }
        
        if (model._type == msg_personal_voip && model.voipModel.state == 0) {
            continue;
        }
        
        // 判断是否存此条cid的消息
        BOOL isExist = NO;
        NSString *strMessage = [NSString stringWithFormat:@"select * from '%@' where %@ = '%lld' and %@ = '%@'",kTableMessage, MSG_clientMsgId, model._clientMsgId,MSG_fromLoginName, model._fromLoginName];
        PRINT_STRING(strMessage);
        FMResultSet *result = [db executeQuery:strMessage];
        NSString *originalImageURL;
        NSString *thumbnailImageURL;
        long long msgId = 0;
        while ([result next]) {
            isExist = YES;
            msgId = [result longLongIntForColumn:MSG_msgId];
            // 自己上传的图片，本地已经存储则不用更新
            originalImageURL = [result objectForColumnName:MSG_imgOriginalUrl];
            thumbnailImageURL = [result objectForColumnName:MSG_imgthumbnailUrl];
        }
        
        if (msgId != 0 && msgId > model._msgId) {
            // 应用消息按msgId最大为最新 如果没有msgID直接跳过
            continue;
        }
        //处理撤回消息
        NSArray *recallList = [MessageRecallTable queryRecallMessageWithDB:db compareData:model];
        if ([recallList count]) {
            [self insertMessageWithDB:db batchData:recallList];
        }
        
        // 特殊字符转义
        NSString *strNewContent = [NSString convertSpecialCharInString:model._content];
        NSString *strNewInfo = [NSString convertSpecialCharInString:model._info];
        NSString *strNewFileName = [NSString convertSpecialCharInString:model.attachModel.fileName];
        
        if (isExist)
        {
            if ([model._fromLoginName isEqualToString:[[MsgUserInfoMgr share] getUid]])
            {
                // 更新 －－ 不是我发出的
                strMessage = [NSString stringWithFormat:@"UPDATE '%@' set %@ = '%lld',%@ = '%@',%@ = '%@', %@ = '%lld', %@ = '%ld' , %@ = '%@', %@ = '%d' , %@ = '%d', %@ = '%@'  \
                              where %@ = '%lld' and %@ = '%@'",
                              kTableMessage,
                              MSG_msgId,model._msgId,
                              MSG_imgOriginalUrl,([originalImageURL length] ? originalImageURL: model._nativeOriginalUrl),
                              MSG_imgthumbnailUrl,([thumbnailImageURL length] ? thumbnailImageURL : model._nativeThumbnailUrl),
                              MSG_createDate,model._createDate,
                              MSG_markStatus,(long)model._markStatus,
                              MSG_content,strNewContent,
                              MSG_markImportant,model._markImportant,
                              MSG_markReaded,model._markReaded,
                              MSG_type,[MessageBaseModel getStringFromMsgType:model._type],
                              MSG_clientMsgId,model._clientMsgId,
                              MSG_fromLoginName,model._fromLoginName];
                PRINT_STRING(strMessage);
            }
            else
            {
                // 更新 －－ 我发出的
                strMessage = [NSString stringWithFormat:@"UPDATE '%@' set %@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%lld',%@ = '%lld',%@ = '%@',%@ = '%d',%@ = '%d',%@ = '%d',%@ = '%ld' , %@ = '%@', %@ = '%d'  \
                              where %@ = '%lld' and %@ = '%@'",
                              kTableMessage,
                              MSG_fromLoginName,model._fromLoginName,
                              MSG_toLoginName,model._toLoginName,
                              MSG_imgOriginalUrl,([originalImageURL length] ? originalImageURL : model._nativeOriginalUrl),
                              MSG_imgthumbnailUrl,([thumbnailImageURL length] ? thumbnailImageURL : model._nativeThumbnailUrl),
                              MSG_fileSize,model._fileSize,
                              MSG_msgId,model._msgId,
                              MSG_createDate,model._createDate,
                              MSG_type,[MessageBaseModel getStringFromMsgType:model._type],
                              MSG_markReceive,model._markFromReceive,
                              MSG_markReaded,model._markReaded,
                              MSG_markCompleted,model._markCompleted,
                              MSG_markStatus,(long)model._markStatus,
                              MSG_content,strNewContent,
                              MSG_markImportant,model._markImportant,
                              MSG_clientMsgId,model._clientMsgId,
                              MSG_fromLoginName,model._fromLoginName];
            }
            PRINT_STRING(strMessage);
        }
        else
        {
            // 插入
            strMessage = [NSString stringWithFormat:@"INSERT INTO '%@' (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%lld','%lld','%@','%lld','%@','%d','%d','%d','%ld','%d')",
                          kTableMessage,
                          MSG_target,
                          MSG_fromLoginName,
                          MSG_toLoginName,
                          MSG_content,
                          MSG_imgOriginalUrl,
                          MSG_imgthumbnailUrl,
                          MSG_fileName,
                          MSG_fileSize,
                          MSG_clientMsgId,
                          MSG_msgId,
                          MSG_info,
                          MSG_createDate,
                          MSG_type,
                          MSG_markReceive,
                          MSG_markReaded,
                          MSG_markCompleted,
                          MSG_markStatus,
                          MSG_markImportant,
                          model._target,
                          model._fromLoginName,
                          model._toLoginName,
                          strNewContent,
                          model._nativeOriginalUrl,
                          model._nativeThumbnailUrl,
                          strNewFileName,
                          model._fileSize,
                          model._clientMsgId,
                          model._msgId,
                          strNewInfo,
                          model._createDate,
                          [MessageBaseModel getStringFromMsgType:model._type],
                          model._markFromReceive,
                          model._markReaded,
                          model._markCompleted,
                          (long)model._markStatus,
                          model._markImportant];
            PRINT_STRING(strMessage);
        }
        // 插入数据库
        if (![db executeUpdate:strMessage])
        {
            NSAssert(0, @"插入消息数据失败");
        }
    }
    
}

+ (void)insertReceivedMessageWithDB:(FMDatabase *)db batchData:(NSArray *)array {
    for (MessageBaseModel *model in array) {
        // 先判断是不是撤回消息
        if (model._type == msg_personal_reSend)
        {
            BOOL isContinue = [self updateReSendMessageWithDB:db baseModel:model];
            if (isContinue) {
                // 存在了，删除掉该条
                [self deleteMessageWithDB:db baseModel:model];
                continue;
            }
        }
        
        if (model._type == msg_personal_voip && model.voipModel.state == 0) {
            continue;
        }
        
        // 判断是否存此条cid的消息
        BOOL isExist = NO;
        NSString *strMessage = [NSString stringWithFormat:@"select * from '%@' where %@ = '%lld' and %@ = '%@' and %@ = '%lld'",kTableMessage, MSG_clientMsgId, model._clientMsgId,MSG_fromLoginName, model._fromLoginName,MSG_msgId,model._msgId];
        PRINT_STRING(strMessage);
        FMResultSet *result = [db executeQuery:strMessage];
        NSString *originalImageURL;
        NSString *thumbnailImageURL;
        long long msgId = 0;
        while ([result next]) {
            isExist = YES;
            
            msgId = [result longLongIntForColumn:MSG_msgId];
            // 自己上传的图片，本地已经存储则不用更新
            originalImageURL = [result objectForColumnName:MSG_imgOriginalUrl];
            thumbnailImageURL = [result objectForColumnName:MSG_imgthumbnailUrl];
        }
        
        if (msgId != 0 && msgId > model._msgId) {
            // 应用消息按msgId最大为最新 如果没有msgID直接跳过
            continue;
        }
        //处理撤回消息
        NSArray *recallList = [MessageRecallTable queryRecallMessageWithDB:db compareData:model];
        if ([recallList count]) {
            [self insertMessageWithDB:db batchData:recallList];
        }
        
        // 特殊字符转义
        NSString *strNewContent = [NSString convertSpecialCharInString:model._content];
        NSString *strNewInfo = [NSString convertSpecialCharInString:model._info];
        NSString *strNewFileName = [NSString convertSpecialCharInString:model.attachModel.fileName];
        
        if (isExist)
        {
            if ([model._fromLoginName isEqualToString:[[MsgUserInfoMgr share] getUid]])
            {
                // 更新 －－ 不是我发出的
                strMessage = [NSString stringWithFormat:@"UPDATE '%@' set %@ = '%lld',%@ = '%@',%@ = '%@', %@ = '%lld', %@ = '%ld' , %@ = '%@', %@ = '%d' , %@ = '%d', %@ = '%@'  \
                              where %@ = '%lld' and %@ = '%@' and %@ = '%lld'",
                              kTableMessage,
                              MSG_msgId,model._msgId,
                              MSG_imgOriginalUrl,([originalImageURL length] ? originalImageURL: model._nativeOriginalUrl),
                              MSG_imgthumbnailUrl,([thumbnailImageURL length] ? thumbnailImageURL : model._nativeThumbnailUrl),
                              MSG_createDate,model._createDate,
                              MSG_markStatus,(long)model._markStatus,
                              MSG_content,strNewContent,
                              MSG_markImportant,model._markImportant,
                              MSG_markReaded,model._markReaded,
                              MSG_type,[MessageBaseModel getStringFromMsgType:model._type],
                              MSG_clientMsgId,model._clientMsgId,
                              MSG_fromLoginName,model._fromLoginName,
                              MSG_msgId,model._msgId];
                PRINT_STRING(strMessage);
            }
            else
            {
                // 更新 －－ 我发出的
                strMessage = [NSString stringWithFormat:@"UPDATE '%@' set %@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%@',%@ = '%lld',%@ = '%lld',%@ = '%@',%@ = '%d',%@ = '%d',%@ = '%d',%@ = '%ld' , %@ = '%@', %@ = '%d'  \
                              where %@ = '%lld' and %@ = '%@' and %@ = '%lld'",
                              kTableMessage,
                              MSG_fromLoginName,model._fromLoginName,
                              MSG_toLoginName,model._toLoginName,
                              MSG_imgOriginalUrl,([originalImageURL length] ? originalImageURL : model._nativeOriginalUrl),
                              MSG_imgthumbnailUrl,([thumbnailImageURL length] ? thumbnailImageURL : model._nativeThumbnailUrl),
                              MSG_fileSize,model._fileSize,
                              MSG_msgId,model._msgId,
                              MSG_createDate,model._createDate,
                              MSG_type,[MessageBaseModel getStringFromMsgType:model._type],
                              MSG_markReceive,model._markFromReceive,
                              MSG_markReaded,model._markReaded,
                              MSG_markCompleted,model._markCompleted,
                              MSG_markStatus,(long)model._markStatus,
                              MSG_content,strNewContent,
                              MSG_markImportant,model._markImportant,
                              MSG_clientMsgId,model._clientMsgId,
                              MSG_fromLoginName,model._fromLoginName,
                              MSG_msgId,model._msgId];
            }
            PRINT_STRING(strMessage);
        }
        else
        {
            // 插入
            strMessage = [NSString stringWithFormat:@"INSERT INTO '%@' (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%lld','%lld','%@','%lld','%@','%d','%d','%d','%ld','%d')",
                          kTableMessage,
                          MSG_target,
                          MSG_fromLoginName,
                          MSG_toLoginName,
                          MSG_content,
                          MSG_imgOriginalUrl,
                          MSG_imgthumbnailUrl,
                          MSG_fileName,
                          MSG_fileSize,
                          MSG_clientMsgId,
                          MSG_msgId,
                          MSG_info,
                          MSG_createDate,
                          MSG_type,
                          MSG_markReceive,
                          MSG_markReaded,
                          MSG_markCompleted,
                          MSG_markStatus,
                          MSG_markImportant,
                          model._target,
                          model._fromLoginName,
                          model._toLoginName,
                          strNewContent,
                          model._nativeOriginalUrl,
                          model._nativeThumbnailUrl,
                          strNewFileName,
                          model._fileSize,
                          model._clientMsgId,
                          model._msgId,
                          strNewInfo,
                          model._createDate,
                          [MessageBaseModel getStringFromMsgType:model._type],
                          model._markFromReceive,
                          model._markReaded,
                          model._markCompleted,
                          (long)model._markStatus,
                          model._markImportant];
            PRINT_STRING(strMessage);
        }
        // 插入数据库
        if (![db executeUpdate:strMessage])
        {
            NSAssert(0, @"插入消息数据失败");
        }
    }
    
}



/**
 *  发送消息收到回执更新数据
 *
 *  @param db    db
 *  @param model 消息数据
 */
+ (void)updateSendMessageSuccessWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)model {
    
    NSString *strMessage = @"";
    
    if (model._type >= msg_personal_event && model._type < msg_usefulMsgMax)
    {
        NSString *strNewContent = [NSString convertSpecialCharInString:model._content];
        // 更新
        strMessage = [NSString stringWithFormat:@"UPDATE '%@' set %@ = '%lld', %@ = '%lld' , %@ = '%@', %@ = '1' where %@ = '%lld' and %@ = '%@'",
                      kTableMessage,
                      MSG_msgId,model._msgId,
                      MSG_createDate,model._createDate,
                      MSG_content,strNewContent,
                      MSG_markCompleted,
                      MSG_clientMsgId,model._clientMsgId,
                      MSG_fromLoginName, model._fromLoginName];
    }
    else
    {
        // 更新
        strMessage = [NSString stringWithFormat:@"UPDATE '%@' set %@ = '%lld', %@ = '%lld', %@ = '1' where %@ = '%lld' and %@ = '%@'",
                      kTableMessage,
                      MSG_msgId,model._msgId,
                      MSG_createDate,model._createDate,
                      MSG_markCompleted,
                      MSG_clientMsgId,model._clientMsgId,
                      MSG_fromLoginName, model._fromLoginName];
    }
    
    // 插入数据库
    if (![db executeUpdate:strMessage])
    {
        NSAssert(0, @"更新消息回执数据库失败");
    }
    
}

/**
 *  收到撤回消息更新数据
 *
 *  @param db    db
 *  @param model 消息数据
 */
+ (BOOL)updateReSendMessageWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)model {
    MessageBaseModel *newBaseModel = [model getContentBaseModel];
    // 判断是否存此条msgId的消息 --- 存在并更新了原始的数据／如果不存在存放在recall列表中
    BOOL isExist = NO;
    NSString *strMessage = [NSString stringWithFormat:@"select * from '%@' where %@ = '%lld' and %@ = '%@'",kTableMessage, MSG_clientMsgId, newBaseModel._clientMsgId,MSG_fromLoginName, model._fromLoginName];
    PRINT_STRING(strMessage);
    FMResultSet *result = [db executeQuery:strMessage];
    while ([result next]) {
        isExist = YES;
    }
    
    // 特殊字符转义
    NSString *strNewContent = [NSString convertSpecialCharInString:newBaseModel._content];
    
    if (isExist)
    {
        // 先删除原来那条 (暂时更新原来那条)
        strMessage =  [NSString stringWithFormat:@"UPDATE '%@' set %@ = ? ,%@ = ?,%@ = ? where %@ = ? and %@ = '%@'",
                       kTableMessage,
                       MSG_type,
                       MSG_content,
                       MSG_markReaded,
                       MSG_clientMsgId,
                       MSG_fromLoginName,model._fromLoginName];
        PRINT_STRING(strMessage);
        
        // 插入数据库
        if (![db executeUpdate:strMessage,[MessageBaseModel getStringFromMsgType:newBaseModel._type],strNewContent,@(newBaseModel._markReaded),@(newBaseModel._clientMsgId)])
        {
            NSAssert(0, @"消息撤回失败");
        }
    } else {
        // 插入到撤回表中
        [MessageRecallTable writeMessageWithDB:db data:model];
    }
    
    return isExist;
}

/**
 *  标记对象的消息为已读(除语音外) (左边的消息)
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (void)updateReadedForContactWithDB:(FMDatabase *)db uid:(NSString *)uid {
    NSString *sqlMsg = [NSString stringWithFormat:@"UPDATE '%@' set '%@' = '1' where %@ = '%@' and (%@ = '%@' or %@ = '%@') and %@ = '%@'",
                        kTableMessage,
                        MSG_markReaded,
                        MSG_target,uid,
                        MSG_type,[MessageBaseModel getStringFromMsgType:msg_personal_text],
                        MSG_type,[MessageBaseModel getStringFromMsgType:msg_personal_image],
                        MSG_fromLoginName,uid];
    // 插入数据库
    if (![db executeUpdate:sqlMsg])
    {
        NSAssert(0, @"标记某个联系人所有消息为已读失败");
    }
    
}

/**
 *  将对方读过的消息标记
 *
 *  @param db        db
 *  @param msgIDList 已读消息msgID数组,(string)
 */
+ (void)updateSentMessageReadedWithDB:(FMDatabase *)db messageIDList:(NSArray *)msgIDList {
    
    // 生成建表语句
    for (NSString *msgId in msgIDList)
    {
        // 判断是否存此条cid的消息
        BOOL isExist = NO;
        NSString *strMessage = [NSString stringWithFormat:@"select * from '%@' where %@ = '%lld'",kTableMessage, MSG_msgId, [msgId longLongValue]];
        PRINT_STRING(strMessage);
        FMResultSet *result = [db executeQuery:strMessage];
        while ([result next])
        {
            isExist = YES;
        }
        
        if (isExist)
        {
            // 更新
            strMessage = [NSString stringWithFormat:@"update '%@' set '%@' = '1' where %@ = '%@'",kTableMessage, MSG_markReaded,MSG_msgId, msgId];
            // 插入数据库
            if (![db executeUpdate:strMessage])
            {
                NSAssert(0, @"更新发送消息为已读失败");
            }
        }
    }
    
    //    NSString *msgId = [msgIDList lastObject];
    //    NSString *strMessage = [NSString stringWithFormat:@"select * from '%@' where %@ <= '%lld' and %@ <> '%lu'",kTableMessage, MSG_msgId, [msgId longLongValue], MSG_type,(unsigned long)msg_personal_voice];
    //    FMResultSet *result = [db executeQuery:strMessage];
    //    while ([result next])
    //    {
    //         long long msgId = [result longLongIntForColumn:MSG_msgId];
    //        // 更新
    //        strMessage = [NSString stringWithFormat:@"update '%@' set '%@' = '1' where %@ = '%lld'",kTableMessage, MSG_markReaded,MSG_msgId, msgId];
    //        // 插入数据库
    //        if (![db executeUpdate:strMessage])
    //        {
    //            NSAssert(0, @"更新发送消息为已读失败");
    //        }
    //
    //    }
}

/**
 *  将消息标记重点
 *
 *  @param db        db
 *  @param msgIDList 标记消息msgID,(longlong)
 */
+ (void)updateMarkMessageImportantWithDB:(FMDatabase *)db messageID:(long long)msgID important:(BOOL)isImportant
{
    NSString *sqlMsg = [NSString stringWithFormat:@"update '%@' set '%@' = '%d' where %@ = '%lld'",
                        kTableMessage,
                        MSG_markImportant,isImportant,
                        MSG_msgId, msgID];
    
    // 更改数据库
    if (![db executeUpdate:sqlMsg])
    {
        NSAssert(0, @"标记消息重点操作失败");
    }
}

/**
 *  标记某条消息状态
 *
 *  @param db        db
 *  @param baseModel 消息model
 *  @param msgStatus 消息状态
 *
 *  @return 联系人唯一标识符
 */
+ (NSString *)updateMessageStatusWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel status:(Msg_status)msgStatus {
    // 取出消息总表
    NSString *sqlMsg;
    NSString *uid = nil;
    
    // 判断是否存在
    sqlMsg = [NSString stringWithFormat:@"select * from '%@' where %@ = '%lld'",
              kTableMessage,
              MSG_clientMsgId,baseModel._clientMsgId];
    FMResultSet *result = [db executeQuery:sqlMsg];
    while ([result next])
    {
        // 1.得到消息对象
        uid = [result stringForColumn:MSG_target];
    }
    
    if (msgStatus == status_send_success)
    {
        // 更新status、msgId、createDate
        sqlMsg = [NSString stringWithFormat:@"update '%@' set '%@' = '%ld' , '%@' = '%lld' , '%@' = '%lld' where %@ = '%lld'",
                  kTableMessage,
                  MSG_markStatus, (long)msgStatus,
                  MSG_msgId, baseModel._msgId,
                  MSG_createDate, baseModel._createDate,
                  MSG_clientMsgId,baseModel._clientMsgId];
    }
    else if (msgStatus == status_send_failed)
    {
        // 更新status
        sqlMsg = [NSString stringWithFormat:@"update '%@' set '%@' = '%ld' where %@ = '%lld'",
                  kTableMessage,
                  MSG_markStatus, (long)msgStatus,
                  MSG_clientMsgId,baseModel._clientMsgId];
    }
    
    // 更改数据库
    if (![db executeUpdate:sqlMsg])
    {
        NSAssert(0, @"标记某个联系人消息状态失败");
    }
    return uid;
}

/**
 *  将消息的原有状态为failed
 *
 *  @param db            db
 *  @param originalState 原有状态
 */
+ (void)updateAllMessageOriginalStateToFailedWithDB:(FMDatabase *)db originalStatus:(Msg_status)originalStatus {
    NSString *sqlMsg = [NSString stringWithFormat:@"update '%@' set '%@' = '%ld' where %@ = '%ld'",
                        kTableMessage,
                        MSG_markStatus,(long)status_send_failed,
                        MSG_markStatus,originalStatus];
    
    // 更改数据库
    if (![db executeUpdate:sqlMsg])
    {
        NSAssert(0, @"标记所有发送中消息状态为失败操作失败");
    }
}

/**
 *  将某一条消息的原有状态为failed
 *
 *  @param db            db
 *  @param baseModel 消息model
 *  @param originalState 原有状态
 *  @param newStatus      新状态
 */
+ (void)updateMessageOriginalStateToFailedWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel originalStatus:(Msg_status)originalStatus newStatus:(Msg_status)newStatus {
    NSString *sqlMsg = [NSString stringWithFormat:@"update '%@' set '%@' = '%ld' where %@ = '%ld' and %@ = '%lld'",
                        kTableMessage,
                        MSG_markStatus,newStatus,
                        MSG_markStatus,originalStatus,
                        MSG_clientMsgId,baseModel._clientMsgId];
    
    // 更改数据库
    if (![db executeUpdate:sqlMsg])
    {
        NSAssert(0, @"标记信息原有状态为新状态操作失败");
    }
    
}

/**
 *  标记语音消息为已读
 *
 *  @param db    db
 *  @param sqlID 语音消息的sqlID
 */
+ (void)updateVoiceMessageReadedWithDB:(FMDatabase *)db sqlID:(NSInteger)sqlID {
    NSString *sqlMsg = [NSString stringWithFormat:@"update '%@' set '%@' = '1' where %@ = '%ld'",
                        kTableMessage,
                        MSG_markReaded,
                        MSG_sqlId, sqlID];
    
    // 更改数据库
    if (![db executeUpdate:sqlMsg])
    {
        NSAssert(0, @"标记语音消息已读操作失败");
    }
    
}

#pragma mark - Query
+ (MessageBaseModel *)queryNewestMessageWithDB:(FMDatabase *)db target:(NSString *)target {
    NSString *sqlMessage = [NSString stringWithFormat:@"select * from '%@' where %@ = "
                            "(select MAX(%@) from '%@' where %@ = '%@' order by %@ desc)",
                            kTableMessage,MSG_msgId,MSG_msgId,
                            kTableMessage,MSG_target,target,
                            MSG_sqlId];
    FMResultSet *result = [db executeQuery:sqlMessage];
    
    while ([result next]) {
        // 1.得到消息对象
        [MessageBaseModel sql_initWithResult:result];
    }
    
    return nil;
}
/**
 *  查询对象的一批消息,按时间逆序排列
 *
 *  @param db    db
 *  @param uid   对象唯一标识符
 *  @param count 条数
 *
 *  @return 消息数据
 */
+ (NSArray *)queryBatchMessageWithDB:(FMDatabase *)db uid:(NSString *)uid messageCount:(NSInteger)count {
    // 1.遍历Message表去取出
    NSMutableArray *arrMsgList = [NSMutableArray array];
    
    Msg_type appType = [MessageBaseModel getMsgTypeFromString:uid];
    NSString *strPickMessge;
    if (appType > msg_personal_event && appType < msg_usefulMsgMax)
    {
//# warning zeus 只能指定统一CID clientMsgId
        // 现在也使用msgId排序
        // 应用消息(逆序排列)
        strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' order by %@ desc ,%@ desc limit %ld",
                         kTableMessage,
                         MSG_target,uid,
                         MSG_msgId,  //MSG_msgId
                         MSG_sqlId,
                         count];
        
    }
    else
    {
        // 普通消息(逆序排列)
        strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@'  order by %@ desc ,%@ desc limit %ld",
                         kTableMessage,
                         MSG_target,uid,
                         MSG_msgId, 
                         MSG_sqlId,
                         count];
        
    }
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        // 1.得到消息对象
        MessageBaseModel *model = [MessageBaseModel sql_initWithResult:result];
        [arrMsgList addObject:model];
    }
    
    // 重新排序
    NSArray *arrTemp = [NSArray arrayWithArray:[[arrMsgList reverseObjectEnumerator] allObjects]];
    return arrTemp;
}

+ (NSArray *)queryBatchMessageWithDB:(FMDatabase *)db
                                 uid:(NSString *)uid
                        messageCount:(NSInteger)count
                         beforeMsgId:(long long)beforeMsgId
{
    NSMutableArray *messageList = [NSMutableArray array];
    
    Msg_type appType = [MessageBaseModel getMsgTypeFromString:uid];
    NSString *strPickMessge;
    if (appType > msg_personal_event && appType < msg_usefulMsgMax)
    {
        NSAssert(0, @"该方法不适用于应用,若需要，之后自行添加");
    }
    else
    {
        // 普通消息(逆序排列)
        strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' and %@ < %lld  order by %@ desc ,%@ desc limit %ld",
                         kTableMessage,
                         MSG_target,uid,
                         MSG_msgId,beforeMsgId,
                         MSG_msgId,
                         MSG_sqlId,
                         count];
    }
    
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next]) {
        MessageBaseModel *model = [MessageBaseModel sql_initWithResult:result];
        [messageList addObject:model];
    }
    
    return [messageList reverseObjectEnumerator].allObjects;
}

/**
 *  查询消息表里是否有某条消息的（同时匹配fromLoginName和cid）
 *
 *  @param db        db
 *  @param baseModel 消息model
 *
 *  @return 是否存在
 */
+ (BOOL)queryMessageIsExistWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel {
    // 判断是否存此条cid的消息
    BOOL isExist = NO;
    NSString *strMessage = [NSString stringWithFormat:@"select * from '%@' where %@ = '%lld' and %@ = '%@' and %@ = '%lld'",
                            kTableMessage,
                            MSG_clientMsgId, baseModel._clientMsgId,
                            MSG_fromLoginName, baseModel._fromLoginName,
                            MSG_msgId, baseModel._msgId];
    FMResultSet *result = [db executeQuery:strMessage];
    while ([result next])
    {
        isExist = YES;
    }
    return isExist;
}
/**
 *  查询消息表里 的某条消息是否与同步的状态一致
 *
 *  @param db        db
 *  @param baseModel 消息model
 *
 *  @return 是否一致
 */
+ (BOOL)queryMessageIsImportantWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel
{
    BOOL isImportant = NO;
    NSString * strMessage = [NSString stringWithFormat:@"select * from '%@' where %@ = '%lld' and %@ = %@",kTableMessage,MSG_msgId, baseModel._clientMsgId,MSG_markImportant,@(baseModel._markImportant)];
    FMResultSet * result = [db executeQuery:strMessage];
    while ([result next]) {
        isImportant = YES;
    }
    return isImportant;
}
/*
 * 查询某个会话中 ,缓存中的最新的消息是不是数据库中最新的
 * @param tagert 会话唯一标示符 ,会话名称
 * @param 最新消息的msgid
 *
 *  @return 是否最新
 */
+ (BOOL)queryMessageIsNewestWithDB:(FMDatabase *)db Tagert:(NSString *)tagert msgid:(long long)msgid
{
    BOOL isImportant = NO;
    // 普通消息(逆序排列)
    NSString * strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' order by %@ desc ,%@ desc",
                                kTableMessage,
                                MSG_target,tagert,
                                MSG_msgId,
                                MSG_sqlId];
    FMResultSet * result = [db executeQuery:strPickMessge];
    while ([result next]) {
        long long msgID =  [result longLongIntForColumn:MSG_msgId];
        if (msgid == msgID) {
            isImportant = YES;
        }
        break;
    }
    return isImportant;
}

/**
 *  查询联系人/群的所有未读消息
 *
 *  @param db  db
 *  @param uid 对象唯一标识符
 *
 *  @return 纬度消息msgID所在的MessageBaseModel
 */
+ (NSArray *)queryAllUnreadMessageIDWithDB:(FMDatabase *)db uid:(NSString *)uid msgId:(long long)msgId
{
    // 1.遍历Message表去取出
    NSMutableArray *arrMsgID = [NSMutableArray array];
    // 2.(逆序排列)
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' and %@ = 0 and (%@ = '%@' or %@ = '%@') and %@ = '%@' and %@ >= '%lld' order by %@ desc ,%@ desc",
                               kTableMessage,
                               MSG_target,uid,
                               MSG_markReaded,
                               MSG_type,[MessageBaseModel getStringFromMsgType:msg_personal_text],
                               MSG_type,[MessageBaseModel getStringFromMsgType:msg_personal_image],
                               MSG_fromLoginName,uid,
                               MSG_msgId,msgId,
                               MSG_msgId,MSG_sqlId];
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        MessageBaseModel *baseModel = [MessageBaseModel new];
        // 1.得到消息msgId 和 发送人的uid就可以了
        baseModel._msgId = [result longLongIntForColumn:MSG_msgId];
        baseModel._fromLoginName = [result stringForColumn:MSG_fromLoginName];
        baseModel._info = [result stringForColumn:MSG_info];
        if ([baseModel getUserName].length != 0)
        {
            baseModel._target = [baseModel getUserName];
        }
        
        [arrMsgID addObject:baseModel];
    }
    
    // 重新排序
    NSArray *arrTemp = [NSArray arrayWithArray:[[arrMsgID reverseObjectEnumerator] allObjects]];
    return arrTemp;
    
}

/**
 *  从某一条信息开始查找之前的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryOlderMessageHistoryWithDB:(FMDatabase *)db fromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid {
    // 1.遍历Message表去取出
    NSMutableArray *arrMsg = [NSMutableArray array];
    // 2.(逆序排列)
    //    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' and %@ <= '%ld' order by %@ desc ,%@ desc limit '%ld'",
    //                               kTableMessage,
    //                               MSG_target,uid,
    //                               MSG_sqlId,sqlID,
    //                               MSG_msgId,MSG_sqlId,
    //                               count];
    
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' and %@ < %@  order by %@ desc ,%@  limit '20'",
                               kTableMessage,
                               MSG_target,uid,
                               MSG_msgId,@(sqlID),
                               MSG_msgId,
                               MSG_msgId];
    
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        // 1.得到消息对象
        MessageBaseModel *model = [MessageBaseModel sql_initWithResult:result];
        [arrMsg addObject:model];
    }
    
    // 重新排序
    NSArray *arrTemp = [NSArray arrayWithArray:[[arrMsg reverseObjectEnumerator] allObjects]];
    return arrTemp;
    
}

/**
 *  从某一条信息开始查找之后的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryNewerMessageHistoryWithDB:(FMDatabase *)db fromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid {
    // 1.遍历Message表去取出
    NSMutableArray *arrMsg = [NSMutableArray array];
    // 2.(逆序排列)
    //    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' and %@ >= '%ld' order by %@ ,%@ limit '%ld'",
    //                               kTableMessage,
    //                               MSG_target,uid,
    //                               MSG_sqlId,sqlID,
    //                               MSG_msgId,MSG_sqlId,
    //                               count];
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' and %@ > %@  order by %@ ,%@  limit '20'",
                               kTableMessage,
                               MSG_target,uid,
                               MSG_msgId,@(sqlID),
                               MSG_msgId,
                               MSG_msgId];
    
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        // 1.得到消息对象
        MessageBaseModel *model = [MessageBaseModel sql_initWithResult:result];
        [arrMsg addObject:model];
    }
    
    return arrMsg;
    
}
/**
 *  从某一条信息开始查找之后的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryNewerEventMessageHistoryWithDB:(FMDatabase *)db fromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid {
    // 1.遍历Message表去取出
    NSMutableArray *arrMsg = [NSMutableArray array];
    // 2.(逆序排列)
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' and %@ > '%lld' order by %@ asc,%@ asc limit '%ld'",
                               kTableMessage,
                               MSG_target,uid,
                               MSG_createDate,creatDate,
                               MSG_msgId,MSG_sqlId,
                               count];
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        // 1.得到消息对象
        MessageBaseModel *model = [MessageBaseModel sql_initWithResult:result];
        [arrMsg addObject:model];
    }
    // NSArray *arrTemp = [NSArray arrayWithArray:[[arrMsg reverseObjectEnumerator] allObjects]];
    return arrMsg;
    
}
/**
 *  从某一条信息开始查找之前的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryOlderEvevtMessageHistoryWithDB:(FMDatabase *)db fromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid {
    // 1.遍历Message表去取出
    NSMutableArray *arrMsg = [NSMutableArray array];
    // 2.(逆序排列)
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' and %@ < '%lld' order by %@ desc ,%@ desc limit '%ld'",
                               kTableMessage,
                               MSG_target,uid,
                               MSG_createDate,creatDate,
                               MSG_msgId,MSG_sqlId,
                               count];
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        // 1.得到消息对象
        MessageBaseModel *model = [MessageBaseModel sql_initWithResult:result];
        [arrMsg addObject:model];
    }
    
    // 重新排序
    NSArray *arrTemp = [NSArray arrayWithArray:[[arrMsg reverseObjectEnumerator] allObjects]];
    return arrTemp;
    
}

/**
 *  查询此列表中,自己被@的消息
 *
 *  @param target 此聊天(群聊或单聊)的ID
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryAtMeMessageWithDB:(FMDatabase *)db fromTarget:(NSString *)target {
    NSMutableArray *arrMsg = [NSMutableArray array];
    
    NSString *strPickMessage = [NSString stringWithFormat:@"select * from '%@' where %@ like '%%atUsers%%' and %@ = '%@' order by %@ desc, %@ desc",
                                kTableMessage,
                                MSG_info, MSG_target,target,
                                MSG_msgId, MSG_sqlId];
    
    FMResultSet *result = [db executeQuery:strPickMessage];
    while ([result next]) {
        MessageBaseModel *model = [MessageBaseModel sql_initWithResult:result];
        
        NSArray *atUserList = [model atUser];
        
        for (NSString *atUser in atUserList) {
            if ([atUser length] > 3 && [[[atUser substringToIndex:3] uppercaseString] isEqualToString:@"ALL"]) {
                if (![model._fromLoginName isEqualToString:[[MsgUserInfoMgr share] getUid]]) {
                    [arrMsg addObject:model];
                    break;
                }
            }
            
            if ([atUser rangeOfString:[[MsgUserInfoMgr share] getUid]].location != NSNotFound) {
                [arrMsg addObject:model];
                break;
            }
        }
    }
    
    return arrMsg;
}

/**
 *  查询此列表中,所有图片
 *
 *  @param target 此聊天(群聊或单聊)的ID
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryAllImageMessageIDWithDB:(FMDatabase *)db uid:(NSString *)uid
{
    // 1.遍历Message表去取出
    NSMutableArray *arrMsg = [NSMutableArray array];
    
    // 2.(逆序排列)
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = '%@' and %@ = '%@' order by %@ desc ,%@ desc",
                               kTableMessage,
                               MSG_type,[MessageBaseModel getStringFromMsgType:msg_personal_image] ,MSG_target,uid,
                               MSG_msgId,MSG_sqlId];
    
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        // 1.得到消息对象
        MessageBaseModel *model = [MessageBaseModel sql_initWithResult:result];
        [arrMsg addObject:model];
    }
    
    // 重新排序
    NSArray *arrTemp = [NSArray arrayWithArray:[[arrMsg reverseObjectEnumerator] allObjects]];
    return arrTemp;
}

+ (NSArray *)querySearchMessageWithDB:(FMDatabase *)db keyword:(NSString *)keyword {
    return [self querySearchMessageWithDB:db keyword:keyword target:nil];
}

+ (NSArray *)querySearchMessageWithDB:(FMDatabase *)db keyword:(NSString *)keyword target:(NSString *)target {
    NSMutableArray *messages = [NSMutableArray array];
    
    NSString *appendTargetSql = @"";
    if ([target length]) {
        appendTargetSql = [NSString stringWithFormat:@"and %@ = '%@'",MSG_target, target];
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from '%@' where %@ like '%%%@%%' %@ order by %@ desc, %@ desc",kTableMessage, MSG_content, keyword, appendTargetSql,  MSG_msgId, MSG_sqlId];
    FMResultSet *result = [db executeQuery:sql];
    while ([result next]) {
        MessageBaseModel *message = [MessageBaseModel sql_initWithResult:result];
        
        if (message._type == msg_personal_text) {
            [messages addObject:message];
            continue;
        }
        
        if (message._type == msg_personal_file) {
            NSString *fileNmae = message.attachModel.fileName;
            if ([fileNmae rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [messages addObject:message];
            }
            
            continue;
        }
        
        if (![message isEventType]) {
            continue;
        }
        
        // 应用处理
        if ([message.appModel.msgTitle rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [messages addObject:message];
        }
    }
    
    return messages;
}

+ (NSArray *)queryLocalMessagesWithDB:(FMDatabase *)db target:(NSString *)target msg_type:(Msg_type)type {
    NSMutableArray *messages = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"select * from '%@' where %@ = ? and %@ = ? order by %@ desc, %@ desc",kTableMessage, MSG_target, MSG_type, MSG_msgId, MSG_sqlId];

    FMResultSet *result = [db executeQuery:sql, target, [MessageBaseModel getStringFromMsgType:type]];

    while ([result next]) {
        MessageBaseModel *message = [MessageBaseModel sql_initWithResult:result];
        if (message._type == msg_usefulMsgMin) {
            continue;
        }
        
        [messages addObject:message];
    }
    
    return messages;
}

+ (NSArray *)queryLocalImportantMessagesWithDB:(FMDatabase *)db target:(NSString *)target {
    NSMutableArray *messages = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"select * from '%@' where %@ = ? and %@ = 1 order by %@ desc, %@ desc",kTableMessage, MSG_target, MSG_markImportant, MSG_msgId, MSG_sqlId];
    
    FMResultSet *result = [db executeQuery:sql ,target];
    
    while ([result next]) {
        MessageBaseModel *message = [MessageBaseModel sql_initWithResult:result];
        [messages addObject:message];
    }
    return messages;
}

/**
 *  查询此列表中,所有等待发送的图片
 *
 *  @param
 *  @return 查询到的数据数组
 */
+ (NSArray *)queryAllSendingMessageWithDB:(FMDatabase *)db
{
    // 1.遍历Message表去取出
    NSMutableArray *arrMsg = [NSMutableArray array];
    
    // 2.(逆序排列)
    NSString *strPickMessge = [NSString stringWithFormat:@"select * from '%@' where %@ = 0 order by %@ desc ,%@ desc",
                               kTableMessage,
                               MSG_markStatus,
                               MSG_msgId,MSG_sqlId];
    
    FMResultSet *result = [db executeQuery:strPickMessge];
    while ([result next])
    {
        // 1.得到消息对象
        MessageBaseModel *model = [MessageBaseModel sql_initWithResult:result];
        [arrMsg addObject:model];
    }
    
    // 重新排序
    NSArray *arrTemp = [NSArray arrayWithArray:[[arrMsg reverseObjectEnumerator] allObjects]];
    return arrTemp;
    
}

#pragma mark - Delete

/**
 *  删除一条信息
 *
 *  @param db        db
 *  @param baseModel 待删model数据
 */
+ (void)deleteMessageWithDB:(FMDatabase *)db baseModel:(MessageBaseModel *)baseModel {
    NSString *sqlMsg = [NSString stringWithFormat:@"delete from '%@' where %@ = '%lld' and %@ = ?",
                        kTableMessage,
                        MSG_clientMsgId,baseModel._clientMsgId,
                        MSG_fromLoginName];
    PRINT_STRING(sqlMsg);
    // 删除数据
    if (![db executeUpdate:sqlMsg, baseModel._fromLoginName])
    {
        NSAssert(0, @"删除消息数据失败");
    }
}

/**
 *  清理某个对象的消息内容
 *
 *  @param db  db
 *  @param uid 对象标识符
 */
+ (void)deleteMessageRecordsWithDB:(FMDatabase *)db uid:(NSString *)uid {
    NSString *sql = [NSString stringWithFormat:@"delete from '%@' where %@ = '%@'",
                     kTableMessage,
                     MSG_target,uid];
    // 删除数据
    if (![db executeUpdate:sql])
    {
        NSAssert(0, @"删除对象消息表数据失败");
    }
    
}

/**
 *  删除表
 *
 */
+ (void)deleteMessageTableWithDB:(FMDatabase *)db {
    NSString *sql = [NSString stringWithFormat:@"delete from '%@'",kTableMessage];
    // 删除数据
    if (![db executeUpdate:sql])
    {
        NSAssert(0, @"删除消息表失败");
    }
    
}
@end
