//
//  UserProfileModel+ProfileExtension.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserProfileModel+ProfileExtension.h"
#import <objc/runtime.h>

@implementation UserProfileModel (ProfileExtension)

- (NSString *)getHm_position {
    NSDictionary *dict = [self getProfileExtensionDict];
    if (!dict) {
        return @"";
    }
    return dict[@"position"];
}

- (NSString *)getHm_hospital {
    NSDictionary *dict = [self getProfileExtensionDict];
    if (!dict) {
        return @"";
    }
    return dict[@"hospital"];
}

- (NSDictionary *)getProfileExtensionDict {
    if (self.extension.length == 0 || !self.extension) {
        return nil;
    }
    return [self.extension mj_JSONObject];
}

@end
