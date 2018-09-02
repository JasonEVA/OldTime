//
//  DisposeRelationValidateRequest.m
//  MintcodeIM
//
//  Created by TabLiu on 16/3/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "DisposeRelationValidateRequest.h"
#import "MsgUserInfoMgr.h"

@implementation DisposeRelationValidateRequest

- (NSString *)action { return @"/disposeRelationValidate"; }

+ (void)dealRelationWithModel:(MessageRelationValidateModel *)model validateState:(NSInteger)state relationGroupId:(long)relationGroupId remark:(NSString *)remark content:(NSString *)content completion:(IMBaseResponseCompletion)completion
{
    DisposeRelationValidateRequest *request = [[DisposeRelationValidateRequest alloc] init];
    
    request.params[@"from"]       = model.from;
    request.params[@"fromAvatar"] = model.fromAvatar;
    request.params[@"to"]         = [[MsgUserInfoMgr share] getUid];
    request.params[@"validateState"] = @(state);
    
    request.params[@"relationGroupId"] = @(relationGroupId);
    
    request.params[@"remark"] = remark;
    request.params[@"content"] = content;
    [request requestDataCompletion:completion];
}

@end
