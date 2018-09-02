//
//  FriendInfo.m
//  HMClient
//
//  Created by yinqaun on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "FriendInfo.h"

@implementation FriendInfo

- (NSString*) mobile
{
    if (_relationUserDet)
    {
        return _relationUserDet.mobile;
    }
    return nil;
}

- (NSInteger) userId
{
    if (_relationUserDet)
    {
        return _relationUserDet.userId;
    }
    return 0;
}
@end
