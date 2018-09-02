//
//  NewApplyGetApproveListV2Reqeust.m
//  launcher
//
//  Created by williamzhang on 16/4/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyGetApproveListV2Request.h"

@implementation NewApplyGetApproveListV2Request

- (NSString *)api  { return @"/Approve-Module/Approve/GetApproveListV2"; }
- (NSString *)type { return @"GET"; }

- (void)listWithKeyword:(NSString *)keyword {
    self.params[@"aKeyword"] = keyword;
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    NewApplyGetApproveListV2Response *response = [NewApplyGetApproveListV2Response new];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dict in data) {
        if (!dict) {
            continue;
        }
        
        ApplyGetReceiveListModel *model = [[ApplyGetReceiveListModel alloc] initWithDict:dict];
        [array addObject:model];
    }
    
    response.modelLists = array;
    return response;
}

@end

@implementation NewApplyGetApproveListV2Response
@end