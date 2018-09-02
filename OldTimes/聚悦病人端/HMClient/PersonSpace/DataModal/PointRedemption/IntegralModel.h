//
//  IntegralModel.h
//  HMClient
//
//  Created by yinquan on 2017/7/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IntegralVIPLevel) {
    IntegralVIP_Normal,     //普通
    IntegralVIP_Steel,      //铁牌
    IntegralVIP_Bronze,     //铜牌
    IntegralVIP_Silver,
    IntegralVIP_Golden,
    IntegralVIP_Platinum,   //铂金
    IntegralVIP_Diamond,    //钻石
    IntegralVIP_Crown,      //皇冠
    
    IntegralVIPLevelCount,
};

@interface IntegralModel : NSObject

@property (nonatomic, assign) NSInteger addScore;
@property (nonatomic, assign) NSInteger totalScore;     //当前所有积分
@property (nonatomic, assign) NSInteger availableScore; //当前可用积分
@property (nonatomic, retain) NSString* remark;


@end

@interface IntegralSummaryModel : NSObject

@property (nonatomic, assign) NSInteger decTotalNum;    //截止12月31日获取积分
@property (nonatomic, assign) NSInteger hisTotalNum;    //历史总积分；
@property (nonatomic, assign) NSInteger junTotalNum;    //截止6月30日获取积分；
@property (nonatomic, assign) NSInteger nowTotalNum;    //当前可用积分
@property (nonatomic, assign) NSInteger todayNum;       //今日获取积分

- (NSInteger) vipLevel;
- (NSString*) vipLevelString;
@end
