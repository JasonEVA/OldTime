//
//  UpDateCommmentRequest.m
//  launcher
//
//  Created by jasonwang on 16/2/26.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "UpDateCommmentRequest.h"
#import "NSDictionary+SafeManager.h"
@implementation UpDateCommmentResponse
@end

@implementation UpDateCommmentRequest

- (void)updateWithshowID:(NSString *)showID isComment:(NSString *)isComment
{
    self.params[@"showId"] = showID;
    self.params[@"tIsComment"] = isComment;
    [self requestData];
}


- (NSString *)api { return @"/Task-Module/TaskV2/TaskPostComment";}
- (NSString *)type { return @"POST";}

- (BaseResponse *)prepareResponse:(id)data {
    UpDateCommmentResponse *response = [UpDateCommmentResponse new];
    
    response.isSuccess = [[data valueStringForKey:@"isSuccess"] intValue];
    
    return response;
}
@end
