//
//  NSURL+QueryToDictionary.m
//  HMClient
//
//  Created by yinquan on 16/10/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NSURL+QueryToDictionary.h"

@implementation NSURL (QueryToDictionary)

- (NSDictionary*) dictionaryWithQuery
{
    NSString* query = self.query;
    if (!query || 0 == query.length)
    {
        //没有Url参数
        return nil;
    }
    
    NSArray* queryComps = [query componentsSeparatedByString:@"&"];
    if (!queryComps)
    {
        return nil;
    }
    
    NSMutableDictionary* dictQuery = [NSMutableDictionary dictionary];
    [queryComps enumerateObjectsUsingBlock:^(NSString*  _Nonnull queryComp, NSUInteger idx, BOOL * stop) {
        NSArray* pair = [queryComp componentsSeparatedByString:@"="];
        if (!pair || 2 < pair.count)
        {
            return;
        }
        NSString* key = pair[0];
        NSString* value = pair[1];
        
        if (0 == key.length || 0 == value.length) {
            return;
        }
        [dictQuery setValue:value forKey:key];
    }];
    
    return dictQuery;
}

@end
