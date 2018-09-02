//
//  MeChangeUserNameRequest.m
//  Shape
//
//  Created by jasonwang on 15/10/26.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeChangeUserNameRequest.h"
#define Dict_Name  @"userName"

@implementation MeChangeUserNameRequest

- (void)prepareRequest
{
    self.action = @"authapi/setUserName";
    self.params[Dict_Name] = self.userName;
    [super prepareRequest];
}

@end
