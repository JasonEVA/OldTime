//
//  NSString+URLEncod.m
//  HMDoctor
//
//  Created by jasonwang on 2016/10/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NSString+URLEncod.h"

@implementation NSString (URLEncod)

- (NSDictionary *)analysisParameter {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSURL *url = [NSURL URLWithString:self];
    NSString *str = url.query;
    if (str.length && [str rangeOfString:@"="].location != NSNotFound) {
        NSArray *keyValuePairs = [str componentsSeparatedByString:@"&"];
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
