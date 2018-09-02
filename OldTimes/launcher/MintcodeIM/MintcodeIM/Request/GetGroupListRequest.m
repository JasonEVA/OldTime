//
//  GetGroupListRequest.m
//  MintcodeIM
//
//  Created by williamzhang on 16/5/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "GetGroupListRequest.h"
#import "UserProfileModel+Private.h"
#import "NSDictionary+IMSafeManager.h"

@implementation GetGroupListRequest

- (NSString *)action { return @"/grouplist"; }

- (NSInteger)cacheTimeInSeconds {
    return 60 * 2;
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data {
    GetGroupListResponse *response = [GetGroupListResponse new];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *groupJsonDict = [data im_valueArrayForKey:@"data"];
    
    for (NSDictionary *groupDict in groupJsonDict) {
        UserProfileModel *group = [[UserProfileModel alloc] initWithDict:groupDict];
        [array addObject:group];
    }
    
    response.groupList = [array copy];
    return response;
}

@end

@implementation GetGroupListResponse
@end
