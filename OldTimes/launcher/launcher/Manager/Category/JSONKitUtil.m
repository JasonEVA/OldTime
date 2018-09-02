//
//  JSONKitUtil.m
//  launcher
//
//  Created by williamzhang on 16/3/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JSONKitUtil.h"

@implementation NSString (ASJSONKitDeserializing)

- (id)mtc_objectFromJSONString {
    NSData *dataStr = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:dataStr options:NSJSONReadingAllowFragments error:NULL];
}

- (id)mtc_objectFromJSONStringWithReadingOptions:(NSJSONReadingOptions)readingOption {
    NSData *dataStr = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:dataStr options:readingOption error:NULL];
    
}

- (id)mtc_objectFromJSONStringWithReadingOptions:(NSJSONReadingOptions)readingOption error:(NSError *__autoreleasing *)error {
    NSData *dataStr = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:dataStr options:readingOption error:error];
}


@end

@implementation NSData (ASJSONKitDeserializing)

- (id)mtc_objectFromJSONData {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:NULL];
}

- (id)mtc_objectFromJSONDataWithReadingOptions:(NSJSONReadingOptions)readingOption {
    return [NSJSONSerialization JSONObjectWithData:self options:readingOption error:NULL];
}

- (id)mtc_objectFromJSONDataWithReadingOptions:(NSJSONReadingOptions)readingOption error:(NSError *__autoreleasing *)error {
    return [NSJSONSerialization JSONObjectWithData:self options:readingOption error:error];
}


@end