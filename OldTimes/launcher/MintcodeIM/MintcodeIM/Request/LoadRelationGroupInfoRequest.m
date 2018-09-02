//
//  LoadRelationGroupInfoRequest.m
//  MintcodeIM
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "LoadRelationGroupInfoRequest.h"
#import "MessageRelationGroupModel.h"
#import "MessageRelationInfoModel.h"
#import "NSDictionary+IMSafeManager.h"
#import "MsgUserInfoMgr.h"
@interface LoadRelationGroupInfoRequest ()

@property (nonatomic,assign) long long msgId;

@end

@implementation LoadRelationGroupInfoRequest

- (NSString *)action { return @"/loadRelationGroupInfo";}

//+ (void)loadRelationGroupInfoWithMsgId:(long long)msgId isTotal:(BOOL)total Completion:(IMBaseResponseCompletion)completion
//{
//    [self]
//}

+ (void)loadRelationGroupInfoWithMsgId:(long long)msgId isTotal:(BOOL)istotal Completion:(IMBaseResponseCompletion)completion
{
    LoadRelationGroupInfoRequest * request = [[LoadRelationGroupInfoRequest alloc] init];
    
    request.msgId = msgId;
    
    [request.params setValue:@(msgId) forKey:@"msgId"];
    [request.params setValue:@(istotal) forKey:@"totalFlag"];
    [request requestDataCompletion:completion];
}

+ (void)loadRelationGroupInfoWithMsgId:(long long)msgId  Completion:(IMBaseResponseCompletion)completion
{
    LoadRelationGroupInfoRequest * request = [[LoadRelationGroupInfoRequest alloc] init];
    
    request.msgId = msgId;

    [request.params setValue:@(msgId) forKey:@"msgId"];
    [request requestDataCompletion:completion];
}  

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    
    NSDictionary *subdate = [data objectForKey:@"data"];
    LoadRelationGroupInfoResponse * response = [LoadRelationGroupInfoResponse new];
    response.defineRelationGroupId = -1;
    
    //原先是本地在接受到消息后本地存一个本地的时间戳。现改为直接存服务器返回的时间戳
    long long modify = [[data im_valueNumberForKey:@"modify"] longLongValue];
    [[MsgUserInfoMgr share] setLoadRelationGroupInfoTimeInterval:modify?:0];
    
    NSArray * remvoeRelations = [subdate im_valueArrayForKey:@"removeRelations"];
    response.remvoeRelations = [NSArray arrayWithArray:remvoeRelations];
    
    NSArray * removeRelationGroups = [subdate im_valueArrayForKey:@"removeRelationGroups"];
    response.removeRelationGroups = [NSArray arrayWithArray:removeRelationGroups];
    
    NSArray * relations  = [subdate im_valueArrayForKey:@"relations"];
    response.relations = [NSMutableArray array];
    if (relations) {
        for (int i= 0; i < relations.count; i ++) {
            MessageRelationInfoModel * model = [MessageRelationInfoModel modelWithDict:[relations objectAtIndex:i]];
            [response.relations addObject:model];
        }
    }
    
    NSArray * relationGroups = [data im_valueArrayForKey:@"relationGroups"];
    response.relationGroups = [NSMutableArray array];
    if (relationGroups) {
        for (NSInteger i = 0; i < relationGroups.count; i ++) {
            MessageRelationGroupModel * model = [MessageRelationGroupModel modelWithDict:[relationGroups objectAtIndex:i]];
            [response.relationGroups addObject:model];
            if (self.msgId == 0 && i == 0) {
                response.defineRelationGroupId = model.relationGroupId;
                model.isDefault = YES;
            }
        }
    }
    
    return response;
}

@end

@implementation LoadRelationGroupInfoResponse


@end