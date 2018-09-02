//
//  AppendActionStatTask.m
//  HMDoctor
//
//  Created by Dee on 16/9/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AppendActionStatTask.h"

@implementation AppendActionStatTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postActionStatServiceUrl:@"addActionStat"];
    return postUrl;
}

- (void)makeTaskResult {
    
}

@end
