//
//  MessageGroupNoDisturbRequest.m
//  launcher
//
//  Created by williamzhang on 15/12/3.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MessageGroupNoDisturbRequest.h"

@implementation MessageGroupNoDisturbRequest

- (NSString *)action { return @"/api/messageTroubleFree";}

- (void)noDisturbSessionName:(NSString *)sessionName receiveMode:(NSInteger)receiveMode {
    self.params[@"sessionName"] = sessionName ?: @"";
    self.params[@"receiveMode"] = @(receiveMode);
}

@end
