//
//  RemarkRelationRequest.m
//  MintcodeIM
//
//  Created by TabLiu on 16/3/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "RemarkRelationRequest.h"

@implementation RemarkRelationRequest

- (NSString *)action { return @"/remarkRelation"; }

+ (void)remarkRelationWithUid:(NSString *)relationName remark:(NSString *)remark completion:(void (^)(BOOL isSuccess))completion
{
    RemarkRelationRequest * request = [[RemarkRelationRequest alloc] init];
    [request.params setValue:relationName forKey:@"relationName"];
    [request.params setValue:remark forKey:@"remark"];
    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        if (completion) {
            completion(success);
        }
    }];
}

@end
