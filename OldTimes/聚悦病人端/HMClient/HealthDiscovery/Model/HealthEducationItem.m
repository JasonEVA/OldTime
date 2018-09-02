//
//  HealthEducationItem.m
//  HMClient
//
//  Created by lkl on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthEducationItem.h"

@implementation HealthNotesItem

@end

@implementation HealthEducationItem

MJCodingImplementation

- (BOOL) isFineClass
{
    return (self.contentType == 2);
}

- (BOOL) isRecommand
{
    BOOL isRecommand = (self.topFlag &&
                        self.topFlag.length > 0 &&
                        [self.topFlag isEqualToString:@"Y"]);
   
    return isRecommand;
}

@end

@implementation HealthEducationPathHelper

+ (NSString*) healthEducationColumeCachePath
{
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSString* userDir = [PathHelper userDir:curUser.userId];
    
    NSString* cachePath = [userDir stringByAppendingPathComponent:@"educationColumes.plist"];
    return cachePath;
}

@end
