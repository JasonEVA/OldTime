//
//  NewGetTaskListCountRequest.m
//  launcher
//
//  Created by TabLiu on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewGetTaskListCountRequest.h"

@implementation NewGetTaskListCountRequest

- (void)getList {
    long long time = [[NSDate date] timeIntervalSince1970]* 1000;
    [self.params setValue:@(time) forKey:@"Time"];
    [self requestData];
}

- (NSString *)api { return @"/Task-Module/TaskV2/GetTaskListCount";}
- (NSString *)type { return @"GET";}
- (BaseResponse *)prepareResponse:(id)data {
    NewGetTaskListCountResponse * response = [NewGetTaskListCountResponse new];
    response.dataArray = [NSMutableArray new];
    for (NSDictionary * dic in data) {
        TaskCountModel * model = [[TaskCountModel alloc] initWithDictionary:dic];
        [response.dataArray addObject:model];
    }
    [response.dataArray exchangeObjectAtIndex:2 withObjectAtIndex:3];//顺序居然是反的 -- fk
    return response;
}

@end

@implementation NewGetTaskListCountResponse



@end
