//
//  GetFriendInfolistRequest.m
//  MintcodeIM
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "GetFriendInfolistRequest.h"
#import "MessageRelationGroupModel.h"


@implementation GetFriendInfolistRequest

- (NSString *)action { return @"/relationGroupInfoList";}

+ (void)getFriendListRequestCompletion:(IMBaseResponseCompletion)completion
{
    GetFriendInfolistRequest *request = [[GetFriendInfolistRequest alloc] init];
    [request requestDataCompletion:completion];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    GetFriendInfolistResponse * response  = [GetFriendInfolistResponse new];
    response.dataArray = [NSMutableArray array];
    NSArray * dataArray = [data objectForKey:@"data"];
    
    if (dataArray) {
        for (int i = 0; i < dataArray.count; i ++) {
            MessageRelationGroupModel * model = [MessageRelationGroupModel modelWithDict:dataArray[i]];
            [response.dataArray addObject:model];
        }
    }
    return response;
}

@end

@implementation GetFriendInfolistResponse



@end