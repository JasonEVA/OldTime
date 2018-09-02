//
//  SearchRelationUserRequest.m
//  MintcodeIM
//
//  Created by TabLiu on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "SearchRelationUserRequest.h"
#import "MessageRelationInfoModel.h"
@implementation SearchRelationUserRequest

- (NSString *)action { return @"/searchRelationUser";}

+ (void)searchRelationUserWithString:(NSString *)string completion:(IMBaseResponseCompletion)completion
{
    SearchRelationUserRequest * request = [[SearchRelationUserRequest alloc] init];
    [request.params setValue:string forKey:@"relationValue"];
    [request requestDataCompletion:completion];
}
- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    SearchRelationUserResponse * response = [SearchRelationUserResponse new];
    response.dataArray = [NSMutableArray array];
    NSArray * array = [data objectForKey:@"data"];
    if (array) {
        for (int i = 0; i < array.count; i ++) {
            MessageRelationInfoModel * model = [MessageRelationInfoModel modelWithDict:array[i]];
            [response.dataArray addObject:model];
        }
    }
    return response;
}

@end

@implementation SearchRelationUserResponse

@end