//
//  IMLoginOutRequest.m
//  launcher
//
//  Created by TabLiu on 15/10/30.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "IMLoginOutRequest.h"

@implementation IMLoginOutRequest

- (NSString *)action {
    return @"/loginout";
}

+ (void)logout {
    IMLoginOutRequest *request = [[IMLoginOutRequest alloc] init];
    [request requestDataCompletion:nil];
}

@end
