//
//  NewProjectDeleteRequest.m
//  launcher
//
//  Created by TabLiu on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewProjectDeleteRequest.h"

@implementation NewProjectDeleteRequest
- (NSString *)api { return @"/Task-Module/TaskV2/ProjectDelete";}
- (NSString *)type { return @"DELETE";}

- (void)requestData
{
    [self.params setValue:_showId forKey:@"showId"];
    [super requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    NewProjectDeleteResponse *response = [NewProjectDeleteResponse new];
    
        return response;
}

@end

@implementation NewProjectDeleteResponse

@end