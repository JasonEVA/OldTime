//
//  RemoveSessionRequest.m
//  launcher
//
//  Created by williamzhang on 15/12/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "RemoveSessionRequest.h"

@implementation RemoveSessionRequest

- (NSString *)action { return @"/removesession";}

+ (void)removeSessionName:(NSString *)sessionName completion:(IMBaseResponseCompletion)completion {
    RemoveSessionRequest *request = [[RemoveSessionRequest alloc] init];
    request.params[@"sessionName"] = sessionName;
    [request requestDataCompletion:completion];
}

@end
