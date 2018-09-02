//
//  AddRelationValidateRequest.m
//  MintcodeIM
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "AddRelationValidateRequest.h"
#import "MsgUserInfoMgr.h"

static NSString * const from            = @"from";
static NSString * const fromNickName    = @"fromNickName";
static NSString * const fromAvatar      = @"fromAvatar";
static NSString * const to              = @"to";
static NSString * const remark          = @"remark";
static NSString * const content         = @"content";
static NSString * const relationGroupId = @"relationGroupId";

@implementation AddRelationValidateRequest

- (NSString *)action { return @"/addRelationValidate"; }

+ (void)addRelationValidateRequestTo:(NSString *)toUid
                              remark:(NSString *)remark
                             content:(NSString *)content
                     relationGroupId:(long)relationGroupId
                          completion:(IMBaseResponseCompletion)completion
{
    AddRelationValidateRequest *request = [[AddRelationValidateRequest alloc] init];
    
    request.params[@"to"]              = toUid;
    request.params[@"from"]            = [[MsgUserInfoMgr share] getUid];
    request.params[@"remark"]          = remark;
    request.params[@"content"]         = content;
    if (relationGroupId != -1) {
        request.params[@"relationGroupId"] = @(relationGroupId);
    }
    
    [request requestDataCompletion:completion];
}


@end
