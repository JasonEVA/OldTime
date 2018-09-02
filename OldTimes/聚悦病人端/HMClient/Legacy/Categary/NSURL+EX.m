//
//  NSURL+EX.m
//  HMClient
//
//  Created by Andrew Shen on 2016/10/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NSURL+EX.h"

@implementation NSURL (EX)

// 将query转为dict
- (NSDictionary *)ats_convertURLQueryToDictionary {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *query = self.query;
    if (query.length && [query rangeOfString:@"="].location != NSNotFound) {
        NSArray *keyValuePairs = [query componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in keyValuePairs) {
            NSArray *pair = [keyValuePair componentsSeparatedByString:@"="];
            // don't assume we actually got a real key=value pair. start by assuming we only got @[key] before checking count
            NSString *paramValue = pair.count == 2 ? pair[1] : @"";
            // CFURLCreateStringByReplacingPercentEscapesUsingEncoding may return NULL
            parameters[pair[0]] = paramValue ?: @"";
        }
    }
    return parameters;
}

@end
