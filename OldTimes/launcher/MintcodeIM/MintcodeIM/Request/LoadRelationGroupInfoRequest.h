//
//  LoadRelationGroupInfoRequest.h
//  MintcodeIM
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  增量获取好友

#import "IMBaseBlockRequest.h"

@interface LoadRelationGroupInfoRequest : IMBaseBlockRequest

//+ (void)loadRelationGroupInfoWithMsgId:(long long)msgId Completion:(IMBaseResponseCompletion)completion; DEPRECATED_ATTRIBUTE

+ (void)loadRelationGroupInfoWithMsgId:(long long)msgId isTotal:(BOOL)istotal Completion:(IMBaseResponseCompletion)completion;

@end

@interface LoadRelationGroupInfoResponse : IMBaseResponse
/*默认好友分组*/
@property (nonatomic,assign) long  defineRelationGroupId;
/*好友列表*/
@property (nonatomic,strong) NSMutableArray * relations;
/*删除的好友*/
@property (nonatomic,strong) NSArray * remvoeRelations;
/*删除的分组*/
@property (nonatomic,strong) NSArray * removeRelationGroups ;
/*分组列表*/
@property (nonatomic,strong) NSMutableArray * relationGroups ;

@end