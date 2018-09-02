//
//  ApplySearchRequest.m
//  launcher
//
//  Created by Conan Ma on 15/9/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplySearchRequest.h"

@implementation ApplySearchResponse

- (NSMutableArray *)arrResultApproveList
{
    if (!_arrResultApproveList)
    {
        _arrResultApproveList = [[NSMutableArray alloc] init];
    }
    return _arrResultApproveList;
}

- (NSMutableArray *)arrResultTitleList
{
    if (!_arrResultTitleList)
    {
        _arrResultTitleList = [[NSMutableArray alloc] init];
    }
    return _arrResultTitleList;
}
@end

static NSString *const A_KEYWORD = @"A_KEYWORD";

@implementation ApplySearchRequest
- (void)GetKeyWord:(NSString *)Keywords
{
    self.params[A_KEYWORD] = Keywords;
    [self requestData];
}

- (NSString *)api
{
    return @"/Approve-Module/Approve/ApproveSearch";
}

- (NSString *)type
{
    return @"GET";
}

-(BaseResponse *)prepareResponse:(id)data
{
    ApplySearchResponse *response = [[ApplySearchResponse alloc] init];
    
    [response.arrResultTitleList addObjectsFromArray:[((NSDictionary *)data) valueForKey:@"ResultTitleList"]];
    [response.arrResultApproveList addObjectsFromArray:[((NSDictionary *)data) valueForKey:@"ResultApproveList"]];
    return response;
}
@end
