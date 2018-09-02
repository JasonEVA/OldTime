//
//  ApplyGetReceiveListRequest.m
//  launcher
//
//  Created by Dee on 15/9/6.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyGetReceiveListRequest.h"
#import "ApplyGetReceiveListModel.h"
static NSString *const A_Type = @"A_TYPE";

@implementation ApplyGetReceiveListRequest

- (NSString *)api
{
   return @"/Approve-Module/Approve/GetApproveReceiveList";
}

- (NSString *)type
{
    return @"GET";
}

- (void)getReceiveListWith:(NSString *)type
{
    self.params[A_Type] = type;//这里是否还要防空
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyGetReceiveListResponse *response = [[ApplyGetReceiveListResponse alloc] init];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if ([data isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dict in data)
        {
            ApplyGetReceiveListModel *tmodel = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
            [tempArr addObject:tmodel];
        }
    }
    response.modelArr = tempArr;
    return response;
}

@end

@implementation ApplyGetReceiveListResponse


@end
