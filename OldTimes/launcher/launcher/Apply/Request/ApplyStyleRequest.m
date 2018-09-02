//
//  ApplyStyleRequest.m
//  launcher
//
//  Created by conanma on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplyStyleRequest.h"

@implementation ApplyStyleRequest

- (void)getInfo
{
    [self requestData];
}

- (NSString *)api
{
    return @"/Approve-Module/Approve/GetApproveTypeList";
}

- (NSString *)type
{
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyStyleResponse *response = [[ApplyStyleResponse alloc] init];
    
    if (data)
    {
        for (NSInteger i = 0; i<((NSArray *)data).count; i++)
        {
            NSDictionary *dict = [((NSArray *)data) objectAtIndex:i];
            ApplyStyleModel *model = [[ApplyStyleModel alloc] initWithDict:dict];
            [response.arrrTitles addObject:model];
        }
    }
    return response;
    
}
@end

@implementation ApplyStyleResponse

- (NSMutableArray *)arrrTitles
{
    if (!_arrrTitles)
    {
        _arrrTitles = [[NSMutableArray alloc] init];
    }
    return _arrrTitles;
}

@end
