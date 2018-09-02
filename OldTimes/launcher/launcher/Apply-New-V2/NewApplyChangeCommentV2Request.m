//
//  NewApplyChangeCommentV2Request.m
//  launcher
//
//  Created by williamzhang on 16/4/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplyChangeCommentV2Request.h"

@implementation NewApplyChangeCommentV2Request

+ (instancetype)changeCommentShowId:(NSString *)showId {
    NewApplyChangeCommentV2Request *request = [[NewApplyChangeCommentV2Request alloc] init];
    
    request.params[@"showId"] = showId;
    request.params[@"hasComment"] = @1;
    [request requestData];
    
    return request;
}

- (NSString *)api { return @"/Approve-Module/Approve/PostCommentV2"; }

@end
