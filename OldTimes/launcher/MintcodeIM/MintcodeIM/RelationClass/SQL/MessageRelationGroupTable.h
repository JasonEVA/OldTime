//
//  MessageRelationGroupTable.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  好友分组

#import <Foundation/Foundation.h>

@class FMDatabase;
@class MessageRelationGroupModel;

@interface MessageRelationGroupTable : NSObject

+ (BOOL)createTableWithDB:(FMDatabase *)db;

@end

@interface MessageRelationGroupTable (Insert)

+ (void)insertRelationGroups:(NSArray <MessageRelationGroupModel *>*)relationGroups toDB:(FMDatabase *)db;

@end

@interface MessageRelationGroupTable (Update)

+ (BOOL)updateRelationGroup:(MessageRelationGroupModel *)relationGroup toDB:(FMDatabase *)db;

@end

@interface MessageRelationGroupTable (Delete)

+ (void)deleteRelationGroupId:(long)groupId toDB:(FMDatabase *)db;

@end

@interface MessageRelationGroupTable (Load)

+ (NSArray <MessageRelationGroupModel *> *)loadRelationGroupsFromDB:(FMDatabase *)db;

+ (MessageRelationGroupModel *)loadDefaultGroupFromDB:(FMDatabase *)db;

@end