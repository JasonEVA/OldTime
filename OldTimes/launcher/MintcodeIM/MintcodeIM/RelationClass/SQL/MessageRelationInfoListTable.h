//
//  MessageRelationInfoListTable.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class MessageRelationInfoModel;

@interface MessageRelationInfoListTable : NSObject

+ (BOOL)createTableWithDB:(FMDatabase *)db;

@end

@interface MessageRelationInfoListTable (Insert)

+ (void)insertRelationInfoList:(NSArray <MessageRelationInfoModel *>*)relationInfoList toDB:(FMDatabase *)db;

@end

@interface MessageRelationInfoListTable (Update)

+ (BOOL)updateRelationInfo:(MessageRelationInfoModel *)relationInfo toDB:(FMDatabase *)db;

@end

@interface MessageRelationInfoListTable (Delete)

+ (void)deleteRelationInfoUid:(NSString *)uid toDB:(FMDatabase *)db;

@end

@interface MessageRelationInfoListTable (Load)

+ (NSArray <MessageRelationInfoModel *>*)loadRelationGroupId:(long)relationGroupId fromDB:(FMDatabase *)db;

+ (BOOL)loadRelationGroupId:(long)relationGroupId relationName:(NSString *)relationName fromDB:(FMDatabase *)db;

+ (MessageRelationInfoModel *)loadRelationName:(NSString *)relationName fromDB:(FMDatabase *)db;
//好友搜索
+ (NSArray<MessageRelationInfoModel *> *)loadNickName:(NSString *)nickName remark:(NSString *)remark fromDB:(FMDatabase *)db ;

@end