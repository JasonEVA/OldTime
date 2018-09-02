//
//  MissionListComponentModel.m
//  HMDoctor
//
//  Created by Dee on 16/6/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionListComponentModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
static NSString *const name = @"name";
static NSString *const body = @"body";
static NSString *const SHOW_ID = @"SHOW_ID";
static NSString *const T_STATUS = @"T_STATUS";
static NSString *const url = @"url";


@implementation MissionListComponentModel

- (instancetype)initWithDict:(NSDictionary  *)dict
{
    if (self = [super init])
    {
        if ([self judgeMentWithDict:dict Key:name])
        {
           self.name = [dict objectForKey:name];
        }
        
        if ([self judgeMentWithDict:dict Key:body])
        {
            NSString *bodyStr = [dict objectForKey:body];
            NSDictionary *body_dict = [bodyStr mj_JSONObject]
            ;
            self.body_show_id = [body_dict objectForKey:SHOW_ID];
            self.body_t_status = [body_dict objectForKey:T_STATUS];
        }
        
        if ([self judgeMentWithDict:dict Key:url])
        {
            self.url = [dict objectForKey:url];
        }
    }
    return self;
}


- (BOOL)judgeMentWithDict:(NSDictionary *)dict Key:(NSString *)key
{
    if ([dict objectForKey:key] != [NSNull null] && [dict objectForKey:key] != NULL)
    {
        return YES;
    }
    return NO;
}

@end
