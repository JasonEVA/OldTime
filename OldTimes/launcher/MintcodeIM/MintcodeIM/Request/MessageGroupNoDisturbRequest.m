//
//  MessageGroupNoDisturbRequest.m
//  launcher
//
//  Created by williamzhang on 15/12/3.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MessageGroupNoDisturbRequest.h"

@implementation MessageGroupNoDisturbRequest

- (NSString *)action { return @"/messageTroubleFree";}

+ (void)noDisturbSessionName:(NSString *)sessionName receiveMode:(NSInteger)receiveMode completion:(IMBaseResponseCompletion)completion {
    MessageGroupNoDisturbRequest *request = [[MessageGroupNoDisturbRequest alloc] init];
    request.params[@"sessionName"] = sessionName ?: @"";
    request.params[@"receiveMode"] = @(receiveMode);
    
    [request requestDataCompletion:completion];
}

@end
