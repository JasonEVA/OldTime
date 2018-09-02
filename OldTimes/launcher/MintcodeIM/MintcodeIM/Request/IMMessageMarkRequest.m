//
//  IMMessageMarkRequest.m
//  MintcodeIM
//
//  Created by williamzhang on 16/3/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMMessageMarkRequest.h"
#import "MessageBaseModel+SQLUtil.h"

@interface IMMessageMarkRequest ()

/// 标记重点还是取消重点
@property (nonatomic, assign) BOOL isMark;

@end

@implementation IMMessageMarkRequest

- (NSString *)action {
    return self.isMark ? @"/addbookmark" : @"/deletebookmark";
}

+ (void)markMessageModel:(MessageBaseModel *)model completion:(IMBaseResponseCompletion)completion {
    IMMessageMarkRequest *request = [[IMMessageMarkRequest alloc] init];
    request.params[@"msgId"] = [NSNumber numberWithLongLong:model._msgId];
    request.params[@"sessionName"] = model._target;
    request.isMark = !model._markImportant;
    
    [request requestDataCompletion:completion];
}

@end
