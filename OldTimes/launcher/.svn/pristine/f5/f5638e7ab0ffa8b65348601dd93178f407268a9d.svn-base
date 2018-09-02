//
//  GetSuperGroupListRequest.m
//  MintcodeIM
//
//  Created by Dee on 16/6/27.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "GetSuperGroupListRequest.h"
#import "SuperGroupListModel.h"

@implementation GetSuperGroupListRequest

- (NSString *)action
{
    return @"/superGroupList";
}

+ (void)GetSuperGroupListFromChache:(BOOL)isfromchache Completion:(IMBaseResponseCompletion)completion
{
    GetSuperGroupListRequest *request = [[GetSuperGroupListRequest alloc] init];
    [request requestDataCompletion:completion isFromeCache:isfromchache];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    GetSuperGroupListResponse *response = [GetSuperGroupListResponse new];
    NSArray *array = [data valueForKey:@"data"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in array)
    {
        SuperGroupListModel *model = [[SuperGroupListModel alloc] initWithDict:dict];
        [tempArray addObject:model];
    }
    response.modelArray = tempArray;
    return response;
}
@end

@implementation GetSuperGroupListResponse


@end