//
//  ApplicationGetAppInfoRequest.m
//  launcher
//
//  Created by 马晓波 on 16/3/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ApplicationGetAppInfoRequest.h"
#import "ApplicationAppInfoModel.h"

@implementation ApplicationGetAppInfoResponse
- (NSMutableArray *)arrAppModels
{
    if (!_arrAppModels)
    {
        _arrAppModels = [[NSMutableArray alloc] init];
    }
    return _arrAppModels;
}

@end


@implementation ApplicationGetAppInfoRequest
- (void)GetInfo
{
    [self requestData];;
}

- (NSString *)type
{
    return @"GET";
}
- (NSString *)api
{
    return @"/Base-Module/App/GetCompanyApp";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplicationGetAppInfoResponse *response = [[ApplicationGetAppInfoResponse alloc] init];
    [response.arrAppModels removeAllObjects];
    for (NSDictionary *dict in data)
    {
        ApplicationAppInfoModel *model = [ApplicationAppInfoModel mj_objectWithKeyValues:dict];
        [response.arrAppModels addObject:model];
    }
    return response;
}
@end
