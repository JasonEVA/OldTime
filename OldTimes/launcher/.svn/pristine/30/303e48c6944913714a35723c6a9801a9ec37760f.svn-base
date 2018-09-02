//
//  NewApplyDetailV2Reqeust.m
//  launcher
//
//  Created by williamzhang on 16/4/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyDetailV2Request.h"

@implementation NewApplyDetailV2Request

- (NSString *)api  { return @"/Approve-Module/Approve/GetV2"; }
- (NSString *)type { return @"GET"; }

- (void)detailWithShowId:(NSString *)showId {
    self.params[@"showId"] = showId;
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    NewApplyDetailV2Response *response = [NewApplyDetailV2Response new];
    
    response.infomodel = [[ApplyDetailInformationModel alloc] initWithDictEdit:data];
    
    return response;
}

@end

@implementation NewApplyDetailV2Response
@end