//
//  MessageRecallTable.h
//  launcher
//
//  Created by williamzhang on 16/1/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  消息回撤表

#import <Foundation/Foundation.h>

extern NSString *const kRecallTable;

@class FMDatabase;
@class MessageBaseModel;

/**
 *  仅供MessageTable使用，不建议其他类直接使用
 */
@interface MessageRecallTable : NSObject

+ (void)createRecallTableWithDB:(FMDatabase *)db;

@end

@interface MessageRecallTable (Insert)

+ (BOOL)writeMessageWithDB:(FMDatabase *)db data:(MessageBaseModel *)model;

@end

@interface MessageRecallTable (Query)

/**
 *  获取撤回的原始数据,然后从本表中删除掉
 *
 *  @param model 待比较的model，取出msgId比model大的所有数据
 *
 *  @return [MessageBaseModel]
 */
+ (NSArray *)queryRecallMessageWithDB:(FMDatabase *)db compareData:(MessageBaseModel *)model;

@end