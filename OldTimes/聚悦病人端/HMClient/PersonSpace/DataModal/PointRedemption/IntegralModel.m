//
//  IntegralModel.m
//  HMClient
//
//  Created by yinquan on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralModel.h"

@implementation IntegralModel

@end

@implementation IntegralSummaryModel

- (NSInteger) vipLevel
{
    IntegralVIPLevel level = IntegralVIP_Normal;
    if (self.hisTotalNum <= 500) {
        level = IntegralVIP_Normal;
        return level;
    }
    if (self.hisTotalNum <= 1000) {
        level = IntegralVIP_Steel;
        return level;
    }
    if (self.hisTotalNum <= 3000) {
        level = IntegralVIP_Bronze;
        return level;
    }
    if (self.hisTotalNum <= 6000) {
        level = IntegralVIP_Silver;
        return level;
    }
    if (self.hisTotalNum <= 10000) {
        level = IntegralVIP_Golden;
        return level;
    }
    if (self.hisTotalNum <= 20000) {
        level = IntegralVIP_Platinum;
        return level;
    }
    if (self.hisTotalNum <= 20000) {
        level = IntegralVIP_Diamond;
        return level;
    }
    level = IntegralVIP_Crown;
    return level;
}

- (NSString*) vipLevelString
{
    NSString* levelString = @"";
    switch ([self vipLevel])
    {
        case IntegralVIP_Normal:
        {
            levelString = @"普通会员";
            break;
        }
        case IntegralVIP_Steel:
        {
            levelString = @"铁牌会员";
            break;
        }
        case IntegralVIP_Bronze:
        {
            levelString = @"铜牌会员";
            break;
        }
        case IntegralVIP_Silver:
        {
            levelString = @"银牌会员";
            break;
        }
        case IntegralVIP_Golden:
        {
            levelString = @"金牌会员";
            break;
        }
        case IntegralVIP_Platinum:
        {
            levelString = @"铂金会员";
            break;
        }
        case IntegralVIP_Diamond:
        {
            levelString = @"钻石会员";
            break;
        }
        case IntegralVIP_Crown:
        {
            levelString = @"皇冠会员";
            break;
        }
        default:
            break;
    }
    return levelString;
}
@end
