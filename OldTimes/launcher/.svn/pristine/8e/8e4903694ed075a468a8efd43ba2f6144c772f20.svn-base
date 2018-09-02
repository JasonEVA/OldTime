//
//  RelationGroupInfoRequest.m
//  MintcodeIM
//
//  Created by kylehe on 16/3/29.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "RelationGroupInfoRequest.h"
#import "MessageRelationGroupModel.h"
@implementation RelationGroupInfoRequest
- (NSString *)action
{
    return @"/relationGroupList";
}

+ (void)RelationGroupInfoRequestWithCompletion:(IMBaseResponseCompletion)completion
{
    RelationGroupInfoRequest *request = [[RelationGroupInfoRequest alloc] init];
    [request requestDataCompletion:completion];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    RelationGroupInfoResponse *response = [RelationGroupInfoResponse new];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in [data objectForKey:@"data"])
    {
        MessageRelationGroupModel *model = [MessageRelationGroupModel modelWithDict:dict];
        [array addObject:model];
    }
    response.dataArray = array;
    return response;
}


@end

@implementation RelationGroupInfoResponse


@end