//
//  RelationValidateListRequest.m
//  MintcodeIM
//∫
//  Created by williamzhang on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "RelationValidateListRequest.h"
#import "MessageRelationValidateModel.h"
#import "NSDictionary+IMSafeManager.h"

@implementation RelationValidateListRequest

- (NSString *)action { return @"/relationValidateList"; }

+ (void)validateListWithUserCompletion:(IMBaseResponseCompletion)completion {
    RelationValidateListRequest *request = [[RelationValidateListRequest alloc] init];
    [request.params setValue:@(10) forKey:@"limit"];
    [request.params setValue:@(0) forKey:@"startTimestamp"];
    [request requestDataCompletion:completion];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data {
    RelationValidateListResponse *response = [RelationValidateListResponse new];

    NSArray *validates = [data im_valueArrayForKey:@"data"];
    
    NSMutableArray *validateModels = [NSMutableArray array];
    
    for (NSDictionary *validateDict in validates) {
        if (!validateDict) continue;

        MessageRelationValidateModel *model = [MessageRelationValidateModel modelWithDict:validateDict];
        [validateModels addObject:model];
    }

    response.array = validateModels;
    return response;
}

@end

@implementation RelationValidateListResponse
@end