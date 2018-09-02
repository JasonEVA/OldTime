//
//  SuperGroupListModel.m
//  MintcodeIM
//
//  Created by Dee on 16/6/27.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "SuperGroupListModel.h"
#import "NSDictionary+IMSafeManager.h"
static NSString *const t_modified = @"modified";
static NSString *const t_userName = @"userName";
static NSString *const t_nickName = @"nickName";
static NSString *const t_avatar   = @"avatar";
static NSString *const t_type     = @"type";
static NSString *const t_tag      = @"tag";

@implementation SuperGroupListModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.modeified = [[dict im_valueNumberForKey:t_modified] longLongValue];
        self.userName = [dict im_valueStringForKey:t_userName];
        self.nickName = [dict im_valueStringForKey:t_nickName];
        self.avatar = [dict im_valueStringForKey:t_avatar];
        self.type = [dict im_valueStringForKey:t_type];
        self.tag = [dict im_valueStringForKey:t_tag];
    }
    return self;
}

@end
