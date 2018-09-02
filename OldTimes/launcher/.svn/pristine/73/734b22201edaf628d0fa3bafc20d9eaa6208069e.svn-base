//
//  ApplyStyleKeyRequest.m
//  launcher
//
//  Created by conanma on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplyStyleKeyRequest.h"

static NSString *const t_showid = @"T_SHOW_ID";

@implementation ApplyStyleKeyRequest
- (void)getShowID:(NSString *)showid
{
    self.params[t_showid] = showid;
    [self requestData];
}

- (NSString *)api {
    return @"/Approve-Module/Approve/GetApproveTypeField";
}

- (NSString *)type {
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyStyleKeyResponse *response = [[ApplyStyleKeyResponse alloc] init];
    
    if (data)
    {
        for (NSInteger i = 0; i<((NSArray *)data).count; i++)
        {
            NSDictionary *dict = [((NSArray *)data) objectAtIndex:i];
            ApplyStyleKeyWordModel *model = [[ApplyStyleKeyWordModel alloc] initWithDict:dict];
            [response.arrModels addObject:model];
        }
    }
    return response;
}
@end

@implementation ApplyStyleKeyResponse

- (NSMutableArray *)arrModels
{
    if (!_arrModels)
    {
        _arrModels = [[NSMutableArray alloc] init];
    }
    return _arrModels;
}

@end
