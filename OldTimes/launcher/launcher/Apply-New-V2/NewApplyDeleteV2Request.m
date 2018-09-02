//
//  NewApplyDeleteV2Request.m
//  launcher
//
//  Created by williamzhang on 16/4/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyDeleteV2Request.h"

@implementation NewApplyDeleteV2Request

- (void)ApplyDeleteRequestWithShowId:(NSString *)showID {
    self.params[@"showId"] = showID;
    [self requestData];
}

- (NSString *)api { return @"/Approve-Module/Approve/DeleteV2"; }
- (NSString *)type { return @"DELETE"; }

@end
