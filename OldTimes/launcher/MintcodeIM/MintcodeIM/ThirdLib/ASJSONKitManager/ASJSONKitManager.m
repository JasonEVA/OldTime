//
//  ASJSONKitManager.m
//  ASJSONKit
//
//  Created by Andrew Shen on 15/9/18.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "ASJSONKitManager.h"
#pragma mark Deserializing methods
@implementation NSString (ASJSONKitDeserializing)

- (id)mt_im_objectFromJSONString {
    NSData *dataStr = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:dataStr options:NSJSONReadingAllowFragments error:NULL];
}

- (id)mt_im_objectFromJSONStringWithReadingOptions:(NSJSONReadingOptions)readingOption {
    NSData *dataStr = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:dataStr options:readingOption error:NULL];

}

- (id)mt_im_objectFromJSONStringWithReadingOptions:(NSJSONReadingOptions)readingOption error:(NSError *__autoreleasing *)error {
    NSData *dataStr = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:dataStr options:readingOption error:error];
}


@end

@implementation NSData (ASJSONKitDeserializing)

- (id)mt_im_objectFromJSONData {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:NULL];
}

- (id)mt_im_objectFromJSONDataWithReadingOptions:(NSJSONReadingOptions)readingOption {
    return [NSJSONSerialization JSONObjectWithData:self options:readingOption error:NULL];
}

- (id)mt_im_objectFromJSONDataWithReadingOptions:(NSJSONReadingOptions)readingOption error:(NSError *__autoreleasing *)error {
    return [NSJSONSerialization JSONObjectWithData:self options:readingOption error:error];
}


@end
