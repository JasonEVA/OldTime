//
//  NewDeleteTaskRequest.m
//  launcher
//
//  Created by TabLiu on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//


#import "NewDeleteTaskRequest.h"

@implementation NewDeleteTaskRequest

- (void)requestData
{
    [self.params setValue:_showId forKey:@"showId"];
    [super requestData];
}

- (NSString *)api { return @"/Task-Module/TaskV2/TaskDelete";}
- (NSString *)type { return @"DELETE";}
- (BaseResponse *)prepareResponse:(id)data {
    NewDeleteTaskResponse *response = [NewDeleteTaskResponse new];
    return response;
}



@end

@implementation NewDeleteTaskResponse

@end