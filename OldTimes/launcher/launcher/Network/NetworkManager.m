//
//  NetworkManager.m
//  launcher
//
//  Created by williamzhang on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "NetworkManager.h"

static NSInteger progressCount = 0;

@implementation NetworkManager

+ (void)addNetworkProgress {
    progressCount ++;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (void)removeNetworkProgress {
    progressCount --;
    if (progressCount < 0) {
        progressCount = 0;
    }
    if (progressCount <= 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end
