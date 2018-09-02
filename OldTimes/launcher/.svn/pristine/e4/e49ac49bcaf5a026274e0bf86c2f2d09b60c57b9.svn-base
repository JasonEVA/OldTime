//
//  DeleteRelationRequest.m
//  MintcodeIM
//
//  Created by TabLiu on 16/3/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "DeleteRelationRequest.h"

@implementation DeleteRelationRequest

- (NSString *)action { return @"/deleteRelation"; }

+ (void)deleteRelationWithUid:(NSString *)uid completion:(void (^)(BOOL isSuccess))completion
{
    DeleteRelationRequest * request = [[DeleteRelationRequest alloc] init];
    [request.params setValue:uid forKey:@"to"];
    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        if (completion) {
            completion(success);
        }
    }];
}

@end
